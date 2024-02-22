// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// Future<void> fetchnowData() async {
//   var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
//   var headers = {
//     'Type': 'get-nowplaying-movies',
//     'X-RapidAPI-Key': 'd203b1f42fmsh42f7296e388ca8fp17bf73jsne4448fa561f9',
//     'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
//   };
//   var params = {'page': '1'};
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
//   fetchnowData();
// }

// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sutt_round_2/Data Storage and API Calls/get_movieimage_by_imdb.dart';

// api_service.dart

// api_service.dart

class ApiService {
  static Future<List<Movie>> fetchNowPlayingMovies() async {
    var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
    var headers = {
      'Type': 'get-nowplaying-movies',
      'X-RapidAPI-Key': 'd203b1f42fmsh42f7296e388ca8fp17bf73jsne4448fa561f9',
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

  static Future<String?> _fetchImageUrl(String imdbId) async {
    var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
    var headers = {
      'Type': 'get-movies-images-by-imdb',
      'X-RapidAPI-Key': 'd203b1f42fmsh42f7296e388ca8fp17bf73jsne4448fa561f9',
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



}

//     if (response.statusCode == 200) {
//       var responseData = json.decode(response.body);
//       List<dynamic> moviesData = responseData['movie_results'];
//       List<Movie> movies = moviesData.map<Movie>((json) => Movie.fromJson(json)).toList();
//       return movies;
//     } else {
//       throw Exception('Failed to fetch data');
//     }
//   }
// }



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
      year: json['year'] as String,
      imdbId: json['imdb_id'] as String,
    );
  }
}


