// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// Future<void> fetchMovieImages() async {
//   var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
//   var headers = {
//     'Type': 'get-movies-images-by-imdb',
//     'X-RapidAPI-Key': 'd203b1f42fmsh42f7296e388ca8fp17bf73jsne4448fa561f9',
//     'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
//   };
//   var params = {'movieid': 'tt1375666'};
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
//   fetchMovieImages();
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

class apiService {
  static final String _baseUrl = 'https://movies-tv-shows-database.p.rapidapi.com/';
  static final Map<String, String> _headers = {
    'Type': 'get-movies-images-by-imdb',
    'X-RapidAPI-Key': 'd203b1f42fmsh42f7296e388ca8fp17bf73jsne4448fa561f9',
    'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
  };

  static Future<String?> _fetchImageUrl(String imdbId) async {
    var options = {
      'method': 'GET',
      'url': _baseUrl,
      'params': {'movieid': imdbId},
      'headers': _headers,
    };

    try {
      var response = await http.get(Uri.parse(_baseUrl), headers: _headers);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var imageUrl = responseData['poster']; // Assuming the image URL is provided under the 'poster' key
        return imageUrl;
      } else {
        print('Failed to fetch image for IMDb ID: $imdbId');
        return null;
      }
    } catch (error) {
      print('Error fetching image for IMDb ID: $imdbId');
      return null;
    }
  }
}

