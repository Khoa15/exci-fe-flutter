class Pos {
  final String key;
  final String value;

  const Pos({
    required this.key,
    required this.value,
  });

  @override
  String toString() {
    return 'Pos(key: $key, value: $value)';
  }
}

class ListPos {
  // Danh sách dữ liệu cố định
  final List<Pos> listPos = const [
    Pos(key: 'N', value: 'Noun'),
    Pos(key: 'V', value: 'Verb'),
    Pos(key: 'Adj', value: 'Adjective'),
    Pos(key: 'Adv', value: 'Adverb'),
    Pos(key: 'Pron', value: 'Pronoun'),
    Pos(key: 'Prep', value: 'Preposition'),
    Pos(key: 'Conj', value: 'Conjunction'),
    Pos(key: 'Interj', value: 'Interjection'),
  ];

  late Pos _selectedPos;

  ListPos() {
    _selectedPos = listPos.first; // Access listPos in the constructor
  }

  Pos get selectedPos => _selectedPos;
  set selectedPos(Pos value) {
    _selectedPos = value;
  }
}
