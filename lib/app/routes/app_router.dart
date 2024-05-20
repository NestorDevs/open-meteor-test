import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/authentication/auth_module.dart';
import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/home/presentation/screens/city_list_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/splash/splash_screen.dart';
import 'go_router_refresh_stream.dart';

part 'app_router.g.dart';

enum AppRoute {
  splash,
  login,
  home,
  city,
}

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.path;
      if (isLoggedIn) {
        if (path == '/login') {
          return '/home';
        }
      } else {
        if (path == '/home') {
          return '/login';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: LoginScreen(
            formType: EmailPasswordSignInFormType.signIn,
          ),
        ),
      ),
      GoRoute(
          path: '/home',
          name: AppRoute.home.name,
          pageBuilder: (context, state) => const MaterialPage(
                fullscreenDialog: true,
                child: HomeScreen(),
              ),
          routes: [
            GoRoute(
              path: 'city',
              name: AppRoute.city.name,
              builder: (context, state) => const CityListScreen(),
            ),
          ]),
    ],
  );
}
