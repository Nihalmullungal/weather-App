import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather/provider/main_provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainPro = Provider.of<MainProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("close")),
            ElevatedButton(
                onPressed: () async {
                  await mainPro.fetchWeather();
                  Navigator.of(context).pop();
                },
                child: const Text("submit")),
          ],
        ),
      ),
      body: Consumer<MainProvider>(builder: (context, map, child) {
        return GoogleMap(
          onTap: (argument) async {
            await map.newPosition(argument);
          },
          initialCameraPosition:
              CameraPosition(target: mainPro.location, zoom: 5),
          markers: map.markers,
        );
      }),
    );
  }
}
