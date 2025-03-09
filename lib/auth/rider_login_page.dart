import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor_app/auth/rider_signup_page.dart';
import 'package:multi_vendor_app/local_storage.dart';
import 'package:multi_vendor_app/rider/rider_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiderLoginPage extends StatefulWidget {
  @override
  _RiderLoginPageState createState() => _RiderLoginPageState();
}

class _RiderLoginPageState extends State<RiderLoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _iconController;

  String authtoken = "";

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
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RiderPage(
                  userName: userName,
                )),
      );
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
              child: Icon(Icons.pets, size: 50, color: Colors.black),
            ),
          );
        },
      );

      final response = await http.post(
        Uri.parse('https://moodpandaa.com/public/api/rider/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);
          await prefs.setString('user_id', data['user_id'].toString());
          await prefs.setString('role', data['role']);
          await prefs.setString('user_name', data['name']);
          await LocalStorage.saveRiderId((data['user_id'].toString()));

          authtoken = data['token'];
          print('Saved Token: $authtoken');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3),
              content: Row(
                children: [
                  RotationTransition(
                    turns: _iconController,
                    child: Icon(Icons.pets, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Text('Login successful! Redirecting...'),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );

          await Future.delayed(Duration(seconds: 3));
          _navigateBasedOnRole(data['role'], data['name']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password.')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

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
                          SizedBox(width: 8),
                          Text(
                            'Mood Panda',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: login,
                    child: Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RiderSignupPage()),
                      );
                    },
                    child: Text('Don\'t have an account? Sign up as a Rider'),
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
