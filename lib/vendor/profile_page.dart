import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'vendor_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String userName;

  ProfilePage({Key? key, required this.userName}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userEmail;
  String? userPhone;
  String? storeName;

  // Controllers for the text fields
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController storeController = TextEditingController();

  // Boolean to check if the text fields are editable
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  // Function to fetch data from the API
  Future<void> fetchProfileData() async {
    // Retrieve token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('https://moodpandaa.com/public/api/profile'), // Replace with your backend URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the token to the Authorization header
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userEmail = data['email'];
          userPhone = data['phone'];
          storeName = data['store_name'];

          // Set the values in the text controllers
          emailController.text = userEmail ?? '';
          phoneController.text = userPhone ?? '';
          storeController.text = storeName ?? '';
        });
      } else {
        print('Failed to fetch data');
      }
    } else {
      print('Token not found');
    }
  }

  // Function to update the profile
  Future<void> updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null) {
      final response = await http.put(
        Uri.parse('https://moodpandaa.com/public/api/profile/update'), // Replace with your backend URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': widget.userName, // Assuming userName is the logged-in name
          'email': emailController.text,
          'phone': phoneController.text,
          'store_name': storeController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        // Optionally, fetch the updated profile data again
        fetchProfileData();
      } else {
        print('Failed to update profile');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } else {
      print('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Page')),
      drawer: VendorDrawer(
        onItemSelected: (String value) {
          switch (value) {
            case 'Profile':
              Navigator.pushNamed(context, '/profilePage', arguments: widget.userName);
              break;
            case 'AddVendor':
              Navigator.pushNamed(context, '/addVendorPage', arguments: widget.userName);
              break;
            case 'Dashboard':
              Navigator.pushNamed(context, '/dashboardPage', arguments: widget.userName);
              break;
            case 'Vendor':
              Navigator.pushNamed(context, '/vendorPage', arguments: widget.userName);
              break;
          }
        },
        userName: widget.userName,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('Welcome, ${widget.userName}!')),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              enabled: isEditable, // Allow editing only if isEditable is true
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              enabled: isEditable, // Allow editing only if isEditable is true
            ),
            SizedBox(height: 16),
            TextField(
              controller: storeController,
              decoration: InputDecoration(
                labelText: 'Store',
                border: OutlineInputBorder(),
              ),
              enabled: isEditable, // Allow editing only if isEditable is true
            ),
            SizedBox(height: 16),
            // Update Button
            ElevatedButton(
              onPressed: () {
                if (isEditable) {
                  // If in edit mode, save the changes
                  updateProfile();
                }
                setState(() {
                  // Toggle edit mode
                  isEditable = !isEditable;
                });
              },
              child: Text(isEditable ? 'Save Changes' : 'Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
