import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget{
  const GradientContainer({super.key});
  @override
  Widget build(context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orangeAccent, Colors.deepOrangeAccent]
          ),
        ),
        child: const Center(
          child: Text('Sample', style: TextStyle(
            color: Colors.white,
            fontSize: 24
                ),
              ),
            ), 
          );
  }
}
