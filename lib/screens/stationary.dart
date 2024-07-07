import 'package:flutter/material.dart';

class Stationary extends StatefulWidget {
  const Stationary({super.key});

  @override
  State<Stationary> createState() => _StationaryState();
}

class _StationaryState extends State<Stationary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Stationary'));
  }
}
