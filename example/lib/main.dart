import 'package:flutter/material.dart';
import 'package:height_dial_picker/height_dial_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: HeightDialPicker(
            selectedColor: Colors.orange,
            backgroundColor: Colors.black,
            smallTickColor: Colors.grey,
            bigTickColor: Colors.white,
            centerLineColor: Colors.grey,
            selectedTickColor: Colors.blue,
            labelTextColor: Colors.white,
            onChanged: (value, unit) {},
          )
        ),
      ),
    );
  }
}