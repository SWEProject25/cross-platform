class Contact {
  final int id;
  final String name;
  final String avatarUrl;
  final String handle;
  final String? bio;
  int? totalFollowers;

  Contact({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.handle,
    this.bio,
    this.totalFollowers,
  });
}