// Define a post model
class TweetModel {
  String body;  //text
  final String? mediaPic; // image URL
  final String? mediaVideo; // video link
  final DateTime date;
  int likes;
  int repost,comments,views;
  final String id;
  final String userId;
  TweetModel({
    required this.body,
    this.mediaPic,
    this.mediaVideo,
    required this.date,
  required this.likes,
  required this.repost,
  required this.comments,
  required this.views,
  required this.id,
  required this.userId
  });
   factory TweetModel.empty() => TweetModel(
        id: '',
        body: '',
        likes: 0,
        mediaPic: null,
        mediaVideo: null,
        comments: 0,
        repost: 0,
        views: 0,
        date: DateTime.now(),
        userId: '',
      );

  TweetModel copyWith({
    String? id,
    String? body,
    int? likes,
    String? mediaPic,
    String? mediaVideo,
    int? comments,
    int? repost,
    int? views,
    DateTime? date,
    String? userId,
  }) {
    return TweetModel(
      id: id ?? this.id,
      body: body ?? this.body,
      likes: likes ?? this.likes,
      mediaPic: mediaPic ?? this.mediaPic,
      mediaVideo: mediaVideo ?? this.mediaVideo,
      comments: comments ?? this.comments,
      repost: repost ?? this.repost,
      views: views ?? this.views,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }
}