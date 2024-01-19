import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendUidToServer() async {
    try {
      // Get the current user from Firebase Authentication
      User? user = _auth.currentUser;
      if (user == null) {
        // User not signed in
        return;
      }

      // Obtain the user ID
      String uid = user.uid;

      // Define the URL of your Flask server
      String serverUrl = 'http://127.0.0.1:5000';

      // Make a POST request to send the UID to the server
      var response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'}, // Set Content-Type
        body: jsonEncode({'uid': uid}),
      );

      // Print the response from the server
      print('Response from server: ${response.body}');
    } catch (e) {
      print('Error sending UID to server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send UID to Flask Server'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: sendUidToServer,
          child: Text('Send UID to Server'),
        ),
      ),
    );
  }
}