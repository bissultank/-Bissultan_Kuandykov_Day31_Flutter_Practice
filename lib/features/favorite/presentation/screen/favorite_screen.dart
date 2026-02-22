import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/localization/locale_switcher.dart';
import '../../../home/presentation/widget/movie_card.dart';
import '../bloc/favorite_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  final String filterParam;

  const FavoriteScreen({super.key, required this.filterParam});

  @override
  Widget build(BuildContext context) {
    final isRu = context.select((LocaleCubit cubit) {
      return cubit.state.languageCode == 'ru';
    });
    final title = isRu ? 'Избранное' : 'Favorites';
    final emptyText = isRu ? 'Пока нет избранных' : 'No favorites yet';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => context.push('/token/favorites'),
            icon: const Icon(Icons.key_outlined),
          ),
          const LocaleSwitcher(),
          const SizedBox(width: 12),
        ],
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteLoaded) {
            if (state.movies.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite_border, size: 64),
                    const SizedBox(height: 12),
                    Text(emptyText),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.movies.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final m = state.movies[i];
                return SizedBox(
                  height: 140,
                  child: MovieCard(
                    movie: m,
                    isFavorite: true,
                    onTap: () {
                      context.push('/detail/${m.id}', extra: m);
                    },
                    onFavoriteTap: () {
                      context.read<FavoriteBloc>().add(FavoriteRemove(m.id));
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (i) {
          if (i == 0) {
            context.go('/home/all');
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
    );
  }
}
