import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor_app/auth/vendor_signup_page.dart';
import 'package:multi_vendor_app/local_storage.dart';
import '../vendor/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorLoginPage extends StatefulWidget {
  @override
  _VendorLoginPageState createState() => _VendorLoginPageState();
}

class _VendorLoginPageState extends State<VendorLoginPage>
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
    } else if (['Vendor', 'Medicin', 'Grocery'].contains(role)) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardPage(
                  userName: userName,
                  authorizationToken: LocalStorage.getAuthToken().toString(),
                  vendorId: LocalStorage.getVendorId().toString(),
                )),
      );
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
      // Show loading spinner
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

      // Make the login request
      final response = await http.post(
        Uri.parse('https://moodpandaa.com/public/api/vendor/login'),
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
          // Save user data to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);
          await prefs.setString(
              'user_id', data['user_id'].toString()); // Save user_id (vendorId)
          await prefs.setString('role', data['role']);
          await prefs.setString('user_name', data['name']);

          // Save vendorId using the LocalStorage class
          await LocalStorage.saveVendorId(
              int.parse(data['user_id'].toString())); // Save as integer

          // Show success message
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

          // Navigate based on user role
          _navigateBasedOnRole(data['role'], data['name']);
        } else {
          // Show error message if login failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        // Show error message for invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password.')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close spinner dialog
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
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendorSignupPage()),
                      );
                    },
                    child: Text("Don't have an account? Sign up as a Vendor"),
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
