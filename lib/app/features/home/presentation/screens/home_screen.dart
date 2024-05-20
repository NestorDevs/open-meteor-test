import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_meteor/app/features/home/data/repositories/weather_repository.dart';

import '../../../../global_widgets/global_widgets.dart';
import '../../../authentication/presentation/controllers/email_password_sign_in_controller.dart';
import '../widgets/widgets.dart';
import 'city_list_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(emailPasswordSignInControllerProvider);
    final favorites = ref.watch(favoriteCitiesProvider);
    final weatherRepo = ref.watch(weatherRepositoryProvider);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          text: 'Open Meteor',
        ),
        actions: [
          buttonTap(state, context, ref),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          FutureBuilder<List<Map<String, dynamic>>>(
              future: Future.wait(favorites
                  .map((city) => weatherRepo.fetchWeatherData(city))
                  .toList()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Error al cargar datos del clima');
                } else {
                  final weatherDataList = snapshot.data!;
                  double minTemp = double.infinity;
                  double maxTemp = double.negativeInfinity;
                  String minTempCity = '';
                  String maxTempCity = '';

                  for (int i = 0; i < favorites.length; i++) {
                    final city = favorites[i];
                    final weatherData = weatherDataList[i];
                    final minMaxTemp =
                        weatherRepo.getMinMaxTemperature(weatherData);

                    if (minMaxTemp['min']! < minTemp) {
                      minTemp = minMaxTemp['min']!;
                      minTempCity = city;
                    }

                    if (minMaxTemp['max']! > maxTemp) {
                      maxTemp = minMaxTemp['max']!;
                      maxTempCity = city;
                    }
                  }
                  return weatherDataList.isEmpty
                      ? buildRowEmpty(favorites)
                      : buildRowData(
                          minTemp,
                          minTempCity,
                          favorites,
                          maxTemp,
                          maxTempCity,
                        );
                }
              }),
          SizedBox(height: size.height * 0.1),
          const MisCiudades(),
          const SizedBox(height: 10),
          favorites.isEmpty
              ? const NoCity()
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final city = favorites[index];
                        return Column(
                          children: [
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: FutureBuilder<Map<String, dynamic>>(
                                future: weatherRepo.fetchWeatherData(city),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ListTile(
                                      title: Text(
                                        city,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: const Text(
                                          'Cargando datos del clima...'),
                                    );
                                  } else if (snapshot.hasError) {
                                    return ListTile(
                                      title: Text(
                                        city,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: const Text(
                                          'Error al cargar datos del clima'),
                                    );
                                  } else {
                                    final weatherData = snapshot.data!;
                                    final currentWeather =
                                        weatherData['current_weather'];
                                    final temperature =
                                        currentWeather['temperature'];

                                    return ListTile(
                                      title: Text(
                                        city,
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ),
                                      subtitle:
                                          Text('Temperatura: $temperature°C'),
                                      trailing: IconButton(
                                          onPressed: () {
                                            ref
                                                    .read(favoriteCitiesProvider
                                                        .notifier)
                                                    .state =
                                                favorites
                                                    .where((c) => c != city)
                                                    .toList();
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: const FloatingHomeButton(),
    );
  }

  Row buildRowEmpty(List<String> favorites) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const InfoCard(
          temperature: '0°C',
          cityName: 'Sin Datos',
        ),
        InfoCard(
          temperature: '${favorites.length}',
          cityName: 'Ciudades',
        ),
        const InfoCard(
          temperature: '0°C',
          cityName: 'Sin Datos',
        ),
      ],
    );
  }

  Widget buildRowData(double minTemp, String minTempCity,
      List<String> favorites, double maxTemp, String maxTempCity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InfoCard(
          temperature: '$minTemp°C',
          cityName: minTempCity,
        ),
        InfoCard(
          temperature: '${favorites.length}',
          cityName: 'Ciudades',
        ),
        InfoCard(
          temperature: '$maxTemp°C',
          cityName: maxTempCity,
        ),
      ],
    );
  }

  IconButton buttonTap(
      AsyncValue<void> state, BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: state.isLoading
            ? null
            : () async {
                final logout = await showAlertDialog(
                  context: context,
                  title: 'Esta Seguro?',
                  cancelActionText: 'Cancelar',
                  defaultActionText: 'OK',
                );
                if (logout == true) {
                  ref
                      .read(emailPasswordSignInControllerProvider.notifier)
                      .signOut();
                }
              },
        icon: const Icon(
          Icons.exit_to_app_rounded,
        ));
  }
}
