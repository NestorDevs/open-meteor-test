import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoCard extends StatelessWidget {
  final String temperature;
  final String cityName;

  const InfoCard(
      {super.key, required this.temperature, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              temperature,
              style: googleStyle(),
            ),
            const SizedBox(height: 8),
            Text(
              cityName,
              style: googleStyle().copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle googleStyle() {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }
}
