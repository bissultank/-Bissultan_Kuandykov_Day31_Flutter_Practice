import '../../domain/entity/movie_detail_entity.dart';

class CastModel extends CastEntity {
  const CastModel({
    required super.name,
    required super.character,
    super.profilePath,
  });

  // TVMaze /shows/{id}/cast returns list of {person, character}
  factory CastModel.fromJson(Map<String, dynamic> json) {
    final person = json['person'] as Map<String, dynamic>? ?? {};
    final character = json['character'] as Map<String, dynamic>? ?? {};
    final personImage = person['image'] as Map<String, dynamic>?;

    return CastModel(
      name: person['name'] as String? ?? '',
      character: character['name'] as String? ?? '',
      profilePath: personImage?['medium'] as String?,
    );
  }
}

class MovieDetailModel extends MovieDetailEntity {
  const MovieDetailModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.voteAverage,
    required super.voteCount,
    required super.releaseDate,
    required super.runtime,
    required super.genres,
    super.backdropPath,
    super.posterPath,
    required super.cast,
    required super.backdrops,
  });

  // Built from show JSON + cast list
  factory MovieDetailModel.fromShowAndCast(
    Map<String, dynamic> show,
    List<dynamic> castList,
  ) {
    final image = show['image'] as Map<String, dynamic>?;
    final genres = (show['genres'] as List<dynamic>? ?? [])
        .map((g) => g as String)
        .toList();

    // Remove HTML tags from summary
    final rawSummary = show['summary'] as String? ?? '';
    final overview = rawSummary.replaceAll(RegExp(r'<[^>]*>'), '');

    final rating = show['rating'] as Map<String, dynamic>?;
    final ratingAvg = (rating?['average'] as num?) ?? 0.0;

    final cast = castList
        .take(20)
        .map((c) => CastModel.fromJson(c as Map<String, dynamic>))
        .toList();

    return MovieDetailModel(
      id: show['id'] as int,
      title: show['name'] as String? ?? '',
      overview: overview,
      voteAverage: ratingAvg.toDouble(),
      voteCount: 0, // TVMaze doesn't provide vote count
      releaseDate: show['premiered'] as String? ?? '',
      runtime: show['runtime'] as int? ?? 0,
      genres: genres,
      backdropPath: image?['original'] as String?,
      posterPath: image?['medium'] as String?,
      cast: cast,
      backdrops: [], // TVMaze doesn't provide gallery, use poster
    );
  }
}
