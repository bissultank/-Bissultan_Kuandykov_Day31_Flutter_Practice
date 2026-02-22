import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'core/di/injection.dart';
import 'core/localization/locale_cubit.dart';
import 'core/router/app_router.dart';
import 'core/themes/app_theme.dart';
import 'features/favorite/presentation/bloc/favorite_bloc.dart';

final _appRouter = createRouter();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<FavoriteBloc>()..add(const FavoriteWatch())),
        BlocProvider.value(value: getIt<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          Intl.defaultLocale = locale.toLanguageTag();
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark(),
            themeMode: ThemeMode.dark,
            locale: locale,
            supportedLocales: const [Locale('ru'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _appRouter,
          );
        },
      ),
    );
  }
}
