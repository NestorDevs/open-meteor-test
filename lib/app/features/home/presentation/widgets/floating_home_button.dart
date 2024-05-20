import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FloatingHomeButton extends StatelessWidget {
  const FloatingHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.go('/home/city'),
      child: const Icon(Icons.location_city),
    );
  }
}
