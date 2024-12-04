import 'package:flutter/material.dart';
import 'package:paku/colors.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timeline"),
      ),
      body: const Text("Timeline"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TailwindColors.sageDark,
        foregroundColor: Colors.white,
        onPressed: () {},
        child: const Icon(Icons.draw),
      )
    );
  }
}
