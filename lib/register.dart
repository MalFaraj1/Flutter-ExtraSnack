import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_system/home.dart';
import 'dart:convert';

import 'package:restaurant_system/login.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> registerUser(BuildContext context, String username, String password, String email) async {
    const url = 'http://10.0.2.2/restoSys/adduser.php';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = jsonDecode(response.body);
    if (responseData['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            ElevatedButton(
              onPressed: () {
                registerUser(
                  context,
                  usernameController.text,
                  passwordController.text,
                  emailController.text,
                );
              },
              child: Text('Register'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Already have an account? Login here'),
            ),
          ],
        ),
      ),
    );
  }
}

