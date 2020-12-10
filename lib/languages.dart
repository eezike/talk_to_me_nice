// Object to hold language name and codes
class Language {
  const Language(this.title, this.googleCode, this.flutterCode);

  final String title;
  final String googleCode;
  final String flutterCode;
}

// a list of languages we will be using
const List<Language> Languages = const <Language>[
  const Language('Spanish', "es", "es-ES"),
  const Language('French', "fr", "fr-FR"),
  const Language('German', "de", "de-DE"),
  const Language('English', "en", "en-US"),
  const Language('Dutch', "nl", "nl-BE"),
  const Language('Chinese', "zh-CN", "zh-CN"),
  const Language('Greek', "el", "el-GR"),
  const Language('Italian', "it", "it-IT"),
  const Language('Korean', "ko", "ko-KR"),
  const Language('Polish', "pl", "pl-PL"),
  const Language('Japanese', "ja", "ja-JP"),
  const Language('Arabic', "ar", "ar-SA"),
  const Language('Russian', "ru", "ru-RU"),
  const Language('Danish', "da", "da-DK"),
  const Language('Portuguese', "pt", "pt-PT"),
  const Language('Hebrew', "hu", "hu-HU"),
];