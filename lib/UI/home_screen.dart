// home_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:sutt_round_2/Data Storage and API Calls/get_now_playing_movies.dart';
import 'package:sutt_round_2/Data Storage and API Calls/get_movie_by_title.dart';
// import 'package:sutt_round_2/Data Storage and API Calls/get_movieimage_by_imdb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _moviesFuture;
  late TextEditingController _searchController;
  bool _showResults = false; // Track if results should be displayed
  bool _showBackToNowPlayingButton = false; // Track if back to now playing button should be displayed

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchNowPlayingMovies(); // Call the Now Playing Movies API on screen initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter movie title...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _onSearchPressed,
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          if (_showBackToNowPlayingButton)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _onBackToNowPlayingPressed,
                child: Text('Back to Now Playing'),
              ),
            ),
          if (_showResults || _moviesFuture != null) // Display results if _showResults is true or _moviesFuture is not null
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: _moviesFuture,
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
                    return _buildMovieGrid(snapshot.data!);
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

  void _fetchNowPlayingMovies() {
    setState(() {
      _moviesFuture = ApiService.fetchNowPlayingMovies();
      _showResults = true; // Display results when Now Playing Movies API is called
      _showBackToNowPlayingButton = false; // Hide back button after searching
    });
  }

  void _onSearchPressed() {
    String searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      setState(() {
        _moviesFuture = ApiService.fetchMovies(searchText);
        _showResults = true; // Display results when search button is pressed
        _showBackToNowPlayingButton = true; // Show back button after searching
      });
    }
  }

  void _onBackToNowPlayingPressed() {
    setState(() {
      _fetchNowPlayingMovies();
    });
  }
}



class MovieCard extends StatefulWidget {
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: () {
          context.go('/details');
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => DetailsScreen(movie: movie),
          //   ),
          // );
        },

    child:  Card(
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
                    child: widget.movie.imageUrl != null && widget.movie.imageUrl!.isNotEmpty
                        ? Image.network(
                      widget.movie.imageUrl!,
                      fit: BoxFit.contain, // Change BoxFit to BoxFit.contain
                    )
                        : Image.asset(
                      'assets/Designer.png', // Provide a placeholder image path
                      fit: BoxFit.contain, // Change BoxFit to BoxFit.contain
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.01,
                    right: screenWidth * 0.01,
                    child: IconButton(
                      icon: Icon(
                        _liked ? Icons.favorite : Icons.favorite_border,
                        color: _liked ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _liked = !_liked;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Text(
              '${widget.movie.title} (${widget.movie.year})',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}



// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late Future<List<Movie>> _nowPlayingMoviesFuture;
//   late List<Movie> _allMovies;
//   late TextEditingController _searchController;
//
//   @override
//   void initState() {
//     super.initState();
//     _nowPlayingMoviesFuture = ApiService.fetchNowPlayingMovies();
//     _searchController = TextEditingController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Now Playing Movies'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search movie title...',
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: _onSearchTextChanged,
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Movie>>(
//               future: _nowPlayingMoviesFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Error: ${snapshot.error}'),
//                   );
//                 } else {
//                   _allMovies = snapshot.data!;
//                   return _buildMovieGrid(_allMovies);
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMovieGrid(List<Movie> movies) {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 1,
//         crossAxisSpacing: 10.0,
//         mainAxisSpacing: 10.0,
//       ),
//       itemCount: movies.length,
//       itemBuilder: (context, index) {
//         return MovieCard(movie: movies[index]);
//       },
//     );
//   }
//
//
//   void _onSearchTextChanged(String text) async {
//     try {
//       List<Movie> filteredMovies = await ApiService.fetchMovies(text);
//       setState(() {
//         _nowPlayingMoviesFuture = Future.value(filteredMovies);
//       });
//     } catch (error) {
//       print('Error fetching movies: $error');
//       // Handle error appropriately, e.g., show error message to user
//     }
//   }
//
// }
// void _onSearchTextChanged(String text) {
//   List<Movie> filteredMovies = _allMovies.where((movie) {
//     return movie.title.toLowerCase().contains(text.toLowerCase());
//   }).toList();
//   setState(() {
//     _nowPlayingMoviesFuture = Future.value(filteredMovies);
//   });
// }

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
// class MovieCard extends StatelessWidget {
//   final Movie movie;
//
//   MovieCard({required this.movie});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Expanded(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             Container(
//               height: MediaQuery.of(context).size.height * 0.4,
//               child: Center(
//                 child: movie.imageUrl != null
//                     ? Image.network(
//                   movie.imageUrl!,
//                   fit: BoxFit.fitWidth, // Adjust to your needs
//                 )
//                     : Text('No image available'),
//               ),
//             ),
//             SizedBox(height: 8),
//             Center(child: Text(movie.title, textAlign: TextAlign.center)),
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
