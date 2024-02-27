import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Logic/like.dart';
import '../Models/movie.dart';
import '../Provider/provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<HomeScreenModel>(
      builder: (context, homeModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Movies', style: TextStyle(fontFamily: 'Anta',fontSize: screenHeight*0.028))),
            backgroundColor: Colors.cyan,
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight*0.015, horizontal: screenWidth*0.025),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight*0.01,horizontal: screenWidth*0.01),
                        child: TextField(
                          controller: homeModel.searchController,
                          onChanged: (value) {
                            homeModel.onSearchPressed(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter movie title...',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        homeModel.onSearchPressed(homeModel.searchController.text.trim());
                      },
                      child: Text('Search'),
                    ),
                  ],
                ),
              ),
              if (homeModel.showBackToNowPlayingButton)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight*0.01),
                  child: ElevatedButton(
                    onPressed: homeModel.onBackToNowPlayingPressed,
                    child: Text('Back to Now Playing'),
                  ),
                ),
              if (homeModel.showResults || homeModel.moviesFuture != null)
                Expanded(
                  child: FutureBuilder<List<Movie>>(
                    future: homeModel.moviesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return _buildMovieGrid(context, snapshot.data!);
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMovieGrid(BuildContext context, List<Movie> movies) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 9/16,
        crossAxisCount: 2,
        crossAxisSpacing: screenWidth*0.01,
        mainAxisSpacing: screenHeight*0.01,
      ),
      scrollDirection: Axis.vertical,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index]);
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize = screenWidth * 0.04;

    final TextStyle customTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Anta',
      fontSize: fontSize,
    );

    return GestureDetector(
      onTap: () {
        context.go('/details/${movie.imdbId}');
      },
      child: Card(
        elevation: 4,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),

        child: Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: movie.imageUrl != null && movie.imageUrl!.isNotEmpty
                            ? Image.network(
                          movie.imageUrl!,
                          fit: BoxFit.fill,
                        )
                            : Image.asset(
                          'assets/Designer.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.01,
                        right: screenWidth * 0.01,
                        child: like(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Text(
                  '${movie.title} (${movie.year})',
                  textAlign: TextAlign.center,
                  style: customTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
