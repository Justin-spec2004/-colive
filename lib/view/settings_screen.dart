// import 'package:flutter/material.dart';
// import 'package:font_change_md/loading/loading.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:font_change_md/localization/locales.dart';
// import 'package:provider/provider.dart';
// import 'theme_provider.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   final FlutterLocalization localization = FlutterLocalization.instance;

//   void showLoadingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) => const Loading(),
//     );
//   }

//   String getCurrentLanguageCode() {
//     return localization.currentLocale?.languageCode ?? 'en';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final currentLang = getCurrentLanguageCode();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           localization.getString(LocaleData.settings),
//           style: Theme.of(context).textTheme.bodyLarge,
//         ),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             leading: Icon(themeProvider.themeMode == ThemeMode.dark
//                 ? Icons.nightlight_round
//                 : Icons.wb_sunny),
//             title: Text(localization.getString(LocaleData.light_darkmode)),
//             trailing: Switch(
//               value: themeProvider.themeMode == ThemeMode.dark,
//               onChanged: (value) async {
//                 showLoadingDialog(context);
//                 await Future.delayed(const Duration(seconds: 2));
//                 Navigator.pop(context);
//                 themeProvider.toggleTheme();
//               },
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.language),
//             title: const Text("Language"),
//             trailing: DropdownButton<String>(
//               value: currentLang,
//               onChanged: (String? newLangCode) async {
//                 if (newLangCode == null) return;

//                 showLoadingDialog(context);
//                 await Future.delayed(const Duration(seconds: 1));
//                 localization.translate(newLangCode);
//                 Navigator.pop(context);
//                 setState(() {}); // ✅ Now valid in StatefulWidget
//               },
//               items: LOCALES.map((locale) {
//                 return DropdownMenuItem(
//                   value: locale.languageCode,
//                   child: Text(locale.languageCode.toUpperCase()),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_change_md/loading/loading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:font_change_md/localization/translator.dart'; // << add this

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Loading(),
    );
  }

  String getCurrentLanguageCode() =>
      localization.currentLocale?.languageCode ?? 'en';

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final currentLang = getCurrentLanguageCode();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(LocaleData.settings), // 👈 use helper
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: ListView(
        children: [
          // ── Theme switch ──────────────────────────
          ListTile(
            leading: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.nightlight_round
                : Icons.wb_sunny),
            title: Text(tr(LocaleData.light_darkmode)), // 👈 use helper
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (val) async {
                showLoadingDialog(context);
                await Future.delayed(const Duration(seconds: 2));
                Navigator.pop(context);
                themeProvider.toggleTheme();
              },
            ),
          ),

          // ── Language dropdown ─────────────────────
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(tr(LocaleData.language)), // add this key
            trailing: DropdownButton<String>(
              value: currentLang,
              onChanged: (code) async {
                if (code == null) return;
                showLoadingDialog(context);
                await Future.delayed(const Duration(seconds: 1));
                localization.translate(code); // just change locale
                Navigator.pop(context);
                setState(() {}); // rebuild with new lang
              },
              items: LOCALES
                  .map((l) => DropdownMenuItem(
                        value: l.languageCode,
                        child: Text(l.languageCode.toUpperCase()),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
