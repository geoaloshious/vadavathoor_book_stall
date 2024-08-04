import 'package:flutter/material.dart';

class UnderDevelopment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(
        Icons.construction,
        size: 100,
        color: Colors.grey,
      ),
      Text(
        'FEATURE UNDER DEVELOPMENT',
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey),
      )
    ]);
  }
}
