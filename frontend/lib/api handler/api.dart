import 'dart:convert';
import 'package:http/http.dart' as http;
import '../class/message.dart';

const api_url = '192.168.1.22:5000';
const msg_api = 'input';

Future<Message> sendMessage(String input) async {
  var url = Uri.http(api_url, msg_api, {'user_input': input});
  var response = await http.get(url);
  print("Received data: ${response.body}"); // Logging response

  if (response.statusCode == 200) {
    var parsed = jsonDecode(response.body);
    if (parsed != null &&
        parsed is Map<String, dynamic> &&
        parsed.containsKey('res') &&
        parsed.containsKey('sender')) {
      return Message.fromJson(parsed);
    } else {
      throw Exception('Invalid response format from the backend.');
    }
  } else {
    throw Exception(
        'Failed to load message from the backend. Status code: ${response.statusCode}');
  }
}
