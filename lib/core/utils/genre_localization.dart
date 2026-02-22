const Map<String, String> genreRuMap = {
  'Action': 'Боевик',
  'Adult': 'Для взрослых',
  'Adventure': 'Приключения',
  'Anime': 'Аниме',
  'Children': 'Детский',
  'Comedy': 'Комедия',
  'Crime': 'Криминал',
  'DIY': 'Сделай сам',
  'Drama': 'Драма',
  'Espionage': 'Шпионаж',
  'Family': 'Семейный',
  'Fantasy': 'Фэнтези',
  'Food': 'Кулинария',
  'History': 'История',
  'Home and Garden': 'Дом и сад',
  'Horror': 'Ужасы',
  'Legal': 'Юридический',
  'Medical': 'Медицина',
  'Music': 'Музыка',
  'Mystery': 'Детектив',
  'Nature': 'Природа',
  'Romance': 'Мелодрама',
  'Science-Fiction': 'Научная фантастика',
  'Sports': 'Спорт',
  'Supernatural': 'Сверхъестественное',
  'Thriller': 'Триллер',
  'Travel': 'Путешествия',
  'War': 'Военный',
  'Western': 'Вестерн',
};

final Map<String, String> _genreEnMap = {
  for (final entry in genreRuMap.entries) entry.value: entry.key,
};

String localizeGenre(String genre, String languageCode) {
  if (languageCode == 'ru') {
    return genreRuMap[genre] ?? genre;
  }
  return _genreEnMap[genre] ?? genre;
}
