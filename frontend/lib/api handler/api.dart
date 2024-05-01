/*
To be modified:

import 'dart:convert';

import 'package:http/http.dart' as http;
import '../class/message.dart';

const api_url = '192.168.1.100:5000';
const msg_api = 'input';

Future<Message> sendMessage(String input) async {
  print("Starting api call for ${msg_api}");
  var msg_body = {'user_input': input};
  // create the URL for the API request
  var url = Uri.http(
    api_url,
    msg_api,
    msg_body,
  );
  print(url);
  var response = await http.get(url);
  print(response.body);
  var parsed = jsonDecode(response.body);
  return Message.fromJson(parsed);
} */