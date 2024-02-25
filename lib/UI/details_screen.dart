import 'package:flutter/material.dart';

import 'package:sutt_round_2/Logic/launch_yt_video.dart';
import 'package:flutter/material.dart';
import 'package:sutt_round_2/Data Storage and API Calls/get_movie_by_title.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sutt_round_2/Logic/star_rating.dart';
import 'package:go_router/go_router.dart';



// or any other necessary imports


// class MovieDetailsScreen extends StatefulWidget {
//   final String imdbId;
//
//   const MovieDetailsScreen({Key? key, required this.imdbId}) : super(key: key);
//
//   @override
//   _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
// }
//
// class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
//   Map<String, dynamic>? movieDetails;
//   String? posterUrl;
//   String? fanartUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     print("IMDb ID: ${widget.imdbId}");
//     fetchMovieDetails();
//   }
//
//   Future<void> fetchMovieDetails() async {
//     try {
//       var details = await ApiService.fetchMovieDetails(widget.imdbId);
//       setState(() {
//         movieDetails = details;
//       });
//     } catch (error) {
//       print('Error fetching movie details: $error');
//     }
//
//     try {
//       var imageUrls = await ApiService._fetchImageUrls(widget.imdbId);
//       if (imageUrls != null) {
//         setState(() {
//           posterUrl = imageUrls.posterUrl;
//           fanartUrl = imageUrls.fanartUrl;
//         });
//       }
//     } catch (error) {
//       print('Error fetching image URLs: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Movie Details'),
//       ),
//       body: Center(
//         child: movieDetails == null
//             ? CircularProgressIndicator()
//             : Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Movie Title: ${movieDetails!['title']}'),
//             // Use the poster and fanart URLs as needed
//             if (posterUrl != null) Image.network(posterUrl!),
//             if (fanartUrl != null) Image.network(fanartUrl!),
//           ],
//         ),
//       ),
//     );
//   }
// }
// movie_details_screen.dart



class MovieDetailsScreen extends StatefulWidget {
  final String imdbId;

  const MovieDetailsScreen({Key? key, required this.imdbId}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  Map<String, dynamic>? movieDetails;
  List<String> imageUrls = [];
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    print("IMDb ID: ${widget.imdbId}");
    fetchMovieDetails();
    fetchImageUrls(); // Call the method to fetch image URLs
  }

  Future<void> fetchMovieDetails() async {
    try {
      var details = await ApiService.fetchMovieDetails(widget.imdbId);
      setState(() {
        movieDetails = details;
      });
    } catch (error) {
      print('Error fetching movie details: $error');
    }
  }

  Future<void> fetchImageUrls() async {
    try {
      var imageUrlsData = await ApiService.fetchImageUrls(widget.imdbId);
      if (imageUrlsData != null) {
        setState(() {
          imageUrls = [
            if (imageUrlsData.posterUrl != null) imageUrlsData.posterUrl!,
            if (imageUrlsData.fanartUrl != null) imageUrlsData.fanartUrl!,
          ];

        });
      } else {
        imageUrls = [
          'https://i.ibb.co/hXDHWc4/4.jpg', 'i.ibb.co/hXDHWc4/4.jpg'
        ];
      }
    } catch (error) {
      print('Error fetching image URLs: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            context.go('/home');
          },
        ),

        backgroundColor: Colors.cyanAccent,
      ),
      body: movieDetails == null
          ? CircularProgressIndicator() // Show loading indicator while fetching data
          :

          SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Display carousel slider if imageUrls are available
                if (imageUrls.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                      items: imageUrls.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                // Display indicator for carousel
                if (imageUrls.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageUrls.map((url) {
                      int index = imageUrls.indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index ? Colors.blueAccent : Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                Text(
                  '${movieDetails!['title']}  (${movieDetails!['year']})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),

                ),
                SizedBox(height: 10),

                Text('Tagline: ${movieDetails?['tagline'] ?? 'Tagline not available'}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),),
                SizedBox(height: 40),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      Text(
                        '${movieDetails!['description']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                StarRatingWidget(
                  imdbRating: movieDetails?['imdb_rating'] != null
                      ? double.parse(movieDetails?['imdb_rating'])
                      : 0.0,
                ),
                SizedBox(height: 20),
                Text('Rated: ${movieDetails!['rated']}',
                style: TextStyle(
                  fontSize: 18,
                ),),
                SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    launchYouTubeVideo('${movieDetails!['youtube_trailer_key']}');
                  },
                  icon: Icon(Icons.arrow_right_alt_rounded,
                  size: 50,),
                  label: Text('Watch Trailer on Youtube',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),),

                )
              ],
            ),
          ),






    );
  }
}