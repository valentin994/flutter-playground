import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  const GradientContainer(this.text, {super.key});

  final String text;

  @override
  Widget build(context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orangeAccent, Colors.deepOrangeAccent]),
      ),
      child: Center(
        child: Text(
          'Accel data:\n $text',
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
