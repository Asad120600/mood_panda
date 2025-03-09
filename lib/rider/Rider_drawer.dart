import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor_app/contact_us.dart';
import 'package:multi_vendor_app/local_storage.dart';
import 'package:multi_vendor_app/privacy_policy.dart';
import 'package:multi_vendor_app/rider/announcement_screen.dart';
import 'package:multi_vendor_app/rider/pending_orders.dart';
import 'package:multi_vendor_app/rider/rider_dashboard.dart';
import 'package:multi_vendor_app/rider/rider_stats.dart';
import 'package:multi_vendor_app/rider/vendors_show_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'confirmorder.dart';
import 'rejectedorder.dart';

class CustomDrawer extends StatefulWidget {
  final Function(String) onItemSelected;
  final String userName;

  const CustomDrawer({
    Key? key,
    required this.onItemSelected,
    required this.userName,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://moodpandaa.com/public/api/logout'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (!mounted) return;
  //
  //     if (response.statusCode == 200) {
  //       // Clear the token after successful logout
  //       await prefs.remove('auth_token');
  //
  //       // Close the drawer, then navigate to the login page
  //       Navigator.of(context).pop(); // Close the drawer first
  //
  //       // Redirect to login page and clear all previous routes
  //       Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         '/loginPage', // Assuming '/' is the route for your LoginPage
  //             (route) => false,
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Logout failed. Please try again.')),
  //       );
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('An error occurred. Please try again.')),
  //       );
  //     }
  //   }
  // }

  Future<void> _navigateToPage(BuildContext context, Widget page) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
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
            leading: Icon(Icons.dashboard),
            title: Text('DashBoard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RiderPage(
                          userName: LocalStorage.getUserName().toString(),
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: Text('Vendors'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VendorsShowScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Rider Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/riderprofilepage', // Ensure this matches the route in main.dart
                // Pass userName as an argument
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Order Confirm'),
            onTap: () {
              // Navigator.pop(context);
              // widget.onItemSelected('OrderConfirm');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderConfirm()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Reject Order'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RejectOrder()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.stars_outlined),
            title: Text("Rider Stats"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RiderStats()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement_sharp),
            title: Text("Announcements"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnnouncementScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_emergency),
            title: Text('Contact Us'),
            onTap: () {
              _navigateToPage(context, ContactUsPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.pending),
            title: Text("Pending Orders"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PendingOrdersScreen()),
              );
            },
          ),
           ListTile(
            leading: Icon(Icons.privacy_tip_sharp),
            title: Text('Privacy Policy'),
            onTap: () {
              // Navigator.pop(context);
              // widget.onItemSelected('OrderConfirm');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  PrivacyPolicyScreen()),
              );
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
