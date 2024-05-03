class Message {
  final String sender;
  final String content;

  // Constructor
  Message(
      {required this.sender,
      required this.content}); // A constructor requiring 'sender' and 'content' to initialize a Message object

  factory Message.fromJson(Map<String, dynamic> json) {
    String? sender =
        json['sender']; // attempts to retrieve the sender from the JSON map
    String? content = json[
        'res']; // attempts to retrieve the content using key 'res' from the JSON map
    if (sender == null || content == null) {
      throw Exception(
          'Received incomplete message data'); // throws an exception if any of them is null indicating incomplete data
    }
    return Message(
        sender: sender,
        content:
            content); // creates a new Message instance using the retrieved values if they are not null
  }
}
