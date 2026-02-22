class CastEntity {
  final String name;
  final String character;
  final String? profilePath;

  const CastEntity({
    required this.name,
    required this.character,
    this.profilePath,
  });
}

class MovieDetailEntity {
  final int id;
  final String title;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final int runtime;
  final List<String> genres;
  final String? backdropPath;
  final String? posterPath;
  final List<CastEntity> cast;
  final List<String> backdrops;

  const MovieDetailEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
    this.backdropPath,
    this.posterPath,
    required this.cast,
    required this.backdrops,
  });
}
