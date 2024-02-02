import 'package:flutter/material.dart';
import 'gradient_container.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerWidget extends StatefulWidget {
    const AccelerometerWidget({super.key});
    @override
    State<StatefulWidget> createState() {
        return _AccelerometerState();
    }    
}

class _AccelerometerState extends State<AccelerometerWidget> {
    var valueList = [];

    @override
    void initState() {
      super.initState();

      accelerometerEventStream(samplingPeriod: const Duration(seconds: 2)).listen(
      (AccelerometerEvent event) {
            print(event);
          });
    }

    @override
    Widget build(context) {
        return const Text('Accel data:', style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 24
                ),
        );
    }
}


void main() {
  runApp(
   const MaterialApp(
    home: Scaffold(
      body: Column(
        children: [
          GradientContainer("Something"),
          AccelerometerWidget()
            ],
          ), 
        ),
      ),
    );
}

