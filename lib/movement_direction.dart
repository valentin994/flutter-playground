import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelStorage {
  Future<String?> get _localPath async {
    final  directory = await getExternalStorageDirectory();
  
    return directory?.path;
  }
   
  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/accel_data.json');
  }

  Future<File> writeCounter(Map data) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(json.encode(data));
  }

}

class MovementDetection extends StatefulWidget{
  const MovementDetection({super.key, required this.storage});
  final AccelStorage storage;    

  @override
  State<MovementDetection> createState() => _MovementDetection(); 
}

class _MovementDetection extends State<MovementDetection>{
  String directionOnXAxis = "", directionOnYAxis = "", directionOnZAxis = "";
  Map accelMap = {'x': [], 'y': [], 'z': []};
  bool saved = false;
  int counter = 0;
  double x = 0, y = 0, z = 0;
  double userX = 0, userY = 0, userZ = 0;
  double gyroX = 0, gyroY = 0, gyroZ = 0;
  double magX = 0, magY = 0, magZ = 0;

  @override
  void initState() {
      accelerometerEventStream().listen(
        (AccelerometerEvent event) {
           if(counter < 10000){
               accelMap['x'].add(event.x);
               accelMap['y'].add(event.y);
               accelMap['z'].add(event.z);
           }
           if(counter==9999 && saved == false){
             print('I am trying to save');  
             widget.storage.writeCounter(accelMap);
             print('I HAVE SAVED');
             print(accelMap); 
             saved = true;
           }
           counter++;
           x = event.x;
           y = event.y;
           z = event.z;

           if (x > 1){
               directionOnXAxis = "Forward";
           }else if (x < 1){
               directionOnXAxis = "Back";
           }
           setState(() {

               });
          },
        );

      userAccelerometerEventStream().listen(
        (UserAccelerometerEvent event) {
           userX = event.x;
           userY = event.y;
           userZ = event.z;
           setState(() {

               });
          },
        );

      gyroscopeEventStream().listen(
        (GyroscopeEvent event) {
           gyroX = event.x;
           gyroY = event.y;
           gyroZ = event.z;
           setState(() {

               });
          },
        );

      magnetometerEventStream().listen(
        (MagnetometerEvent event) {
           magX = event.x;
           magY = event.y;
           magZ = event.z;
           setState(() {

               });
          },
        );

      super.initState();
  }
  @override
  Widget build(context) {
      return Column(
      children: [
        OutlinedButton(onPressed: () {},  
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white),
        shadowColor: MaterialStateProperty.all(Colors.white),
        side: MaterialStateProperty.all(const BorderSide(color: Colors.white))
          ),
        child: const Text("Start")
        )
      ],
    );
  }
}
