import 'package:flutter/material.dart';
import 'package:font_change_md/Gemini%20ChatBot/model.dart';
import 'package:font_change_md/view/checking_internet.dart';
import 'package:font_change_md/view/internet_provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GeminiChatBot extends StatefulWidget {
  const GeminiChatBot({super.key});
  @override
  State<GeminiChatBot> createState() => _GeminiChatBotState();
}

class _GeminiChatBotState extends State<GeminiChatBot> {
  TextEditingController promprController = TextEditingController();
  static const apiKey = "AIzaSyAlP9bSgFi3GOkE-Jw4Z6k6DNpsx6LVgss";

  // ✅ Default selected model
  String selectedModel = "gemini-1.5-flash-latest";

  // ✅ Map of Gemini versions with descriptions
  final Map<String, String> geminiModels = {
    "gemini-1.5-flash-latest": "Response very fast",
    "gemini-2.5-pro-exp-03-25": "Response slowly but much more correctly"
  };

  late GenerativeModel model;

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(model: selectedModel, apiKey: apiKey);
  }

  void updateModel(String newModel) {
    setState(() {
      selectedModel = newModel;
      model = GenerativeModel(model: selectedModel, apiKey: apiKey);
    });
  }

  Future<void> sendMessage() async {
    final message = promprController.text;
    if (message.isEmpty) return;

    // Hide keyboard
    FocusScope.of(context).unfocus();

    promprController.clear();

    setState(() {
      prompt.add(ModelMessage(
        isPromt: true,
        message: message,
        time: DateTime.now(),
      ));
    });

    try {
      final content = [Content.text(message)];
      final response = await model.generateContent(content);
      String reply =
          response.text?.trim() ?? "Sorry, I couldn't understand that.";

      setState(() {
        prompt.add(ModelMessage(
          isPromt: false,
          message: reply,
          time: DateTime.now(),
        ));
      });
    } catch (error) {
      setState(() {
        prompt.add(ModelMessage(
          isPromt: false,
          message: "Error: Failed to get a response from AI.",
          time: DateTime.now(),
        ));
      });
    }
  }

  final List<ModelMessage> prompt = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        if (!internetProvider.isConnected) {
          Future.microtask(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckingInternet()),
            );
          });
        }

        return Scaffold(
          backgroundColor: Color(0xFFFAE7C9),
          appBar: AppBar(
            elevation: 3,
            backgroundColor: Color(0xFFE1C78F),
            title: const Text("Chatbot"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IntrinsicWidth(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 0.5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedModel,
                        onChanged: (newModel) {
                          if (newModel != null) updateModel(newModel);
                        },
                        dropdownColor: Colors.white,
                        iconSize: 18,
                        isDense: true,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        items: geminiModels.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                Text(
                                  entry.value,
                                  style: const TextStyle(
                                      fontSize: 11, color: Color(0xFFB0926A)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: prompt.length,
                  itemBuilder: (context, index) {
                    final message = prompt[index];
                    return UserPrompt(
                      isPrompt: message.isPromt,
                      message: message.message,
                      date: DateFormat('hh:mm a').format(message.time),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    Expanded(
                      flex: 20,
                      child: TextField(
                        controller: promprController,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Enter a prompt here",
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: const CircleAvatar(
                        radius: 29,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ✅ Chat Bubble UI
  Container UserPrompt({
    required final bool isPrompt,
    required String message,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isPrompt ? 80 : 15,
        right: isPrompt ? 15 : 80,
      ),
      decoration: BoxDecoration(
        color: isPrompt ? Color(0xFF706134) : Color(0xFFB0926A),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: isPrompt ? const Radius.circular(20) : Radius.zero,
          bottomRight: isPrompt ? Radius.zero : const Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:font_change_md/Gemini%20ChatBot/model.dart';
// import 'package:font_change_md/view/checking_internet.dart';
// import 'package:font_change_md/view/internet_provider.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class GeminiChatBot extends StatefulWidget {
//   const GeminiChatBot({super.key});
//   @override
//   State<GeminiChatBot> createState() => _GeminiChatBotState();
// }

// class _GeminiChatBotState extends State<GeminiChatBot> {
//   TextEditingController promprController = TextEditingController();
//   static const apiKey = "AIzaSyAlP9bSgFi3GOkE-Jw4Z6k6DNpsx6LVgss";

//   // ✅ Default selected model
//   String selectedModel = "gemini-1.5-flash-latest";

//   // ✅ Map of Gemini versions with descriptions
//   final Map<String, String> geminiModels = {
//     "gemini-1.5-flash-latest": "Response very fast",
//     "gemini-2.5-pro-exp-03-25": "Response slowly but much more correctly"
//   };

//   // ✅ Create a GenerativeModel based on selection
//   late GenerativeModel model;

//   @override
//   void initState() {
//     super.initState();
//     model = GenerativeModel(model: selectedModel, apiKey: apiKey);
//   }

//   /// ✅ Update AI Model based on user selection
//   void updateModel(String newModel) {
//     setState(() {
//       selectedModel = newModel;
//       model = GenerativeModel(model: selectedModel, apiKey: apiKey);
//     });
//   }

//   /// ✅ Send Message to AI
//   Future<void> sendMessage() async {
//     final message = promprController.text;
//     if (message.isEmpty) return;

//     promprController.clear();

//     setState(() {
//       prompt.add(ModelMessage(
//         isPromt: true,
//         message: message,
//         time: DateTime.now(),
//       ));
//     });

//     try {
//       final content = [Content.text(message)];
//       final response = await model.generateContent(content);
//       print("API Response: $response");

//       String reply =
//           response.text?.trim() ?? "Sorry, I couldn't understand that.";

//       setState(() {
//         prompt.add(ModelMessage(
//           isPromt: false,
//           message: reply,
//           time: DateTime.now(),
//         ));
//       });
//     } catch (error) {
//       print("AI ChatBot Error: $error");

//       setState(() {
//         prompt.add(ModelMessage(
//           isPromt: false,
//           message: "Error: Failed to get a response from AI.",
//           time: DateTime.now(),
//         ));
//       });
//     }
//   }

//   final List<ModelMessage> prompt = [];

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<InternetProvider>(
//       builder: (context, internetProvider, child) {
//         if (!internetProvider.isConnected) {
//           Future.microtask(() {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => CheckingInternet()),
//             );
//           });
//         }

//         return Scaffold(
//           backgroundColor: Color(0xFFFAE7C9),
//           appBar: AppBar(
//             elevation: 3,
//             backgroundColor: Color(0xFFE1C78F),
//             title: const Text("A.I ChatBot"),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 5), // Adjusted padding
//                 child: Container(
//                   width: 200, // Slightly wider for better readability
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8, vertical: 2), // Compact padding
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8), // Rounded edges
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 4,
//                         spreadRadius: 0.5,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedModel,
//                       onChanged: (newModel) {
//                         if (newModel != null) updateModel(newModel);
//                       },
//                       dropdownColor: Colors.white,
//                       iconSize: 20, // Smaller dropdown arrow icon
//                       icon: const Icon(Icons.arrow_drop_down,
//                           color: Colors.black),
//                       style: const TextStyle(
//                           color: Colors.black, fontSize: 14), // Main text style
//                       isDense: true, // Makes dropdown more compact
//                       items: const [
//                         DropdownMenuItem<String>(
//                           value: "gemini-1.5-flash-latest",
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "gemini-1.5-flash-latest",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 13),
//                               ),
//                               Text(
//                                 "Response very fast",
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     color: Color.fromARGB(176, 176, 146, 106)),
//                               ),
//                             ],
//                           ),
//                         ),
//                         DropdownMenuItem<String>(
//                           value: "gemini-2.5-pro-exp-03-25",
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "gemini-2.5-pro-exp-03-25",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 13),
//                               ),
//                               Text(
//                                 "Response slowly but much correctly",
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     color: Color.fromARGB(176, 176, 146, 106)),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                   child: ListView.builder(
//                       itemCount: prompt.length,
//                       itemBuilder: (context, index) {
//                         final message = prompt[index];
//                         return UserPrompt(
//                           isPrompt: message.isPromt,
//                           message: message.message,
//                           date: DateFormat('hh:mm a').format(
//                             message.time,
//                           ),
//                         );
//                       })),
//               Padding(
//                 padding: const EdgeInsets.all(25),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 20,
//                       child: TextField(
//                         controller: promprController,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                         ),
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             hintText: "Enter a prompt here"),
//                       ),
//                     ),
//                     const Spacer(),
//                     GestureDetector(
//                       onTap: () {
//                         sendMessage();
//                       },
//                       child: const CircleAvatar(
//                         radius: 29,
//                         backgroundColor: Colors.green,
//                         child: Icon(
//                           Icons.send,
//                           color: Colors.white,
//                           size: 32,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   /// ✅ Chat Bubble UI
//   Container UserPrompt({
//     required final bool isPrompt,
//     required String message,
//     required String date,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(15),
//       margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
//         left: isPrompt ? 80 : 15,
//         right: isPrompt ? 15 : 80,
//       ),
//       decoration: BoxDecoration(
//         color: isPrompt
//             ? Color.fromARGB(112, 112, 97, 52)
//             : Color.fromARGB(176, 176, 146, 106),
//         borderRadius: BorderRadius.only(
//           topLeft: const Radius.circular(20),
//           topRight: const Radius.circular(20),
//           bottomLeft: isPrompt ? const Radius.circular(20) : Radius.zero,
//           bottomRight: isPrompt ? Radius.zero : const Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             message,
//             style: TextStyle(
//               fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
//               fontSize: 18,
//               color: isPrompt ? Colors.white : Colors.black,
//             ),
//           ),
//           Text(
//             date,
//             style: TextStyle(
//               fontSize: 14,
//               color: isPrompt ? Colors.white : Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
