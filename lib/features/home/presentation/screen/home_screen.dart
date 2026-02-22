import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/localization/locale_switcher.dart';
import '../../domain/entity/movie_entity.dart';
import '../bloc/home_bloc.dart';
import '../widget/genre_section.dart';
import '../../../favorite/presentation/bloc/favorite_bloc.dart';

class HomeScreen extends StatelessWidget {
  final String genreParam;

  const HomeScreen({super.key, required this.genreParam});

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
    final isRu = context.select((LocaleCubit cubit) {
      return cubit.state.languageCode == 'ru';
    });
    final title = isRu ? 'Фильмы' : 'Movies';
    final retry = isRu ? 'Повторить' : 'Retry';
    final errorFallback = isRu
        ? 'Не удалось загрузить фильмы. Проверьте интернет и попробуйте снова.'
        : 'Failed to load movies. Check your internet and try again.';

    return BlocListener<LocaleCubit, Locale>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, _) {
        context.read<HomeBloc>().add(const HomeFetchMovies());
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => context.push('/token/home'),
            icon: const Icon(Icons.key_outlined),
          ),
          const LocaleSwitcher(),
          const SizedBox(width: 12),
        ],
      ),
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
                  Text(
                    state.message == 'load_failed' ? errorFallback : state.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<HomeBloc>()
                        .add(const HomeFetchMovies()),
                    child: Text(retry),
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
                          context.push('/detail/${m.id}', extra: m);
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (i) {
          if (i == 1) {
            context.go('/favorites/all');
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.movie_outlined),
            selectedIcon: const Icon(Icons.movie),
            label: isRu ? 'Главная' : 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: isRu ? 'Избранное' : 'Favorites',
          ),
        ],
      ),
    ));
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
