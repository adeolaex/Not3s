// This are sent over to a popupmenu
// It holds the languages that can used with a google translate api
class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(
    this.id,
    this.name,
    this.flag,
    this.languageCode,
  );
  static List<Language> list() {
    return <Language>[
      Language(1, 'English', '🇬🇧', 'en'),
      Language(2, 'Hungarian', '🇭🇺', 'hu'),
      Language(3, 'Japanese', '🇯🇵', 'ja'),
      Language(4, 'Chinese', '🇨🇳', 'ch'),
      Language(5, 'French', '🇫🇷', 'fr'),
    ];
  }
}
