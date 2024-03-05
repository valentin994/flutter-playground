import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/services/accelerometer_service.dart';

class ElevatedCard extends StatefulWidget {
  const ElevatedCard(
      {super.key,
      required this.title,
      required this.x,
      required this.y,
      required this.z});
  final String title;
  final double x, y, z;

  @override
  State<ElevatedCard> createState() => _ElevatedCardState();
}

class _ElevatedCardState extends State<ElevatedCard> {
  UserAccelerometerEvent? _userAccelerometerEvent;
  DateTime? _userAccelerometerUpdateTime;
  int? _userAccelerometerLastInterval;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  Duration sensorInterval = SensorInterval.normalInterval;

  List<double> xValues = [];
  List<double> yValues = [];
  List<double> zValues = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.hardEdge,
      shadowColor: Colors.white,
      child: InkWell(
          splashColor: Colors.white30.withAlpha(30),
          onTap: () {
            print('I have this $_userAccelerometerEvent.?x');
          },
          child: SizedBox(
            width: 300,
            height: 100,
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    widget.title,
                    style: const TextStyle(color: Colors.black38),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: Center(
                            child: Text(
                      'x = ${widget.x}',
                      style: const TextStyle(fontSize: 18),
                    ))),
                    Expanded(
                        child: Center(
                            child: Text(
                      'y = ${widget.y}',
                      style: const TextStyle(fontSize: 18),
                    ))),
                    Expanded(
                        child: Center(
                            child: Text(
                      'z = ${widget.z}',
                      style: const TextStyle(fontSize: 18),
                    ))),
                  ],
                )
              ],
            ),
          )),
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
