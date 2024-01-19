// api_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

 // Import necessary packages

Future<void> makeApiRequest() async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Get the Firebase token
    String? token = await user?.getIdToken();

    // Make an HTTP request to your Flask server
    var response = await http.get(
      Uri.parse('http://127.0.0.1:5000'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // Handle the response from the server
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
