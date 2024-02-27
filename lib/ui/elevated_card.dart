import 'package:flutter/material.dart';

class ElevatedCard extends StatelessWidget {
  const ElevatedCard(
      {Key? key,
      required this.title,
      required this.x,
      required this.y,
      required this.z})
      : super(key: key);
  final String title;
  final double x, y, z;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.white,
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
                title,
                style: const TextStyle(color: Colors.black38),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                  'x = $x',
                  style: const TextStyle(fontSize: 18),
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  'y = $y',
                  style: const TextStyle(fontSize: 18),
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  'z = $z',
                  style: const TextStyle(fontSize: 18),
                ))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
