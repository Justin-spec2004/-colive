import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:font_change_md/Gemini%20ChatBot/gemini_ai.dart';
import 'package:font_change_md/Login%20Signup/Screen/logout_screen.dart';
import 'package:font_change_md/loading/loading.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';
import 'package:font_change_md/view/about_screen.dart';
import 'package:font_change_md/view/accountprofile.dart';
import 'package:font_change_md/view/ai_choose.dart';
import 'package:font_change_md/view/checking_internet.dart';
import 'package:font_change_md/view/ecosia_screen.dart';
import 'package:font_change_md/view/history_screen.dart';
import 'package:font_change_md/view/internet_provider.dart';
import 'package:font_change_md/view/settings_screen.dart';
// import 'package:font_change_md/view/theme_provider.dart';
// import 'package:font_change_md/view/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:docx_template/docx_template.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';

class EcoFontConverterScreen extends StatefulWidget {
  const EcoFontConverterScreen({super.key});
  @override
  _EcoFontConverterScreenState createState() => _EcoFontConverterScreenState();
}

class _EcoFontConverterScreenState extends State<EcoFontConverterScreen> {
  Color getContrastingTextColor(Color backgroundColor) {
    // Check if the background is dark
    double brightness = (backgroundColor.red * 0.299) +
        (backgroundColor.green * 0.587) +
        (backgroundColor.blue * 0.114);
    return brightness > 128 ? Colors.black : Colors.white;
  }

  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  Color _fontColor = Colors.black;
  Color _highlightColor = Colors.transparent;
  List<Widget> _navigationItem(BuildContext context) => [
        Icon(Icons.account_circle, color: Theme.of(context).iconTheme.color),
        Icon(Icons.info, color: Theme.of(context).iconTheme.color),
        Image.asset('assets/icons/ecosia.png', width: 24, height: 24),
        Icon(Icons.rocket, color: Theme.of(context).iconTheme.color),
        Icon(Icons.history, color: Theme.of(context).iconTheme.color),
        Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
        Icon(Icons.logout, color: Theme.of(context).iconTheme.color),
      ];
  final List<String> _fontList = [
    "Times New Roman",
    "Calibri",
    "Arial",
    "Serif",
    "Sans-serif",
    "Script"
  ];

