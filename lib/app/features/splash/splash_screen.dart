import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateTo();
  }

  void _navigateTo() {
    Future.delayed(
      const Duration(milliseconds: 3500),
      () => context.go('/login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideInLeft(
              duration: const Duration(seconds: 3),
              child: Image.asset(
                Constants.logoClima,
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(height: 15),
            FadeInUp(
              duration: const Duration(seconds: 3),
              child: Text(
                'Open Meteor',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
