import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../database/app_database.dart';
import '../../features/home/data/repository/movie_repository_impl.dart';
import '../../features/home/domain/repository/movie_repository.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/detail/presentation/bloc/detail_bloc.dart';
import '../../features/favorite/data/repository/favorite_repository_impl.dart';
import '../../features/favorite/domain/repository/favorite_repository.dart';
import '../../features/favorite/presentation/bloc/favorite_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Repositories
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(getIt<AppDatabase>()),
  );

  // Blocs (factory = new instance each time)
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(getIt<MovieRepository>()),
  );
  getIt.registerFactory<DetailBloc>(
    () => DetailBloc(getIt<MovieRepository>()),
  );
  getIt.registerFactory<FavoriteBloc>(
    () => FavoriteBloc(getIt<FavoriteRepository>()),
  );
}
