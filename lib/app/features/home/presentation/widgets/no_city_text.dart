import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoCity extends StatelessWidget {
  const NoCity({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.sentiment_dissatisfied,
            size: 60,
          ),
          Text(
            'No hay Ciudades para mostrar!',
            style: GoogleFonts.poppins(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
