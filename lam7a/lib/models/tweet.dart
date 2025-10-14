// Define a post model
class Post {
  String body;  //text
  final String? mediaPic; // image URL
  final String? mediaVideo; // video link
  final DateTime date;
  int likes;
  int repost,comments,views;
  Post({
    required this.body,
    this.mediaPic,
    this.mediaVideo,
    required this.date,
  required this.likes,
  required this.repost,
  required this.comments,
  required this.views,

  });
}