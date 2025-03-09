import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  RegisterPage({
    required this.name,
    required this.email,
    required this.phone,
  });

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: TextEditingController(text: name),
              decoration: InputDecoration(labelText: 'Name'),
              readOnly: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: email),
              decoration: InputDecoration(labelText: 'Email'),
              readOnly: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: phone),
              decoration: InputDecoration(labelText: 'Phone'),
              readOnly: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement account creation logic
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
