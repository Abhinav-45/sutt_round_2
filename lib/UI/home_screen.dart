import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Logic/like.dart';
import '../Models/movie.dart';
import '../Provider/provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenModel>(
      builder: (context, homeModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Movies', style: TextStyle(fontFamily: 'Anta'))),
            backgroundColor: Colors.cyan,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.all(8.0),
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
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
        print("IMDb ID: ${movie.imdbId}");
        print('hi');
        context.go('/details/${movie.imdbId}');
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
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
                        fit: BoxFit.contain,
                      )
                          : Image.asset(
                        'assets/Designer.png',
                        fit: BoxFit.contain,
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
    );
  }
}
