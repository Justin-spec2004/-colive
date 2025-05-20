// import 'package:flutter/material.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../localization/locales.dart';

// final _loc = FlutterLocalization.instance;

// class LanguagePickerPage extends StatefulWidget {
//   const LanguagePickerPage({super.key});

//   @override
//   State<LanguagePickerPage> createState() => _LanguagePickerPageState();
// }

// class _LanguagePickerPageState extends State<LanguagePickerPage> {
//   late String _selected = 'en';

//   @override
//   void initState() {
//     super.initState();
//     _selected = _loc.currentLocale?.languageCode ?? 'en';
//   }

//   Future<void> _applyLanguage(String code) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('app_lang', code); // persist choice
//     _loc.translate(code); // change locale
//     if (mounted) Navigator.pop(context, true); // return to main flow
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Choose language')),
//       body: ListView(
//         children: LOCALES.map((l) {
//           final code = l.languageCode;
//           return RadioListTile(
//             value: code,
//             groupValue: _selected,
//             title: Text(code.toUpperCase()),
//             onChanged: (v) => _applyLanguage(code),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../localization/locales.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({super.key});

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Colors.white),
      onSelected: (Locale locale) {
        localization.translate(locale as String);
        setState(() {});
      },
      itemBuilder: (BuildContext context) {
        return LOCALES.map((mapLocale) {
          return PopupMenuItem<Locale>(
            value: mapLocale.locale,
            child: Text(
              mapLocale.locale.languageCode.toUpperCase(), // e.g. EN, FR
            ),
          );
        }).toList();
      },
    );
  }
}
