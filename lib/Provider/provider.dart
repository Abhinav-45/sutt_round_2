// splash_screen_model.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../Data Storage and API Calls/service.dart';
import '../Models/imageUrls.dart';
import '../Models/movie.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class SplashScreenModel with ChangeNotifier {
  final GoRouter _router;

  SplashScreenModel(this._router);

  void initiateTask() async {
    // Simulating an asynchronous task with a delay
    await Future.delayed(Duration(seconds: 2));

    // Navigate to the home screen after the task is complete
    _router.go('/home');
  }
}


// home_screen_model.dart


class HomeScreenModel extends ChangeNotifier {
  late TextEditingController _searchController;

  TextEditingController get searchController => _searchController;
  bool _showResults = false;
  bool _showBackToNowPlayingButton = false;

  Future<List<Movie>>? _moviesFuture;

  Future<List<Movie>>? get moviesFuture => _moviesFuture;
  bool get showResults => _showResults;
  bool get showBackToNowPlayingButton => _showBackToNowPlayingButton;

  HomeScreenModel() {
    _searchController = TextEditingController();
    _fetchNowPlayingMovies();
  }

  void _fetchNowPlayingMovies() {
    _moviesFuture = ApiService.fetchNowPlayingMovies();
    _showResults = true;
    _showBackToNowPlayingButton = false;
    notifyListeners();
  }

  void onSearchPressed(String searchText) {
    if (searchText.isNotEmpty) {
      _moviesFuture = ApiService.fetchMovies(searchText);
      _showResults = true;
      _showBackToNowPlayingButton = true;
    } else {
      _showResults = false;
      _showBackToNowPlayingButton = false;
    }
    notifyListeners();
  }

  void onBackToNowPlayingPressed() {
    _fetchNowPlayingMovies();
  }
}

// movie_details_model.dart


// detail_screen_model.dart






class MovieDetailsProvider extends ChangeNotifier {
  Map<String, dynamic>? _movieDetails;
  List<String> _imageUrls = [];
  int _currentImageIndex = 0;

  Map<String, dynamic>? get movieDetails => _movieDetails;
  List<String> get imageUrls => _imageUrls;
  int get currentImageIndex => _currentImageIndex;

  Future<void> fetchMovieDetails(String imdbId) async {
    try {
      var details = await ApiService.fetchMovieDetails(imdbId);
      _movieDetails = details;
      notifyListeners();
    } catch (error) {
      print('Error fetching movie details: $error');
    }
  }

  Future<void> fetchImageUrls(String imdbId) async {
    try {
      var imageUrlsData = await ApiService.fetchImageUrls(imdbId);
      if (imageUrlsData != null) {
        _imageUrls = [
          if (imageUrlsData.posterUrl != null) imageUrlsData.posterUrl!,
          if (imageUrlsData.fanartUrl != null) imageUrlsData.fanartUrl!,
        ];
      } else {
        _imageUrls = [
          'https://i.ibb.co/hXDHWc4/4.jpg',
          'i.ibb.co/hXDHWc4/4.jpg'
        ];
      }
      notifyListeners();
    } catch (error) {
      print('Error fetching image URLs: $error');
    }
  }

  void updateCurrentImageIndex(int index) {
    _currentImageIndex = index;
    notifyListeners();
  }
}





