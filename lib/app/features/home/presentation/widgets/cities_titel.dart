import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MisCiudades extends StatelessWidget {
  const MisCiudades({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Mis ciudades',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
