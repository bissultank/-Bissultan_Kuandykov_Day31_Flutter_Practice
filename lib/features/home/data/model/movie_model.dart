import '../../domain/entity/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.bannerUrl,
    required super.genre,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>?;
    final bannerUrl = (image?['original'] ?? image?['medium'] ?? '') as String;

    final genres = json['genres'] as List<dynamic>?;
    final genre = genres != null && genres.isNotEmpty
        ? genres.first as String
        : 'Unknown';

    return MovieModel(
      id: json['id'] as int,
      title: json['name'] as String? ?? '',
      bannerUrl: bannerUrl,
      genre: genre,
    );
  }
}
