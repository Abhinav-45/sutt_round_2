import 'package:flutter/material.dart';
import 'package:sutt_round_2/Logic/launch_yt_video.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sutt_round_2/Logic/star_rating.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../Provider/provider.dart';


class MovieDetailsScreen extends StatefulWidget {
  final String imdbId;

  const MovieDetailsScreen({Key? key, required this.imdbId}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
    print("IMDb ID: ${widget.imdbId}");
    Provider.of<MovieDetailsProvider>(context, listen: false)
        .fetchMovieDetails(widget.imdbId);
    Provider.of<MovieDetailsProvider>(context, listen: false)
        .fetchImageUrls(widget.imdbId);
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
        title: Text(
          'Movie Details',
          style: TextStyle(
            fontFamily: 'Anta',
          ),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            context.go('/home');
          },
        ),
        backgroundColor: Colors.cyanAccent,
      ),
      body: Consumer<MovieDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.movieDetails == null) {
            return CircularProgressIndicator();
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                if (provider.imageUrls.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          Provider.of<MovieDetailsProvider>(context, listen: false)
                              .updateCurrentImageIndex(index);
                        },
                      ),
                      items: provider.imageUrls.map((imageUrl) {
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
                              )
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                if (provider.imageUrls.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: provider.imageUrls.map((url) {
                      int index = provider.imageUrls.indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: provider.currentImageIndex == index
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                Text(
                  '${provider.movieDetails!['title']}  (${provider.movieDetails!['year']})',
                  style: customTextStyle,
                ),
                SizedBox(height: 10),
                Text(
                  'Tagline: ${provider.movieDetails?['tagline'] ?? 'Tagline not available'}',
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
                        provider.movieDetails!['description'] != null
                            ? provider.movieDetails!['description']
                            : 'Description Not Available',
                        style: customTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                StarRating(
                  imdbRating: provider.movieDetails?['imdb_rating'] != null
                      ? double.parse(provider.movieDetails?['imdb_rating'])
                      : 0.0,
                ),
                SizedBox(height: 20),
                Text(
                  'Rated: ${provider.movieDetails!['rated'] ?? 'Age rating not available'}',
                  style: customTextStyle.copyWith(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    launchYouTubeVideo(
                        '${provider.movieDetails!['youtube_trailer_key']}');
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
          );
        },
      ),
    );
  }
}
