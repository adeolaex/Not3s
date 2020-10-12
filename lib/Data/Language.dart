class DefaultWords {
  // This Map holds the hard-coded words of the application
  // It would later be used to send to a server that translate each value as per user request
  Map<String, String> wordsEN = {
    "searchPlaceHolder": "s",
  };
}

// The factory in this class would be used to get parse the json response from the google translate api
class TrasnlatedWords {
  final Map<String, String> translatedWords;

  TrasnlatedWords({
    this.translatedWords,
  });

  factory TrasnlatedWords.toJson(Map<String, String> json) {
    return TrasnlatedWords(
      translatedWords: json,
    );
  }
}

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
