import 'package:flutter/material.dart';
import 'package:hello_world/movement_direction.dart';

void main(){
    WidgetsFlutterBinding.ensureInitialized();
    runApp(MaterialApp(title: "Test App", 
      home: Scaffold(body: Container(
       decoration: const BoxDecoration(
         gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orangeAccent, Colors.deepOrangeAccent]
              )
             ),
       child: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [ 
             const Text('Data', style: 
               TextStyle(fontSize: 34, color: Colors.white),
             ),
             MovementDetection(storage: AccelStorage()),
           ]
         ),
       ), 
            ),
          ),
        ),
    );
}


