import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

class AiTextToImageGenerator extends StatefulWidget {
  const AiTextToImageGenerator({super.key});
  @override
  State<AiTextToImageGenerator> createState() => _AiTextToImageGeneratorState();
}

class _AiTextToImageGeneratorState extends State<AiTextToImageGenerator> {
  // Controller for the input field
  final TextEditingController _queryController = TextEditingController();
  // Instance of StabilityAI for image generation
  final StabilityAI _ai = StabilityAI();
  // API key for the AI service
  final String apiKey = 'sk-vHSVx57j5Eskux099546hEArdfBTGczl0131es5Mp7Qg4AFX';
  // Set the style for the generated image
  final ImageAIStyle imageAIStyle = ImageAIStyle.digitalPainting;
  // Flag to check if images have been generated

  bool isItems = false;
  // Function to generate images based on the input text
  Future<Uint8List> _generate(String query) async {
    Uint8List image = await _ai.generateImage(
      apiKey: apiKey,
      imageAIStyle: imageAIStyle,
      prompt: query,
    );
    return image;
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Text to Image",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Container(
              width: double.infinity,
              height: 55,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: TextField(
                controller: _queryController,
                decoration: const InputDecoration(
                  hintText: "Enter your prompt",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: isItems
                  ? FutureBuilder<Uint8List>(
                      future: _generate(_queryController.text),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(snapshot.data!),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  : const Center(
                      child: Text(
                        'No any image generated yet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: () {
                String query = _queryController.text;
                if (query.isNotEmpty) {
                  setState(() {
                    isItems = true;
                  });
                } else {
                  if (kDebugMode) {
                    print('Query is empty !!');
                  }
                }
              },
              child: const Text("Generate Image"),
            ),
          ],
        ),
      ),
    );
  }
}
