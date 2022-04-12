
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> getVal(String text) async {
  final response =
  await http.get(Uri.parse('http://api.open-notify.org/iss-now.json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    text = jsonDecode(response.body).toString();

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    text = "Hi";
  }
}