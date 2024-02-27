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
    Provider.of<MovieDetailsProvider>(context, listen: false)
        .fetchMovieDetails(widget.imdbId);
    Provider.of<MovieDetailsProvider>(context, listen: false)
        .fetchImageUrls(widget.imdbId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                    padding: EdgeInsets.symmetric(vertical: screenHeight*0.03, horizontal: screenWidth*0.07),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: screenHeight*0.22,
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
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.fill,
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
                        width: screenWidth*0.03,
                        height: screenHeight*0.01,
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight*0.003, horizontal: screenWidth*0.003),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: provider.currentImageIndex == index
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                SizedBox(height: screenHeight*0.02),

                Text(
                  '${provider.movieDetails!['title']}  (${provider.movieDetails!['year']})',
                  style: customTextStyle,
                ),
                SizedBox(height: screenHeight*0.02),
                Text(
                  'Tagline: ${provider.movieDetails?['tagline'] ?? 'Tagline not available'}',
                  style: customTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: screenHeight*0.03),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight*0.01, horizontal: screenWidth*0.03),
                  child: ExpansionTile(
                    title: Text(
                      'Description',
                      style: customTextStyle.copyWith(
                        fontSize: screenHeight * 0.025,
                      ),
                    ),
                    children: <Widget>[
                      Text(
                        provider.movieDetails!['description'] != null
                            ? provider.movieDetails!['description']
                            : 'Description Not Available',
                        style: customTextStyle.copyWith(fontSize: screenHeight*0.018),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight*0.02),
                StarRating(
                  imdbRating: provider.movieDetails?['imdb_rating'] != null
                      ? double.parse(provider.movieDetails?['imdb_rating'])
                      : 0.0,
                ),
                SizedBox(height: screenHeight*0.02),
                Text(
                  'Rated: ${provider.movieDetails!['rated'] ?? 'Age rating not available'}',
                  style: customTextStyle.copyWith(
                    fontSize: screenHeight*0.022,
                  ),
                ),
                SizedBox(height: screenHeight*0.02),
                TextButton.icon(
                  onPressed: () {
                    launchYouTubeVideo(
                        '${provider.movieDetails!['youtube_trailer_key']}');
                  },
                  icon: Icon(
                    Icons.arrow_right_alt_rounded,
                    size: screenHeight*0.05,
                  ),
                  label: Text(
                    'Watch Trailer on Youtube',
                    style: customTextStyle.copyWith(
                      fontSize: screenHeight*0.024,
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
