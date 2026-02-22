import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screen/token_demo_screen.dart';
import '../../features/favorite/presentation/screen/favorite_screen.dart';
import '../../features/home/domain/entity/movie_entity.dart';
import '../../features/home/presentation/screen/home_screen.dart';
import '../../features/detail/presentation/screen/detail_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/home/all',
    routes: [
      GoRoute(
        path: '/home/:genre',
        builder: (context, state) {
          final genre = state.pathParameters['genre'] ?? 'all';
          return HomeScreen(genreParam: genre);
        },
      ),
      GoRoute(
        path: '/favorites/:filter',
        builder: (context, state) {
          final filter = state.pathParameters['filter'] ?? 'all';
          return FavoriteScreen(filterParam: filter);
        },
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final extraMovie = state.extra;
          final movie = extraMovie is MovieEntity
              ? extraMovie
              : MovieEntity(
                  id: id,
                  title: state.uri.queryParameters['title'] ?? '',
                  bannerUrl: state.uri.queryParameters['bannerUrl'] ?? '',
                  genre: state.uri.queryParameters['genre'] ?? '',
                );
          return DetailScreen(movie: movie);
        },
      ),
      GoRoute(
        path: '/token/:source',
        builder: (context, state) {
          final source = state.pathParameters['source'] ?? 'app';
          return TokenDemoScreen(source: source);
        },
      ),
    ],
  );
}
