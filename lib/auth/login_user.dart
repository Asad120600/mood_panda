import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageUser extends StatefulWidget {
  @override
  _LoginPageUserState createState() => _LoginPageUserState();
}

class _LoginPageUserState extends State<LoginPageUser>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');

    if (authToken != null) {
      String userRole = prefs.getString('role') ?? '';
      String userName = prefs.getString('user_name') ?? '';
      _navigateBasedOnRole(userRole, userName);
    }
  }

  void _navigateBasedOnRole(String role, String userName) {
    if (role == 'Admin') {
      Navigator.pushNamed(context, '/adminPage', arguments: userName);
    
    } else if (role == 'Rider') {
      Navigator.pushNamed(context, '/riderPage', arguments: userName);
    } else if (role == 'User') {
      Navigator.pushNamed(context, '/userPage', arguments: userName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unknown role: $role')),
      );
    }
  }

  Future<void> login() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: RotationTransition(
              turns: _iconController,
              child: const Icon(Icons.pets, size: 50, color: Colors.black),
            ),
          );
        },
      );

      final response = await http.post(
        Uri.parse('https://moodpandaa.com/public/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      Navigator.of(context).pop(); // Close spinner dialog

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);
          await prefs.setString('user_id', data['user_id'].toString());
          await prefs.setString('role', data['role']);
          await prefs.setString('user_name', data['name']);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 3),
              content: Row(
                children: [
                  RotationTransition(
                    turns: _iconController,
                    child: const Icon(Icons.pets, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Text('Login successful! Redirecting...'),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );

          await Future.delayed(const Duration(seconds: 3));
          _navigateBasedOnRole(data['role'], data['name']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password.')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close spinner dialog
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  // void _launchGoogleSignIn() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => WebViewSignIn(
  //               apiUrl: 'https://moodpandaa.com/public/api/auth/google',
  //             )),
  //   );
  // }

  @override
  void dispose() {
    _iconController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/mainicon.png',
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Mood Panda',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: login,
                    child: const Text('Login'),
                  ),
                  // SizedBox(height: 10),
                  // SignInButton(
                  //   Buttons.google,
                  //   text: "Sign up with Google",
                  //   onPressed: _launchGoogleSignIn,
                  // ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'New to Mood Panda? Sign up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
