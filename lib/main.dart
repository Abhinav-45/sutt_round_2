import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sutt_round_2/UI/home_screen.dart';
import 'package:sutt_round_2/UI/splash_screen.dart';
import 'package:sutt_round_2/UI/details_screen.dart';
import 'Provider/provider.dart';

class MovieSearchApp extends StatelessWidget {

  final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/details/:imdbId',
        builder: (context, state) {
          final movieId = state.pathParameters['imdbId'];
          return MovieDetailsScreen(imdbId: movieId ?? '');
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenModel(_router)),
        ChangeNotifierProvider(create: (_) => HomeScreenModel()),
        ChangeNotifierProvider(create: (_) => MovieDetailsProvider()),
      ],
      child: MaterialApp.router(
          routerConfig: _router
      ),
    );
  }
}

void main() {
  runApp(MovieSearchApp());
}
