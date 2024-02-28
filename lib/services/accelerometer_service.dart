import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';

class AccelerometerService extends ChangeNotifier {
  // ignore: unused_field
  AccelerometerEvent? _accelerometerEvent;
  DateTime? _accelerometerUpdateTime;
  static const Duration _ignoreDuration = Duration(milliseconds: 30);
  // ignore: unused_field
  int? _accelerometerLastInterval;

  AccelerometerService() {
    _listenForAccelerometerEvents();
  }

  void _listenForAccelerometerEvents() async {
    // Use StreamSubscription to manage subscription lifecycle
    accelerometerEventStream(samplingPeriod: SensorInterval.normalInterval)
        .listen(
      (AccelerometerEvent event) {
        final now = DateTime.now();
        _accelerometerEvent = event;

        // Check for update interval if previous update exists
        if (_accelerometerUpdateTime != null) {
          final interval = now.difference(_accelerometerUpdateTime!);
          if (interval > _ignoreDuration) {
            _accelerometerLastInterval = interval.inMilliseconds;
          }
        }
        _accelerometerUpdateTime = now;
      },
    );
  }

  void printValues() {
    print('The value: $_accelerometerEvent?.x');
  }
}
