// home_screen.dart

import 'package:flutter/material.dart';
import 'package:sutt_round_2/Data Storage and API Calls/get_now_playing_movies.dart';
// import 'package:sutt_round_2/Data Storage and API Calls/get_movie_by_title.dart';
import 'package:sutt_round_2/Data Storage and API Calls/get_movieimage_by_imdb.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _nowPlayingMoviesFuture;
  late List<Movie> _allMovies;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _nowPlayingMoviesFuture = ApiService.fetchNowPlayingMovies();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search movie title...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchTextChanged,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _nowPlayingMoviesFuture,
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
                  _allMovies = snapshot.data!;
                  return _buildMovieGrid(_allMovies);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieGrid(List<Movie> movies) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index]);
      },
    );
  }

  void _onSearchTextChanged(String text) {
    List<Movie> filteredMovies = _allMovies.where((movie) {
      return movie.title.toLowerCase().contains(text.toLowerCase());
    }).toList();
    setState(() {
      _nowPlayingMoviesFuture = Future.value(filteredMovies);
    });
  }
}


// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late Future<List<Movie>> _nowPlayingMoviesFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _nowPlayingMoviesFuture = ApiService.fetchNowPlayingMovies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Now Playing Movies'),
//       ),
//       body: FutureBuilder<List<Movie>>(
//         future: _nowPlayingMoviesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             return GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10.0,
//                 mainAxisSpacing: 10.0,
//               ),
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return MovieCard(movie: snapshot.data![index]);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: movie.imageUrl != null
                    ? Image.network(
                  movie.imageUrl!,
                  fit: BoxFit.fitWidth, // Adjust to your needs
                )
                    : Text('No image available'),
              ),
            ),
            SizedBox(height: 8),
            Center(child: Text(movie.title, textAlign: TextAlign.center)),


          ],
        ),
      ),
    );
  }
}


