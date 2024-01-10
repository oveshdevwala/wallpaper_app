// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

List<String> listCategory = [
  'Winter',
  'Gradient',
  'Paper',
  'Trees',
  'School',
  'Cooking',
  'Smoke',
  'Walking',
  'Spring',
  'Love',
  'Business-Meeting',
  'Burj-Khalifa',
  'Graphic-Design',
  'Exercise',
  'London',
  'January',
  'Learning',
  'Hacker',
  'Team',
  'Winter',
];
List<ColorModel> listColorModel = [
  ColorModel(color: Colors.red, name: 'Red', colorValue: 'F44336'),
  ColorModel(color: Colors.orange, name: 'Orange', colorValue: 'FF9800'),
  ColorModel(color: Colors.yellow, name: 'Yellow', colorValue: 'FFEB3B'),
  ColorModel(color: Colors.green, name: 'Green', colorValue: '4CAF50'),
  ColorModel(
      color: const Color(0xff30D5C8), name: 'Turquoise', colorValue: '30D5C8'),
  ColorModel(color: Colors.blue, name: 'Blue', colorValue: '2196F3'),
  ColorModel(
      color: const Color(0xff7F00FF), name: 'Violet', colorValue: '7F00FF'),
  ColorModel(color: Colors.pink, name: 'Pink', colorValue: 'E91E63'),
  ColorModel(color: Colors.brown, name: 'Brown', colorValue: '795548'),
  ColorModel(color: Colors.black, name: 'Black', colorValue: '000000'),
  ColorModel(color: Colors.grey, name: 'Grey', colorValue: '9E9E9E'),
  ColorModel(color: Colors.white, name: 'White', colorValue: 'FFFFFF'),
];

class ColorModel {
  Color? color;
  String? name;
  String? colorValue;
  ColorModel({
    required this.colorValue,
    required this.color,
    required this.name,
  });
}

