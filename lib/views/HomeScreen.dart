import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lab19/components/TextEntry.dart';
import 'package:lab19/components/customButton.dart';
import 'package:lab19/Services/Location/Permissions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController? startLongitude = TextEditingController();
  TextEditingController? startLatitude = TextEditingController();
  double? distanceInMeters;
  Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          TextEntry(
            title: "Enter your longitude",
            controller: startLongitude,
          ),
          SizedBox(
            height: 50,
          ),
          TextEntry(
            title: "Enter your latitude",
            controller: startLatitude,
          ),
          SizedBox(
            height: 50,
          ),
          customButton(
            title: "Calculate",
            onPressed: () async {
              setState(() {});
              LocationPermission permission =
                  await Geolocator.checkPermission();
              if (permission.name == "denied") {
                Geolocator.requestPermission();
              } else {
                try {
                  await determinePosition();
                  position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);

                  setState(() {});
                } catch (e) {
                  print(e.toString());
                  Builder(
                      builder: (BuildContext context) =>
                          Container(child: Text(e.toString())));
                }
                distanceInMeters = Geolocator.distanceBetween(
                    double.parse(startLatitude!.text),
                    double.parse(startLongitude!.text),
                    position!.latitude,
                    position!.longitude);
              }
              setState(() {});

              showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: Text(
                          distanceInMeters.toString(),
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
