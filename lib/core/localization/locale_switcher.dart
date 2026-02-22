import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'locale_cubit.dart';

class LocaleSwitcher extends StatelessWidget {
  const LocaleSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final currentCode = locale.languageCode;
        final currentFlag = currentCode == 'ru' ? '🇷🇺' : '🇺🇸';
        final currentLabel = currentCode == 'ru' ? 'RU' : 'EN';

        return PopupMenuButton<String>(
          tooltip: 'Switch language',
          onSelected: (value) => context.read<LocaleCubit>().setLocale(value),
          itemBuilder: (context) => const [
            PopupMenuItem<String>(
              value: 'ru',
              child: Row(
                children: [
                  Text('🇷🇺'),
                  SizedBox(width: 8),
                  Text('Русский'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'en',
              child: Row(
                children: [
                  Text('🇺🇸'),
                  SizedBox(width: 8),
                  Text('English'),
                ],
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentFlag),
                const SizedBox(width: 6),
                Text(currentLabel),
              ],
            ),
          ),
        );
      },
    );
  }
}
