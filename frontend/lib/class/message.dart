class Message {
  final String sender;
  final String content;

  // Constructor
  Message({required this.sender, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        // the sender and res are the name of the
        // params returned by Flask
        sender: json['sender'],
        content: json['content']);
  }
}
