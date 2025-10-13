// Define a post model
class Post {
  final String body;  //text
  final String? mediaPic; // image URL
  final String? mediaVideo; // video link
  final DateTime date;

  Post({
    required this.body,
    this.mediaPic,
    this.mediaVideo,
    required this.date
  });
}