import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

Future<String> getQuote() async {
  String url = Uri.encodeFull('https://pastebin.com/raw/jmhKjPLD');

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    log("Fetch Quote");
    log(response.body);
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
