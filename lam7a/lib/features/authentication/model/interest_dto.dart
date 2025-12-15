// coverage:ignore-file
class InterestDto {
  int id;
  String? name;
  String? slug;
  String? description;
  String? icon;
  InterestDto({
    required this.id,
    this.name,
    this.slug,
    this.description,
    this.icon,
  });
  factory InterestDto.fromJson(Map<String, dynamic> json) {
    return InterestDto(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}