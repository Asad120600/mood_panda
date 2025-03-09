import 'package:flutter/material.dart';
import 'package:multi_vendor_app/contact_us.dart';
import 'package:multi_vendor_app/local_storage.dart';
import 'package:multi_vendor_app/privacy_policy.dart';
import 'package:multi_vendor_app/vendor/pending_orders.dart';
import 'package:multi_vendor_app/vendor/vendor_announcements.dart';
import 'package:multi_vendor_app/vendor/vendor_package.dart';
import 'package:multi_vendor_app/vendor/vendor_products.dart';
import 'package:multi_vendor_app/vendor/vendor_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'confirmproduct.dart';
import 'rejectproduct.dart';
import 'recivingpayment.dart';
import 'pendingpayment.dart';

class VendorDrawer extends StatefulWidget {
  final Function(String) onItemSelected;
  final String userName;

  const VendorDrawer({
    Key? key,
    required this.onItemSelected,
    required this.userName,
  }) : super(key: key);

  @override
  _VendorDrawerState createState() => _VendorDrawerState();
}

class _VendorDrawerState extends State<VendorDrawer> {
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
        (route) => false, // Clear all previous routes
      );
    }
  }

  Future<int?> getVendorId() async {
    // Using LocalStorage to get the vendor_id
    return await LocalStorage.getVendorId();
  }

  // Helper method to navigate to a page if vendorId is available
  Future<void> _navigateToPage(BuildContext context, Widget page) async {
    int? vendorId = await getVendorId();
    if (vendorId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vendor ID not found')),
      );
    }
  }

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
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              widget.onItemSelected('Dashboard');
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
            leading: Icon(Icons.add),
            title: Text('Add Vendor'),
            onTap: () {
              Navigator.pop(context);
              widget.onItemSelected('AddVendor');
            },
          ),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text('Product Details'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VendorProducts(
                          userName: LocalStorage.getUserName().toString())));
            },
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Confirm Order Product'),
            onTap: () {
              _navigateToPage(context, ConfirmProduct());
            },
          ),
          ListTile(
            leading: Icon(Icons.pending_actions_rounded),
            title: Text('Pending Orders '),
            onTap: () {
              _navigateToPage(context, PendingOrdersVendor());
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Rejected Order Product'),
            onTap: () {
              _navigateToPage(context, RejectProduct());
            },
          ),
          ListTile(
            leading: Icon(Icons.graphic_eq),
            title: Text('Stats'),
            onTap: () {
              _navigateToPage(context, VendorStats());
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement_outlined),
            title: Text('Announcemnets'),
            onTap: () {
              _navigateToPage(context, VendorAnnouncements());
            },
          ),
          ListTile(
            leading: Icon(Icons.offline_share_rounded),
            title: Text('Packages'),
            onTap: () {
              _navigateToPage(context, VendorPackagesPage());
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
            leading: Icon(Icons.payment),
            title: Text('Receiving Payment'),
            onTap: () {
              _navigateToPage(context, RecivingPayment());
            },
          ),
          ListTile(
            leading: Icon(Icons.pending_actions),
            title: Text('Pending Payment'),
            onTap: () {
              _navigateToPage(context, PendingPayment());
            },
          ),
           ListTile(
            leading: Icon(Icons.privacy_tip_sharp),
            title: Text('Privacy Policy'),
            onTap: () {
              // Navigator.pop(context);
              // widget.onItemSelected('OrderConfirm');
               _navigateToPage(context,  PrivacyPolicyScreen());
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
