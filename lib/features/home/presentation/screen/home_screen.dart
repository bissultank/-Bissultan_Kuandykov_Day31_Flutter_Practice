import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entity/movie_entity.dart';
import '../bloc/home_bloc.dart';
import '../widget/genre_section.dart';
import '../../../detail/presentation/screen/detail_screen.dart';
import '../../../favorite/presentation/bloc/favorite_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(const HomeFetchMovies()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<HomeBloc>()
                        .add(const HomeFetchMovies()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, favState) {
                final favoriteIds = favState is FavoriteLoaded
                    ? favState.movies.map((m) => m.id).toSet()
                    : <int>{};

                return ListView(
                  children: [
                    const SizedBox(height: 12),
                    for (final entry in state.moviesByGenre.entries)
                      GenreSection(
                        genreTitle: entry.key,
                        movies: entry.value,
                        favoriteIds: favoriteIds,
                        onMovieTap: (m) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(movie: m),
                            ),
                          );
                        },
                        onFavoriteTap: (m) => _toggleFavorite(
                          context,
                          m,
                          favoriteIds.contains(m.id),
                        ),
                      ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _toggleFavorite(
    BuildContext context,
    MovieEntity movie,
    bool isCurrentlyFavorite,
  ) {
    final bloc = context.read<FavoriteBloc>();
    if (isCurrentlyFavorite) {
      bloc.add(FavoriteRemove(movie.id));
    } else {
      bloc.add(FavoriteAdd(movie));
    }
  }
}
