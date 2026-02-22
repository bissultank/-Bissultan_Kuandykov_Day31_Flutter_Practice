import 'package:flutter/material.dart';
import '../../domain/entity/movie_entity.dart';
import 'movie_card.dart';

class GenreSection extends StatelessWidget {
  final String genreTitle;
  final List<MovieEntity> movies;
  final Set<int> favoriteIds;
  final void Function(MovieEntity)? onMovieTap;
  final void Function(MovieEntity)? onFavoriteTap;

  const GenreSection({
    super.key,
    required this.genreTitle,
    required this.movies,
    this.favoriteIds = const {},
    this.onMovieTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              genreTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final m = movies[i];
                return SizedBox(
                  width: 190,
                  child: MovieCard(
                    movie: m,
                    isFavorite: favoriteIds.contains(m.id),
                    onTap: () => onMovieTap?.call(m),
                    onFavoriteTap: () => onFavoriteTap?.call(m),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
