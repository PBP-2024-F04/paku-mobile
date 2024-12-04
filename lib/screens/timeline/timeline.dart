import 'package:flutter/material.dart';
import 'package:paku/colors.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timeline"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            SearchBar(
              hintText: 'Search...',
              elevation: const WidgetStatePropertyAll(0),
              shape: const WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(
                    color: TailwindColors.mossGreenDark,
                    width: 2,
                  ),
                ),
              ),
              trailing: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TailwindColors.sageDark,
        foregroundColor: Colors.white,
        onPressed: () {},
        child: const Icon(Icons.draw),
      )
    );
  }
}
