class Lan {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Lan(
    this.id,
    this.name,
    this.flag,
    this.languageCode,
  );
  static List<Lan> list() {
    return <Lan>[
      Lan(1, 'English', '🇬🇧', 'en'),
      Lan(2, 'Hungarian', '🇭🇺', 'hu'),
      Lan(3, 'Japanese', '🇯🇵', 'ja'),
      Lan(4, 'Chinese', '🇨🇳', 'ch'),
      Lan(5, 'French', '🇫🇷', 'fr'),
    ];
  }
}
