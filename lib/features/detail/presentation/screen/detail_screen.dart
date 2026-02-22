import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../home/domain/entity/movie_entity.dart';
import '../../../home/domain/entity/movie_detail_entity.dart';
import '../bloc/detail_bloc.dart';
import '../../../favorite/presentation/bloc/favorite_bloc.dart';

class DetailScreen extends StatelessWidget {
  final MovieEntity movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DetailBloc>()..add(DetailFetch(movie.id)),
      child: _DetailView(movie: movie),
    );
  }
}

class _DetailView extends StatelessWidget {
  final MovieEntity movie;

  const _DetailView({required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favState) {
        final isFav = favState is FavoriteLoaded &&
            favState.movies.any((m) => m.id == movie.id);

        return Scaffold(
          appBar: AppBar(
            title: Text(movie.title),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () {
                  final bloc = context.read<FavoriteBloc>();
                  if (isFav) {
                    bloc.add(FavoriteRemove(movie.id));
                  } else {
                    bloc.add(FavoriteAdd(movie));
                  }
                },
              ),
            ],
          ),
          body: BlocBuilder<DetailBloc, DetailState>(
            builder: (context, state) {
              if (state is DetailLoading || state is DetailInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DetailError) {
                return _FallbackDetail(movie: movie, isFav: isFav);
              }

              if (state is DetailLoaded) {
                return _DetailContent(detail: state.detail);
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}

// Shows if API fails – uses data from MovieEntity
class _FallbackDetail extends StatelessWidget {
  final MovieEntity movie;
  final bool isFav;

  const _FallbackDetail({required this.movie, required this.isFav});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: movie.bannerUrl,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Chip(label: Text(movie.genre)),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailContent extends StatelessWidget {
  final MovieDetailEntity detail;

  const _DetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Hero backdrop
        AspectRatio(
          aspectRatio: 16 / 9,
          child: detail.backdropPath != null
              ? CachedNetworkImage(
                  imageUrl: detail.backdropPath!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image),
                  ),
                )
              : Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                detail.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),

              // Rating + year + runtime
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    detail.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${detail.voteCount})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(detail.releaseDate.isNotEmpty
                      ? detail.releaseDate.substring(0, 4)
                      : '—'),
                  const SizedBox(width: 16),
                  const Icon(Icons.timer_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text('${detail.runtime} мин'),
                ],
              ),
              const SizedBox(height: 12),

              // Genres
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: detail.genres.map((g) => Chip(label: Text(g))).toList(),
              ),
              const SizedBox(height: 16),

              // Overview
              if (detail.overview.isNotEmpty) ...[
                Text(
                  'Описание',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  detail.overview,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
              ],

              // Cast
              if (detail.cast.isNotEmpty) ...[
                Text(
                  'Актёры',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: detail.cast.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => _CastCard(cast: detail.cast[i]),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Gallery
              if (detail.backdrops.isNotEmpty) ...[
                Text(
                  'Галерея',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 130,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: detail.backdrops.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          imageUrl: detail.backdrops[i],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CastCard extends StatelessWidget {
  final CastEntity cast;

  const _CastCard({required this.cast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: cast.profilePath != null
                ? CachedNetworkImageProvider(cast.profilePath!)
                : null,
            child: cast.profilePath == null
                ? const Icon(Icons.person, size: 32)
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          Text(
            cast.character,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
