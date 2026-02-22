import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/presentation/widget/movie_card.dart';
import '../../../detail/presentation/screen/detail_screen.dart';
import '../bloc/favorite_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite')),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteLoaded) {
            if (state.movies.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 64),
                    SizedBox(height: 12),
                    Text('No favorites yet'),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(movie: m),
                        ),
                      );
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
    );
  }
}
