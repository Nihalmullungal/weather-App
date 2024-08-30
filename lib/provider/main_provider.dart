import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/model/api%20functions/apiconstants.dart';
import 'package:weather/view/homescreen.dart';
import 'package:http/http.dart' as http;

class MainProvider extends ChangeNotifier {
  dynamic data;
  String temparature = "";
  LocationPermission? permission;
  Completer<GoogleMapController> _controller = Completer();
  String name = "location";
  LatLng location = const LatLng(0, 0);
  Set<Marker> markers = {
    const Marker(markerId: MarkerId("location"), position: LatLng(0, 0))
  };

  navigation(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3), () async {
      await currentLocation();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx1) {
        return const HomeScreen();
      }));
    });
  }

  Future<void> currentLocation() async {
    permission = await Geolocator.checkPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    location = LatLng(position.latitude, position.longitude);
    markers = {
      Marker(
          markerId: const MarkerId("location"),
          draggable: true,
          onDragEnd: (value) =>
              location = LatLng(value.latitude, value.longitude),
          position: LatLng(position.latitude, position.longitude))
    };
    await fetchWeather();
  }

  Future<void> newPosition(LatLng arg) async {
    log(arg.toString());
    location = LatLng(arg.latitude, arg.longitude);
    markers = {
      Marker(
          draggable: true,
          onDragEnd: (value) =>
              location = LatLng(value.latitude, value.longitude),
          markerId: const MarkerId("location"),
          position: LatLng(arg.latitude, arg.longitude))
    };
    notifyListeners();
  }

  Future<void> fetchWeather() async {
    final result = await http.get(Uri.parse(ApiConstants.api +
        ApiConstants.lat +
        location.latitude.toString() +
        ApiConstants.lon +
        location.longitude.toString() +
        ApiConstants.apiKeyAssign +
        ApiConstants.apiKey));
    data = jsonDecode(result.body);
    name =
        data["name"] == null || data["name"] == "" ? "location" : data["name"];
    temparature = changeInToCelcius(data["main"]["temp"]);
    log("-----------------$data");
    notifyListeners();
  }

  changeInToCelcius(double temp) {
    return "${(temp - 273.15).toString().substring(0, 5)} °C";
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
}