  String _selectedFont = "Times New Roman";
  Color bgColor = Colors.blue;
  TextEditingController _textController = TextEditingController();
  String _convertedText = "";
  List<String> _historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory(); //Load history when the screen is opened
    _textController.addListener(() {
      setState(() {
        _convertedText = _applyEcoFont(_textController.text);
        // _fontColor = getContrastingTextColor(bgColor);
      });
    });
  }

  void _resetText() async {
    setState(() async {
      _textController.clear();
      _convertedText = "";
      showLoadingDialog(context); // Show Loading Dialog
      await Future.delayed(const Duration(seconds: 2)); // Simulate a task
      Navigator.pop(context);
      await _saveHistory(); // Save history when the text is reset
    });
    _triggerVibration("reset");
  }

  void _copyText() async {
    if (_convertedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _convertedText));
      _triggerVibration("copy");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Copied to clipboard!")),
      );

      // ✅ Save to history
      await _addToHistory(_convertedText, _selectedFont);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Logout"),
        content: Text("Do you want to leave?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog first
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogoutScreen()),
              );
            },
            child: Text("Exit", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const Loading(); // Uses your custom Loading widget
      },
    );
  }

  Future<void> _saveAsPDF() async {
    if (_convertedText.isEmpty) return;

    final pdf = pw.Document();

    // Load the selected font
    final ByteData fontData = await rootBundle
        .load('assets/fonts/${_selectedFont.replaceAll(" ", "")}.ttf');
    final Uint8List fontBytes = fontData.buffer.asUint8List();
    final ttf = pw.Font.ttf(fontBytes.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
            _convertedText,
            style: pw.TextStyle(font: ttf, fontSize: 20),
          ),
        ),
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/eco_text.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF saved to ${file.path}")),
    );

    await _addToHistory(_convertedText, _selectedFont);
  }

  Future<void> _saveAsWord() async {
    if (_convertedText.isEmpty) return;

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/eco_text.docx");

    final doc = await DocxTemplate.fromBytes(await rootBundle
        .load('assets/template.docx')
        .then((data) => data.buffer.asUint8List()));
    final content = Content();
    content.add(TextContent("text", _convertedText));

    final d = await doc.generate(content);
    await file.writeAsBytes(d!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Word file saved to ${file.path}")),
    );

    // ✅ Save to history
    await _addToHistory(_convertedText, _selectedFont);
  }

  Future<void> _addToHistory(String text, String font) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];

    // Save text and font together in JSON format
    history.add(jsonEncode({'text': text, 'font': font}));

    await prefs.setStringList('history', history);
  }

  Future<void> _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("history", _historyList);
    print("History saved: $_historyList"); // Debugging output
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _historyList = prefs.getStringList("history") ?? [];
    });
    print("History loaded: $_historyList"); // Debugging output
  }

  void _triggerVibration(String action) async {
    if (await Vibration.hasVibrator()) {
      switch (action) {
        case "copy":
          Vibration.vibrate(pattern: [0, 100, 50, 100]);
          break;
        case "reset":
          Vibration.vibrate(pattern: [0, 300, 100, 400]);
          break;
      }
    }
  }

  String _applyEcoFont(String text) {
    String converted =
        text.replaceAll("o", "◎").replaceAll("e", "℮").replaceAll("a", "a");

    print("Converted Text: $converted"); // Debugging output

    if (converted.isNotEmpty && !_historyList.contains(converted)) {
      setState(() {
        _historyList.insert(0, converted);
        _saveHistory(); // Save history when a new conversion happens
      });
    }

    return converted;
  }

  @override
  Widget build(BuildContext context) {
    List<String> _historyList = [];
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        if (!internetProvider.isConnected) {
          //Future.microtask
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckingInternet()),
            );
          });
        }
        return Scaffold(
          appBar: AppBar(
            title:
                //     Text(
                //   tr(LocaleData.settings), // 👈 use helper
                //   style: Theme.of(context).textTheme.bodyLarge,
                // ),
                Text(
              tr(LocaleData.app_name),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButton<String>(
                  value: _selectedFont,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFont = newValue!;
                    });
                  },
                  items: _fontList.map<DropdownMenuItem<String>>((String font) {
                    return DropdownMenuItem<String>(
                      value: font,
                      child: Text(font, style: TextStyle(fontFamily: font)),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: tr(LocaleData.enter_text),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  style: TextStyle(
                    fontFamily: _selectedFont,
                    fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                    fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                    decoration: _isUnderline
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.format_bold,
                          color: _isBold ? Colors.blue : Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isBold = !_isBold;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.format_italic,
                          color: _isItalic ? Colors.blue : Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isItalic = !_isItalic;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.format_underline,
                          color: _isUnderline ? Colors.blue : Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isUnderline = !_isUnderline;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.color_lens, color: Colors.grey),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Pick a text color"),
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  pickerColor: _fontColor,
                                  onColorChanged: (color) {
                                    setState(() {
                                      _fontColor = color;
                                    });
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  tr(LocaleData.converted_text),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(12),
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _convertedText.isNotEmpty
                        ? _convertedText
                        : tr(LocaleData.converted_text_description),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: _selectedFont,
                      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                      fontStyle:
                          _isItalic ? FontStyle.italic : FontStyle.normal,
                      decoration: _isUnderline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      color: _fontColor,
                      backgroundColor: _highlightColor,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(Icons.copy, tr(LocaleData.copy),
                        _copyText, _convertedText.isNotEmpty),
                    _buildActionButton(
                        Icons.refresh, tr(LocaleData.reset), _resetText, true),
                    _buildActionButton(
                        Icons.picture_as_pdf,
                        tr(LocaleData.savePDF),
                        _saveAsPDF,
                        _convertedText.isNotEmpty),
                    _buildActionButton(Icons.file_copy, tr(LocaleData.saveWord),
                        _saveAsWord, _convertedText.isNotEmpty),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: bgColor,
            items: _navigationItem(context),
            index: 3, // Set the current index
            animationDuration: const Duration(milliseconds: 300),
            onTap: (index) async {
              if (index == 0) {
                showLoadingDialog(context); // Show Loading Dialog
                await Future.delayed(
                    const Duration(seconds: 2)); // Simulate a task
                Navigator.pop(context); // Close the loading dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              } else if (index == 1) {
                showLoadingDialog(context); // Show Loading Dialog
                await Future.delayed(
                    const Duration(seconds: 2)); // Simulate a task
                Navigator.pop(context); // Close the loading dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              } else if (index == 2) {
                showLoadingDialog(context); // Show Loading Dialog
                await Future.delayed(
                    const Duration(seconds: 2)); // Simulate a task
                Navigator.pop(context); // Close the loading dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EcosiaCloneScreen()),
                );
              } else if (index == 3) {
                showLoadingDialog(context); // Show Loading Dialog
                await Future.delayed(
                    const Duration(seconds: 2)); // Simulate a task
                Navigator.pop(context); // Close the loading dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AIChoose()),
                );
              } else if (index == 4) {
                showLoadingDialog(context); // Show Loading Dialog
                await Future.delayed(
                    const Duration(seconds: 2)); // Simulate a task
                Navigator.pop(context); // Close the loading dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoryScreen(historyList: _historyList),
                  ),
                );
              } else if (index == 5) {
                showLoadingDialog(context); // Show Loading Dialog
                await Future.delayed(
                    const Duration(seconds: 2)); // Simulate a task
                Navigator.pop(context); // Close the loading dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              } else if (index == 6) {
                showLoadingDialog(context); // Show Loading Dialog
                await Future.delayed(
                    const Duration(seconds: 2)); // Simulate a task
                Navigator.pop(context); // Close the loading dialog
                _showLogoutDialog();
              }
              setState(() {});
            },
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed, bool isEnabled) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon,
                //Colors.blue : Colors.grey
                size: 30,
                color: isEnabled ? Colors.blue : Colors.grey),
            onPressed: isEnabled ? onPressed : null,
          ),
          Text(
            label,
            //Colors.black : Colors.grey
            style: TextStyle(
              color: isEnabled
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Future<Color?> _pickColor(BuildContext context, Color currentColor) async {
//   return showDialog<Color>(
//     context: context,
//     builder: (BuildContext context) {
//       Color tempColor = currentColor;
//       return AlertDialog(
//         title: Text("Select Color"),
//         content: SingleChildScrollView(
//           child: BlockPicker(
//             pickerColor: tempColor,
//             onColorChanged: (color) {
//               tempColor = color;
//             },
//           ),
//         ),
//         actions: [
//           TextButton(
//             child: Text("Cancel"),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           TextButton(
//             child: Text("Select"),
//             onPressed: () {
//               Navigator.pop(context, tempColor);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
