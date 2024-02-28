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
  AccelerometerService serv = AccelerometerService();
  void shittyFunc() {
    serv.printValues();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.hardEdge,
      shadowColor: Colors.white,
      child: InkWell(
          splashColor: Colors.white30.withAlpha(30),
          onTap: () {
                    shittyFunc();
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
}
