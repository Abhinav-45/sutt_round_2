import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/imageUrls.dart';
import '../Models/movie.dart';


class ApiService {

  static Future<List<Movie>> fetchNowPlayingMovies() async {
    var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
    var headers = {
      'Type': 'get-nowplaying-movies',
      'X-RapidAPI-Key': 'b58e867985mshf07d32cb259174cp1f8199jsn4f949cac1e2c',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };
    var params = {'page': '1'};

    var response = await http.get(url.replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> moviesData = responseData['movie_results'];
      List<Movie> movies = [];

      for (var movieData in moviesData) {
        String title = movieData['title'];
        String imdbId = movieData['imdb_id'];
        String year = movieData['year'];
        String? imageUrl = await _fetchPosterUrl(imdbId);
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
      'X-RapidAPI-Key': 'b58e867985mshf07d32cb259174cp1f8199jsn4f949cac1e2c',
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
        String? imageUrl = await _fetchPosterUrl(imdbId);
        movies.add(Movie(title: title, imageUrl: imageUrl, imdbId: imdbId, year: year));
      }

      return movies;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  static Future<String?> _fetchPosterUrl(String imdbId) async {
    var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
    var headers = {
      'Type': 'get-movies-images-by-imdb',
      'X-RapidAPI-Key': 'b58e867985mshf07d32cb259174cp1f8199jsn4f949cac1e2c',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };
    var params = {'movieid': imdbId};

    var response = await http.get(url.replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return responseData['poster'] as String?;
    } else {
      return null;
    }
  }

  static Future<ImageUrls?> _fetchImageUrls(String imdbId) async {
  var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
  var headers = {
  'Type': 'get-movies-images-by-imdb',
  'X-RapidAPI-Key': 'b58e867985mshf07d32cb259174cp1f8199jsn4f949cac1e2c',
  'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
  };
  var params = {'movieid': imdbId};

  var response = await http.get(url.replace(queryParameters: params), headers: headers);

  if (response.statusCode == 200) {
  var responseData = json.decode(response.body);
  var posterUrl = responseData['poster'] as String?;
  var fanartUrl = responseData['fanart'] as String?;
  return ImageUrls(posterUrl: posterUrl, fanartUrl: fanartUrl);
  } else {
  return null;
  }
  }

  static Future<ImageUrls?> fetchImageUrls(String imdbId) async {
    return _fetchImageUrls(imdbId);
  }


  static Future<Map<String, dynamic>> fetchMovieDetails(String imdbId) async {
    var url = Uri.https('movies-tv-shows-database.p.rapidapi.com', '/', {'movieid': imdbId});

    var headers = {
      'Type': 'get-movie-details',
      'X-RapidAPI-Key': 'b58e867985mshf07d32cb259174cp1f8199jsn4f949cac1e2c',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}





