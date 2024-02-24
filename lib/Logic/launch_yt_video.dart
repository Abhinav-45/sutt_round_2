import 'package:url_launcher/url_launcher.dart';


void launchYouTubeVideo(String videoId) async {
  final String youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';
  Uri uri = Uri.parse(youtubeUrl);
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $uri');
  }
}
