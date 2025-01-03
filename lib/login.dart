import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_system/home.dart';
import 'dart:convert';
import 'package:restaurant_system/register.dart';
import 'userinfo.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context ,String email, String password) async {
    const url = 'http://10.0.2.2/restoSys/getuser.php';
    //const url = 'http://ExtraSnack.free.nf/getuser.php';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = jsonDecode(response.body);
    if (responseData['success']) {
      userID = int.parse(responseData['id']);
      username = responseData['name'];
      final String role = responseData['role'];

      if(role == 'user'){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }else if(role == 'admin'){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => adminPage()),
        );
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Login', style: TextStyle(color: Colors.yellow),),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                loginUser(
                  context,
                  emailController.text,
                  passwordController.text,
                );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Don’t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}
