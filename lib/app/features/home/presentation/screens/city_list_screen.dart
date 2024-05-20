import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/list_cities.dart';

class CityListScreen extends ConsumerWidget {
  const CityListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityFavorite = ref.watch(favoriteCitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Listado de Ciudades',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          Text(
            'Selecciona tu Ciudad favorita!',
            style: GoogleFonts.poppins(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return ListTile(
                    title: Text(
                      city,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        if (cityFavorite.contains(city)) {
                          ref.read(favoriteCitiesProvider.notifier).state =
                              cityFavorite.where((c) => c != city).toList();
                        } else {
                          ref.read(favoriteCitiesProvider.notifier).state = [
                            ...cityFavorite,
                            city
                          ];
                        }

                        Navigator.pop(context);
                      },
                      color: ref
                              .read(favoriteCitiesProvider.notifier)
                              .state
                              .contains(city)
                          ? Colors.red
                          : Colors.grey,
                      icon: const Icon(
                        Icons.favorite,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Definir un provider para manejar el estado de las ciudades favoritas
final favoriteCitiesProvider = StateProvider<List<String>>((ref) => []);
