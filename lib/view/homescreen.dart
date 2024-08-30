import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/model/api%20functions/apiconstants.dart';
import 'package:weather/model/fonttheme.dart';
import 'package:weather/provider/main_provider.dart';
import 'package:weather/view/mapscreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainPro = context.watch<MainProvider>();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MapScreen(),
            ));
          },
          child: const Icon(Icons.location_on),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: RefreshIndicator(
            color: Colors.black,
            onRefresh: () => mainPro.currentLocation(),
            child: ListView(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    mainPro.name,
                    style: FontTheme.superHeading,
                  ),
                ),
                Center(
                  child: Image.network(
                    "${ApiConstants.iconApi + mainPro.data["weather"][0]["icon"]}@4x.png",
                  ),
                ),
                Center(
                  child: Text(
                    mainPro.temparature,
                    style: FontTheme.superHeading,
                  ),
                ),
                Center(
                  child: Text(
                    mainPro.data["weather"][0]["main"],
                    style: FontTheme.heading,
                  ),
                ),
                Center(
                  child: Text(
                    " Feels like ${mainPro.changeInToCelcius(mainPro.data["main"]["feels_like"])}",
                    style: FontTheme.subHeading,
                  ),
                ),
                Center(
                  child: Text(
                    mainPro.data["weather"][0]["description"],
                    style: FontTheme.subHeading,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Min Temp",
                      style: FontTheme.heading,
                    ),
                    Text(
                      "Max Temp",
                      style: FontTheme.heading,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      mainPro
                          .changeInToCelcius(mainPro.data["main"]["temp_min"]),
                      style: FontTheme.subHeading,
                    ),
                    Text(
                      mainPro
                          .changeInToCelcius(mainPro.data["main"]["temp_max"]),
                      style: FontTheme.subHeading,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.water_drop,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      mainPro.data["main"]["humidity"].toString(),
                      style: FontTheme.subHeading2,
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
