import 'dart:async';
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
  UserAccelerometerEvent? _userAccelerometerEvent;
  DateTime? _userAccelerometerUpdateTime;
  int? _userAccelerometerLastInterval;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String userX = "";
  Duration duration = const Duration(seconds: 5);
  String num = '';
  List list = [];
  void showAccel() {
      const Duration duration = Duration(seconds: 5);
      DateTime endTime = DateTime.now().add(duration);

      Timer.periodic(Duration(milliseconds: 10), (Timer timer) {
        if (DateTime.now().isBefore(endTime)) {
          num = _userAccelerometerEvent?.x.toStringAsFixed(3)??'';
          list.add(num);
          print('Function running...');
        } else {
          timer.cancel();
          var listLen = list.length;
          print('Number of items $listLen');
        }
      });
    }
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  Duration sensorInterval = SensorInterval.normalInterval;
  @override
  Widget build(context) {
      return Column(children: [
            Text(_userAccelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
            Text(num),
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
              context: context,
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
  }
}
