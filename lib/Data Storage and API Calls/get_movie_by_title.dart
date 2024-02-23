//
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
//
//
//
// Future<void> _fetchData({String title = ''}) async {
//   var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
//   var headers = {
//     'Type': 'get-movies-by-title',
//     'X-RapidAPI-Key': 'd203b1f42fmsh42f7296e388ca8fp17bf73jsne4448fa561f9',
//     'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
//   };
//
//   var params = {'title': title.isNotEmpty ? title : 'all'}; // Set default value to 'all' if title is empty
//
//   var response = await http.get(url.replace(queryParameters: params), headers: headers);
//
//   if (response.statusCode == 200) {
//     print(json.decode(response.body));
//   } else {
//     print('Request failed with status: ${response.statusCode}.');
//   }
// }
//
// void main() {
//   _fetchData(); // Without specifying title, it will default to 'all'
// }

// api_service.dart

// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class ApiService {
//   static Future<List<String>> fetchMovieTitles(String title) async {
//     var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
//     var headers = {
//       'Type': 'get-movies-by-title',
//       'X-RapidAPI-Key': 'd203b1f42fmsh42f7296e388ca8fp17bf73jsne4448fa561f9',
//       'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
//     };
//     var params = {'title': title.isNotEmpty ? title : 'all'};
//
//     var response = await http.get(url.replace(queryParameters: params), headers: headers);
//
//     if (response.statusCode == 200) {
//       var responseData = json.decode(response.body);
//       List<dynamic> movies = responseData['movie_results'];
//       List<String> titles = movies.map((movie) => movie['title'] as String).toList();
//       return titles;
//     } else {
//       throw Exception('Failed to fetch data');
//     }
//   }
// }
// api_service.dart

// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class apiService {
//   static Future<List<_Movie>> fetchMovies(String title) async {
//     var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
//     var headers = {
//       'Type': 'get-movies-by-title',
//       'X-RapidAPI-Key': 'd203b1f42fmsh42f7296e388ca8fp17bf73jsne4448fa561f9',
//       'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
//     };
//     var params = {'title': title.isNotEmpty ? title : 'all'};
//
//     var response = await http.get(url.replace(queryParameters: params), headers: headers);
//
//     if (response.statusCode == 200) {
//       var responseData = json.decode(response.body);
//       List<dynamic> moviesData = responseData['movie_results'];
//       List<_Movie> movies = moviesData.map((movie) => _Movie.fromJson(movie)).toList();
//       return movies;
//     } else {
//       throw Exception('Failed to fetch data');
//     }
//   }
// }
//
// class _Movie {
//   final String title;
//   final String imageUrl;
//
//   _Movie({required this.title, required this.imageUrl});
//
//   factory _Movie.fromJson(Map<String, dynamic> json) {
//     return _Movie(
//       title: json['title'] as String,
//       imageUrl: '', // Initialize with empty string; imageUrl will be fetched later
//     );
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Movie>> fetchNowPlayingMovies() async {
    var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
    var headers = {
      'Type': 'get-nowplaying-movies',
      'X-RapidAPI-Key': '46f993160emsh83d6ed7ad64633ap1c2e95jsn9318cf758c3f',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };
    var params = {'page': '1'};

    var response = await http.get(url.replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> moviesData = responseData['movie_results']; // Retrieve movie data
      List<Movie> movies = [];

      for (var movieData in moviesData) {
        String title = movieData['title'];
        String imdbId = movieData['imdb_id'];
        String year = movieData['year'];
        String? imageUrl = await _fetchImageUrl(imdbId); // Fetch image URL separately
        movies.add(Movie(title: title, imageUrl: imageUrl, imdbId: imdbId, year: year));
      }

      return movies;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  static Future<List<Movie>> fetchMovies(String title) async {
    var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
    var headers = {
      'Type': 'get-movies-by-title',
      'X-RapidAPI-Key': '46f993160emsh83d6ed7ad64633ap1c2e95jsn9318cf758c3f',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };
    var params = {'title': title.isNotEmpty ? title : 'all'};

    var response = await http.get(url.replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> moviesData = responseData['movie_results'];
      List<Movie> movies = [];

      for (var movieData in moviesData) {
        String title = movieData['title'];
        String imdbId = movieData['imdb_id'];
        String year = movieData['year'].toString();
        String? imageUrl = await _fetchImageUrl(imdbId);
        movies.add(Movie(title: title, imageUrl: imageUrl, imdbId: imdbId, year: year));
      }

      return movies;
    } else {
      throw Exception('Failed to fetch data');
    }
  }


  static Future<String?> _fetchImageUrl(String imdbId) async {
    var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
    var headers = {
      'Type': 'get-movies-images-by-imdb',
      'X-RapidAPI-Key': '46f993160emsh83d6ed7ad64633ap1c2e95jsn9318cf758c3f',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };
    var params = {'movieid': imdbId};

    var response = await http.get(url.replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      // print (responseData);
      return responseData['poster'];
    } else {
      print('Failed to fetch image for IMDb ID: $imdbId');
      return null;
    }
  }

  static Future<Map<String, dynamic>> fetchMovieDetails(String imdbId) async {
    var url = Uri.https('movies-tv-shows-database.p.rapidapi.com', '/', {'movieid': imdbId});

    var headers = {
      'Type': 'get-movie-details',
      'X-RapidAPI-Key': '46f993160emsh83d6ed7ad64633ap1c2e95jsn9318cf758c3f',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}

class Movie {
  final String title;
  final String year;
  final String imdbId;
  final String? imageUrl;

  Movie({
    required this.title,
    required this.year,
    required this.imdbId,
    this.imageUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      year: json['year'].toString(),
      imdbId: json['imdb_id'] as String,
    );
  }
}



