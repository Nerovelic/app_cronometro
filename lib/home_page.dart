import 'package:flutter/material.dart';
import 'cronometer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const Cronometer(),
      ),
    );
  }
}