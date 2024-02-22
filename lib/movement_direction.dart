import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:path/path.dart';

class AccelStorage {
  Future<String?> get _localPath async {
    final  directory = await getExternalStorageDirectory();
  
    return directory?.path;
  }
   
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/');
  }

  Future<File> writeCounter(Map data, String filename) async {
    final file = await _localFile;
    File updatedFile = File(join(file.path, filename));
    // Write the file
    return updatedFile.writeAsString(json.encode(data));
  }

}

class MovementDetection extends StatefulWidget{
  const MovementDetection({super.key, required this.storage});
  final AccelStorage storage;    

  @override
  State<MovementDetection> createState() => _MovementDetection(); 
}

class _MovementDetection extends State<MovementDetection>{
  UserAccelerometerEvent? _userAccelerometerEvent;
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;



  DateTime? _userAccelerometerUpdateTime;
  DateTime? _accelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;
  DateTime? _magnetometerUpdateTime;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  AccelStorage storage = AccelStorage();  

  int? _userAccelerometerLastInterval;
  int? _accelerometerLastInterval;
  int? _gyroscopeLastInterval;
  int? _magnetometerLastInterval;



  String running = "no";
  Duration duration = const Duration(seconds: 5);
  String num = '';
  List list = [];
  Map userAccelMap = {"x": [], "y": [], "z": []};
  Map accelMap = {"x": [], "y": [], "z": []};
  Map gyroMap = {"x": [], "y": [], "z": []};
  Map magnetoMap = {"x": [], "y": [], "z": []};

  void showAccel() {
      final mark = DateTime.timestamp();
      const Duration duration = Duration(seconds: 5);
      DateTime endTime = DateTime.now().add(duration);
      running = "yes";
      Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
        if (DateTime.now().isBefore(endTime)) {
          userAccelMap["x"].add(_userAccelerometerEvent?.x);
          userAccelMap["y"].add(_userAccelerometerEvent?.y);
          userAccelMap["z"].add(_userAccelerometerEvent?.z);
          
          accelMap["x"].add(_accelerometerEvent?.x);
          accelMap["y"].add(_accelerometerEvent?.y);
          accelMap["z"].add(_accelerometerEvent?.z);

          gyroMap["x"].add(_gyroscopeEvent?.x);
          gyroMap["y"].add(_gyroscopeEvent?.y);
          gyroMap["z"].add(_gyroscopeEvent?.z);

          magnetoMap["x"].add(_magnetometerEvent?.x);
          magnetoMap["y"].add(_magnetometerEvent?.y);
          magnetoMap["z"].add(_magnetometerEvent?.z);

        } else {
          timer.cancel();
          running = "no";
          storage.writeCounter(userAccelMap, "user_accel_map-$mark.json");
          storage.writeCounter(accelMap, "accel_map-$mark.json");
          storage.writeCounter(gyroMap, "gyro_map-$mark.json");
          storage.writeCounter(magnetoMap, "magneto_map-$mark.json");
        }
      });
    }
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  Duration sensorInterval = SensorInterval.normalInterval;
  @override
  Widget build(context) {
      return Column(children: [
            Text("Am i running: $running"),
            OutlinedButton(onPressed: showAccel, child: const Text('Click me senpai'))
        ],
    );
  }

 @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _userAccelerometerEvent = event;
            if (_userAccelerometerUpdateTime != null) {
              final interval = now.difference(_userAccelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _userAccelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _userAccelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context as BuildContext,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support User Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _accelerometerEvent = event;
            if (_accelerometerUpdateTime != null) {
              final interval = now.difference(_accelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _accelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _accelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context as BuildContext,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = DateTime.now();
          setState(() {
            _gyroscopeEvent = event;
            if (_gyroscopeUpdateTime != null) {
              final interval = now.difference(_gyroscopeUpdateTime!);
              if (interval > _ignoreDuration) {
                _gyroscopeLastInterval = interval.inMilliseconds;
              }
            }
          });
          _gyroscopeUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context as BuildContext,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: sensorInterval).listen(
        (MagnetometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _magnetometerEvent = event;
            if (_magnetometerUpdateTime != null) {
              final interval = now.difference(_magnetometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _magnetometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _magnetometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context as BuildContext,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Magnetometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }
}
