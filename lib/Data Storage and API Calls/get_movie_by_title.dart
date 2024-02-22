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

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Movie>> fetchMovies(String title) async {
    var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
    var headers = {
      'Type': 'get-movies-by-title',
      'X-RapidAPI-Key': 'd203b1f42fmsh42f7296e388ca8fp17bf73jsne4448fa561f9',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };
    var params = {'title': title.isNotEmpty ? title : 'all'};

    var response = await http.get(url.replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> moviesData = responseData['movie_results'];
      List<Movie> movies = moviesData.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}

class Movie {
  final String title;
  final String imageUrl;

  Movie({required this.title, required this.imageUrl});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      imageUrl: '', // Initialize with empty string; imageUrl will be fetched later
    );
  }
}


