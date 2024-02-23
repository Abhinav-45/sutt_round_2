import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sutt_round_2/UI/home_screen.dart';
import 'package:sutt_round_2/UI/splash_screen.dart';
import 'package:sutt_round_2/UI/details_screen.dart';
import 'package:sutt_round_2/Data Storage and API Calls/get_movie_by_title.dart';

class movie_search_app extends StatelessWidget {

  final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => splashScreen(),
      ),
      GoRoute(
        path: '/details', // Define a dynamic segment for the movie title
        builder: (context, state) => DetailsScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}




void main() {
  runApp(movie_search_app());
}

