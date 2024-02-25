class Movie {
  final String title;
  final String year;
  final String imdbId;
  final String? imageUrl;

  Movie({
    required this.title,
    required this.year,
    required this.imdbId,
    this.imageUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      year: json['year'].toString(),
      imdbId: json['imdb_id'] as String,
    );
  }
}