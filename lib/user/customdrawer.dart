import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/vendor_login_page.dart';

class UserCustomDrawer extends StatefulWidget {
  final Function(String) onItemSelected;
  final String userName;

  const UserCustomDrawer({
    Key? key,
    required this.onItemSelected,
    required this.userName,
  }) : super(key: key);

  @override
  _UserCustomDrawerState createState() => _UserCustomDrawerState();
}

class _UserCustomDrawerState extends State<UserCustomDrawer> {

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the auth_token and user_id from SharedPreferences
    await prefs.remove('auth_token');
    await prefs.remove('user_id');

    // Navigate to the login page and clear the navigation stack
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/FrontendPage', // Adjust this route name if necessary
            (route) => true, // Clear all previous routes
      );
    }
  }




  // Future<void> logout() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('auth_token');
  //   print("hit api${token}");
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://moodpandaa.com/public/api/logout'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //     if (!mounted) return;
  //
  //     if (response.statusCode == 210) {
  //       print("status code${response.statusCode}");
  //       // Clear the token after successful logout
  //       await prefs.remove('auth_token');
  //       await prefs.remove('user_id');
  //
  //       // Close the drawer first, if it's open
  //       // Navigator.of(context).pop();
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => LoginPage()),
  //       );
  //       // After the drawer is closed, navigate back to login page and clear all routes
  //       Future.delayed(Duration(milliseconds: 200), () {
  //         Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           '/loginPage', // Route for LoginPage
  //               (route) => false, // Clear all previous routes
  //         );
  //       });
  //     } else {
  //       print("status code${response.statusCode}");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Logout failed. Please try again.')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred. Please try again.')),
  //     );
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${widget.userName}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('User'),
            onTap: () {
              Navigator.pop(context);
              widget.onItemSelected('User');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              widget.onItemSelected('Profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              logout();
            },
          ),
        ],
      ),
    );
  }
}
