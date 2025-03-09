import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:multi_vendor_app/frontendpage.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String selectedCity = 'Jampur';
  String? selectedTown;
  bool isLoading = false; // Progress indicator state

  final List<String> towns = ['Traffic Chowk', 'Model Bazaar'];

  // Helper method to check if all fields are filled
  bool validateFields() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedCity.isEmpty ||
        selectedTown == null ||
        phoneController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> signup() async {
    if (!validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all the fields.")),
      );
      return;
    }

    setState(() {
      isLoading = true; // Start loading
    });

    final url = Uri.parse('https://moodpandaa.com/public/api/user/register');
    final Map<String, dynamic> body = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "role": "User",
      "phone": phoneController.text,
      "date": DateTime.now().toIso8601String(),
      "city": selectedCity,
      "town": selectedTown,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup Successful")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FrontendPage()),
        );
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup Failed: ${responseData['message']}")),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }

    setState(() {
      isLoading = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                  SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                      border: OutlineInputBorder(),
                      helperText:
                          "We'll never share your email with anyone else.",
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
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCity,
                    decoration: InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'Jampur',
                        child: Text('Jampur'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value!;
                        selectedTown = null; // Reset town selection
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedTown,
                    decoration: InputDecoration(
                      labelText: 'Town',
                      border: OutlineInputBorder(),
                    ),
                    items: towns.map((town) {
                      return DropdownMenuItem(
                        value: town,
                        child: Text(town),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTown = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Cell Phone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        isLoading ? null : signup, // Disable when loading
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white) // Show progress indicator
                        : Text('Submit Form'),
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
