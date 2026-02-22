import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/themes/app_theme.dart';
import 'features/favorite/presentation/bloc/favorite_bloc.dart';
import 'features/favorite/presentation/screen/favorite_screen.dart';
import 'features/home/presentation/screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FavoriteBloc>()..add(const FavoriteWatch()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        themeMode: ThemeMode.dark,
        home: const RootTabs(),
      ),
    );
  }
}

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [HomeScreen(), FavoriteScreen()];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
        ],
      ),
    );
  }
}
