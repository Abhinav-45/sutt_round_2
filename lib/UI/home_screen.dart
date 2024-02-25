import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sutt_round_2/Data Storage and API Calls/service.dart';
import 'package:go_router/go_router.dart';
import '../Logic/like.dart';
import '../Models/movie.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _moviesFuture;
  late TextEditingController _searchController;
  bool _showResults = false;
  bool _showBackToNowPlayingButton = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchNowPlayingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Movies', style: TextStyle(
            fontFamily: 'Anta',
        ))),
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
                      controller: _searchController,
                      onChanged: (value) {
                        _onSearchPressed();
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter movie title...',
                        prefixIcon: Icon(Icons.search),
                      ),
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
                child: Text(
                  'Back to Now Playing',
                ),
              ),
            ),
          if (_showResults || _moviesFuture != null)
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
      _showResults = true;
      _showBackToNowPlayingButton = false;
    });
  }

  void _onSearchPressed() {
    String searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      setState(() {
        _moviesFuture = ApiService.fetchMovies(searchText);
        _showResults = true;
        _showBackToNowPlayingButton = true;
      });
    } else {
      setState(() {
        _showResults = false;
        _showBackToNowPlayingButton = false;
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

    final TextStyle bold = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Anta',
    );

    double fontSize = screenWidth * 0.04;

    final TextStyle customTextStyle = bold.copyWith(fontSize: fontSize);

    return GestureDetector(
      onTap: () {
        print("IMDb ID: ${widget.movie.imdbId}");
        print('hi');
        context.go('/details/${widget.movie.imdbId}');
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
                      child: widget.movie.imageUrl != null &&
                          widget.movie.imageUrl!.isNotEmpty
                          ? Image.network(
                        widget.movie.imageUrl!,
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
                '${widget.movie.title} (${widget.movie.year})',
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
