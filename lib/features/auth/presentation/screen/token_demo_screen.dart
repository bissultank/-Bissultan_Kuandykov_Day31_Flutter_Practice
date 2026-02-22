import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/localization/locale_switcher.dart';
import '../../data/storage/token_storage.dart';

class TokenDemoScreen extends StatefulWidget {
  final String source;

  const TokenDemoScreen({super.key, required this.source});

  @override
  State<TokenDemoScreen> createState() => _TokenDemoScreenState();
}

class _TokenDemoScreenState extends State<TokenDemoScreen> {
  final TokenStorage _tokenStorage = getIt<TokenStorage>();
  String? _tokenView;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    setState(() => _loading = true);
    final dto = await _tokenStorage.readToken();
    if (!mounted) return;

    final isRu = context.read<LocaleCubit>().state.languageCode == 'ru';
    final locale = isRu ? 'ru' : 'en';
    final dateFormat = DateFormat.yMMMd(locale).add_Hm();
    final noToken = isRu ? 'Токен не найден' : 'Token not found';
    final savedLabel = isRu ? 'Сохранен' : 'Saved';

    setState(() {
      _loading = false;
      _tokenView = dto == null
          ? noToken
          : '${dto.token}\n$savedLabel: ${dateFormat.format(dto.savedAt)}';
    });
  }

  Future<void> _saveDemoToken() async {
    setState(() => _loading = true);
    final demoToken = 'demo_${DateTime.now().millisecondsSinceEpoch}';
    await _tokenStorage.saveToken(demoToken);
    await _loadToken();
  }

  Future<void> _deleteToken() async {
    setState(() => _loading = true);
    await _tokenStorage.deleteToken();
    await _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    final isRu = context.select((LocaleCubit cubit) {
      return cubit.state.languageCode == 'ru';
    });
    final title = isRu ? 'Демо токен' : 'Token Demo';
    final saveLabel = isRu ? 'Сохранить demo токен' : 'Save demo token';
    final readLabel = isRu ? 'Прочитать токен' : 'Read token';
    final deleteLabel = isRu ? 'Удалить токен' : 'Delete token';

    return Scaffold(
      appBar: AppBar(
        title: Text('$title (${widget.source})'),
        actions: const [
          LocaleSwitcher(),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _saveDemoToken,
              child: Text(saveLabel),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loading ? null : _loadToken,
              child: Text(readLabel),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loading ? null : _deleteToken,
              child: Text(deleteLabel),
            ),
            const SizedBox(height: 16),
            if (_loading) const LinearProgressIndicator(),
            if (_tokenView != null) SelectableText(_tokenView!),
          ],
        ),
      ),
    );
  }
}
