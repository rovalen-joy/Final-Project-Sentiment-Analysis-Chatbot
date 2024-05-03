import 'package:flutter/material.dart';
import '../class/message.dart';
import 'package:flutter/widgets.dart';
import '../api handler/api.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Message> messages = [
    new Message(
        sender: "bot",
        content:
            "Hi! I'm Sentinelle, your sentimental analyzer chatbot. Please enter a sentence with no less than 250 characters."),
  ];

  void handleSendMessage() async {
    // Trim leading and trailing white spaces from the text entered in the text field
    String trimmedText = _controller.text.trim();

    // Check if the trimmed text is empty
    if (trimmedText.isEmpty) {
      // Show an error dialog if no text is entered
      showErrorDialog("Please enter at least one non-space character.");
    }
    // Check if the trimmed text length exceeds 250 characters
    else if (trimmedText.length > 250) {
      // Show an error dialog if the text exceeds 250 characters
      showErrorDialog("The message cannot exceed 250 characters.");
    }
    // Check if the trimmed text contains valid characters
    else if (!containsValidCharacters(trimmedText)) {
      // Show an error dialog if the text does not contain valid characters
      showErrorDialog(
          "Please enter a real word. Punctuation alone is not allowed.");
    }
    // Proceed if it passes the validations
    else {
      try {
        // Add the user's message to the list of messages, displaying it in the UI
        setState(() {
          messages.insert(0, Message(sender: "me", content: trimmedText));
        });

        // Send the trimmed text to the backend and await the response
        Message response = await sendMessage(trimmedText);

        // Add the response from the backend to the list of messages, displaying it in the UI
        setState(() {
          messages.insert(0, response);
          // Clear the text field to ready it for new input
          _controller.clear();
        });
      }
      // Handle any exceptions that occur during the message sending process
      catch (e) {
        // Show an error dialog if an exception is caught
        showErrorDialog("Failed to send message: $e");
      }
    }
  }

  bool containsValidCharacters(String text) {
    // Check if the text contains any alphabetic characters
    return text.contains(RegExp(r'[a-zA-Z]'));
  }

// Error dialog display
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[800],
          centerTitle: true,
          title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/chatbot.png', height: 30), //logo of chatbot
                Text('Sentinelle Chatbot',
                    style: TextStyle(
                        color: Colors.white, fontSize: 18)), // name of chatbot
              ])),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                bool isMe = messages[index].sender ==
                    "me"; //check if the sender is 'me' or the user
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[300] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      messages[index].content,
                      style:
                          TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText:
                          'Enter your message', // hint text shown in textfield
                      filled: true,
                      fillColor: Color.fromARGB(255, 227, 216, 216),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixText:
                          '${_controller.text.length}/250', //displays character count
                    ),
                    keyboardType: TextInputType
                        .multiline, // keyboard type for multiline input of the user
                    maxLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (text) => handleSendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue[800]),
                  onPressed: handleSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
