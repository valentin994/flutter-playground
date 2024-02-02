import 'package:flutter/material.dart';
import 'gradient_container.dart';
import 'package:sensors_plus/sensors_plus.dart';


var valueList = [];
var textToShow = "No data";
void accelData() {
    accelerometerEventStream(samplingPeriod: SensorInterval.normalInterval).listen((event) {
        textToShow = event.x.toString();
        });
}

void main() {
  runApp(
   const MaterialApp(
    home: Scaffold(
      body: GradientContainer(), 
        ),
      ),
    );
}

