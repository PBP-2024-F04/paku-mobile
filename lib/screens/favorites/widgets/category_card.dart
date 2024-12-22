import 'package:flutter/material.dart';
import 'package:paku/colors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String category;

  const CategoryCard({super.key, required this.title, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: TailwindColors.yellowLightActive,  
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Ukuran font lebih kecil
              textAlign: TextAlign.center,  // Agar teks tidak meluber
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
