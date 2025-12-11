

class PostUpdateDto {
  final int postId;
  final int count;

  PostUpdateDto({
    required this.postId,
    required this.count,
  });

  factory PostUpdateDto.fromJson(Map<String, dynamic> json) {
    return PostUpdateDto(
      postId: json['postId'],
      count: json['count'],
    );
  }
}