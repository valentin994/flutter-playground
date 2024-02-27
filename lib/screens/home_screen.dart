import 'package:flutter/material.dart';
import 'package:hello_world/ui/elevated_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IndoorNav'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.orangeAccent, Colors.deepOrangeAccent])),
        child: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedCard(title: 'Accelerometer', x: 0.1, y: 0.2, z: 0.3),
          ]),
        ),
      ),
    );
  }
}
