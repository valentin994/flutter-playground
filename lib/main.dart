import 'package:flutter/material.dart';
import 'package:hello_world/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(title: "IndoorNav", home: HomeScreen()),
  );
}
