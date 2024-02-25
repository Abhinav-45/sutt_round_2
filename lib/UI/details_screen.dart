import 'package:flutter/material.dart';
import 'package:sutt_round_2/Logic/launch_yt_video.dart';
import 'package:sutt_round_2/Data Storage and API Calls/service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sutt_round_2/Logic/star_rating.dart';
import 'package:go_router/go_router.dart';

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
    fetchImageUrls();
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
          'https://i.ibb.co/hXDHWc4/4.jpg',
          'i.ibb.co/hXDHWc4/4.jpg'
        ];
      }
    } catch (error) {
      print('Error fetching image URLs: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final TextStyle bold = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Anta',
    );

    double fontSize = screenWidth * 0.04;

    final TextStyle customTextStyle = bold.copyWith(fontSize: fontSize);

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details',style: TextStyle(
            fontFamily: 'Anta',
        ),),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            context.go('/home');
          },
        ),
        backgroundColor: Colors.cyanAccent,
      ),
      body: movieDetails == null
          ? CircularProgressIndicator()
          : SingleChildScrollView(
        child: Column(
          children: [
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
            if (imageUrls.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageUrls.map((url) {
                  int index = imageUrls.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
            Text(
              '${movieDetails!['title']}  (${movieDetails!['year']})',
              style: customTextStyle,
            ),
            SizedBox(height: 10),
            Text(
              'Tagline: ${movieDetails?['tagline'] ?? 'Tagline not available'}',
              style: customTextStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(
                  'Description',
                  style: customTextStyle.copyWith(
                    fontSize: 18,
                  ),
                ),
                children: <Widget>[
                  Text(
                    movieDetails!['description'] != null ? movieDetails!['description'] : 'Description Not Available',
                    style: customTextStyle.copyWith(fontSize: 16),

                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            StarRating(
              imdbRating: movieDetails?['imdb_rating'] != null
                  ? double.parse(movieDetails?['imdb_rating'])
                  : 0.0,
            ),
            SizedBox(height: 20),
            Text(
              'Rated: ${movieDetails!['rated'] ?? 'Age rating not available'}',
              style: customTextStyle.copyWith(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                launchYouTubeVideo(
                    '${movieDetails!['youtube_trailer_key']}');
              },
              icon: Icon(
                Icons.arrow_right_alt_rounded,
                size: 50,
              ),
              label: Text(
                'Watch Trailer on Youtube',
                style: customTextStyle.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
