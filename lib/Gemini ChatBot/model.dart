class ModelMessage {
  final bool isPromt;
  final String message;
  final DateTime time;

  ModelMessage({
    required this.isPromt,
    required this.message,
    required this.time,
  });
}

  // Future<void> sendMessage() async {
  //   final message = promprController.text;
  //   // for prompt
  //   setState(() {
  //     promprController.clear();
  //     prompt.add(
  //       ModelMessage(
  //         isPromt: true,
  //         message: message,
  //         time: DateTime.now(),
  //       ),
  //     );
  //   });
  //   //for respond
  //   final content = [Content.text(message)];
  //   final response = await model.generateContent(content);
  //   setState(() {
  //     prompt.add(
  //       ModelMessage(
  //         isPromt: false,
  //         message: response.text ?? "",
  //         time: DateTime.now(),
  //       ),
  //     );
  //   });
  // }

// Future<void> sendMessage() async {
  //   final message = promprController.text;
  //   if (message.isEmpty) return; // Prevent sending empty messages

  //   setState(() {
  //     promprController.clear();
  //     prompt.add(ModelMessage(
  //       isPromt: true,
  //       message: message,
  //       time: DateTime.now(),
  //     ));
  //   });

  //   try {
  //     final content = [Content.text(message)];
  //     final response = await model.generateContent(content);

  //     String reply = response.text ?? "Sorry, I couldn't understand that.";

  //     setState(() {
  //       prompt.add(ModelMessage(
  //         isPromt: false,
  //         message: reply,
  //         time: DateTime.now(),
  //       ));
  //     });
  //   } catch (error) {
  //     setState(() {
  //       prompt.add(ModelMessage(
  //         isPromt: false,
  //         message: "Error: Failed to get a response from AI.",
  //         time: DateTime.now(),
  //       ));
  //     });
  //     print("AI ChatBot Error: $error");
  //   }
  // }

// try {
    //   final content = [Content.text(message)];
    //   final response = await model.generateContent(content);

    //   // Debugging: Print the full response
    //   print("API Response: ${response.text}");

    //   String reply = response.text ?? "Sorry, I couldn't understand that.";

    //   setState(() {
    //     prompt.add(ModelMessage(
    //       isPromt: false,
    //       message: reply,
    //       time: DateTime.now(),
    //     ));
    //   });
    // } catch (error) {
    //   print("AI ChatBot Error: $error");

    //   setState(() {
    //     prompt.add(ModelMessage(
    //       isPromt: false,
    //       message: "Error: Failed to get a response from AI.",
    //       time: DateTime.now(),
    //     ));
    //   });
    // }