import 'package:flutter/material.dart';
import 'package:font_change_md/Gemini%20ChatBot/gemini_ai.dart';
import 'package:font_change_md/image_generator/image_generator.dart';
import 'package:font_change_md/loading/loading.dart';
// import 'package:font_change_md/optimization/fileupload_screen.dart';
import 'package:font_change_md/optimization/fileupload_screen2.dart';
import 'package:font_change_md/view/about_ai.dart';
// import 'package:font_change_md/optimization/ai_converter.dart';
// import 'package:font_change_md/optimization/converter_screen.dart';
// import 'package:font_change_md/optimization/fileupload_screen.dart';
// import 'package:font_change_md/optimization/uploadfile_screen.dart';
// import 'package:font_change_md/optimization/converter_screen.dart';
import 'package:font_change_md/view/home/home_view.dart';

class AIChoose extends StatefulWidget {
  const AIChoose({super.key});

  @override
  _AIChooseState createState() => _AIChooseState();
}

class _AIChooseState extends State<AIChoose> {
  double _fabX = 300; // Initial X position
  double _fabY = 600; // Initial Y position

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const Loading(); // Uses your custom Loading widget
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB0926A), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Title
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "A.I SELECTION",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF706134),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // Instruction Text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Choosing any kind of A.I you wanna use",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF706134),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 50),

                // Quiz Buttons
                buildQuizButton(context, "A.I CHATBOT", "LAW 201", Icons.gavel),
                buildQuizButton2("Écolive A.I", "LAW 201", Icons.gavel),
                buildQuizButton4(
                    "Écolive Image Generator", "LAW 201", Icons.gavel),
                buildQuizButton3("INFORMATION", "", Icons.info, isIntro: true),
              ],
            ),
          ),

          // Draggable Floating Action Button
          Positioned(
            left: _fabX,
            top: _fabY,
            child: Draggable(
              feedback: FloatingActionButton(
                backgroundColor: Colors.white,
                child: const Icon(Icons.home, color: Colors.blue, size: 30),
                onPressed: () {},
              ),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  _fabX = details.offset.dx;
                  _fabY = details.offset.dy;
                });
              },
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: const Icon(Icons.home, color: Colors.blue, size: 30),
                onPressed: () async {
                  showLoadingDialog(context);
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EcoFontConverterScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuizButton(
      BuildContext context, String text, String subtitle, IconData icon,
      {bool isIntro = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            const BoxShadow(
              color: Color(0xFFFAE7C9),
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: isIntro
              ? Icon(icon, color: Colors.orange, size: 40)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.black),
                    Text(subtitle, style: const TextStyle(fontSize: 10)),
                  ],
                ),
          title: Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF706134)),
          ),
          onTap: () async {
            showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GeminiChatBot()));
          },
        ),
      ),
    );
  }

  Widget buildQuizButton2(String text, String subtitle, IconData icon,
      {bool isIntro = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            const BoxShadow(
              color: Color(0xFFFAE7C9),
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: isIntro
              ? Icon(icon, color: Colors.orange, size: 40)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.black),
                    Text(subtitle, style: const TextStyle(fontSize: 10)),
                  ],
                ),
          title: Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF706134)),
          ),
          onTap: () async {
            showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FileUploadScreen2()));
            // Add navigation logic here
          },
        ),
      ),
    );
  }

  Widget buildQuizButton3(String text, String subtitle, IconData icon,
      {bool isIntro = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            const BoxShadow(
              color: Color(0xFFFAE7C9),
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: isIntro
              ? Icon(icon, color: Color(0xFF706134), size: 40)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.black),
                    Text(subtitle, style: const TextStyle(fontSize: 10)),
                  ],
                ),
          title: Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF706134)),
          ),
          onTap: () async {
            showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutAIScreen()));
            // Add navigation logic here
          },
        ),
      ),
    );
  }

  Widget buildQuizButton4(String text, String subtitle, IconData icon,
      {bool isIntro = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            const BoxShadow(
              color: Color(0xFFFAE7C9),
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: isIntro
              ? Icon(icon, color: Color(0xFF706134), size: 40)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.black),
                    Text(subtitle, style: const TextStyle(fontSize: 10)),
                  ],
                ),
          title: Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF706134)),
          ),
          onTap: () async {
            showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AiTextToImageGenerator()));
            // Add navigation logic here
          },
        ),
      ),
    );
  }
}
