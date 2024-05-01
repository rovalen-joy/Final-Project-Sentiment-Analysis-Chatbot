import 'package:flutter/material.dart';
import '../class/message.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Message> messages = [
    new Message(sender: "bot", content: "Hi! I'm Sentinelle, your sentimental analyzer chatbot. Please enter a sentence with no less than 250 characters."),
  ];

  void sendMessage() {
    // Function that handles sending of messages
    String trimmedText = _controller.text.trim();

//Error Dialogs
    if (trimmedText.isEmpty) {
      // Check if the text is empty and shows and error if true
      showErrorDialog("Please enter at least one non-space character.");
    } else if (trimmedText.length > 250) {
      // Check if the text exceeds 250 chars and shows an error if true
      showErrorDialog("The message cannot exceed 250 characters.");
    } else if (!containsValidCharacters(trimmedText)) {
      //Check if the userinputs a text and not punctuation alone
      showErrorDialog(
          "Please enter a real word. Punctuation alone is not allowed.");
    } else {
      setState(() {
        messages.insert(0, Message(sender: "me", content: trimmedText));
        _controller.clear(); // Clearing the text field after user enter a texts
      });
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
            Image.asset('assets/logo.png',
                height: 30), // logo image [temporary only, need pa e change]
            Text('Chatbot Name',
                style:
                    TextStyle(color: Colors.white)), // Insert name of chatbot
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length, // Number of messages
              reverse: true,
              itemBuilder: (context, index) {
                bool isMe =
                    messages[index].sender == "me"; // Check the message of user
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
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    // textfield for the user input
                    controller: _controller,
                    onChanged: (text) {
                      setState(() {});
                    },
                    onSubmitted: (text) => sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      filled: true,
                      fillColor: Color.fromARGB(255, 227, 216, 216),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixText:
                          '${_controller.text.length}/250', // Character count
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    textInputAction: TextInputAction.send,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue[800]),
                  onPressed:
                      sendMessage, // when user hit "enter" it will send the message
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
