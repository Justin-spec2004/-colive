import 'package:flutter_localization/flutter_localization.dart';
import 'locales.dart';

final _loc = FlutterLocalization.instance;

/// Return the translated string for [key] in the current locale.
/// Falls back to [key] itself if not found.
String tr(String key) {
  final lang = _loc.currentLocale?.languageCode ?? 'en';

  final locale = LOCALES.firstWhere(
    (m) => m.languageCode == lang,
    orElse: () => LOCALES.first,
  );

  // ✅ use mapData
  return (locale.mapData[key] as String?) ?? key;
}
