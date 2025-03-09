import 'package:flutter/material.dart';
import 'package:multi_vendor_app/auth/login_user.dart';
import 'package:multi_vendor_app/auth/rider_login_page.dart';
import 'package:multi_vendor_app/auth/vendor_login_page.dart';
import 'package:multi_vendor_app/local_storage.dart';
import 'package:multi_vendor_app/utils/dashboard_card.dart';
import 'package:multi_vendor_app/vendor/dashboard_page.dart';
import 'package:multi_vendor_app/vendor/vendor_crousel.dart'; // Make sure to import your VendorCarousel here

class FrontendPage extends StatefulWidget {
  const FrontendPage({super.key});

  @override
  State<FrontendPage> createState() => _FrontendPageState();
}

class _FrontendPageState extends State<FrontendPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the user is already logged in
  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await LocalStorage.isLoggedIn();

    if (isLoggedIn) {
      String userRole = await LocalStorage.getData('role') ?? '';
      String userName = await LocalStorage.getData('user_name') ?? '';
      _navigateBasedOnRole(userRole, userName);
    }
  }

  // Navigate based on the user role
  void _navigateBasedOnRole(String role, String userName) {
    if (role == 'Admin') {
      Navigator.pushNamed(context, '/adminPage', arguments: userName);
    } else if (role == 'Vendor') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            userName: userName,
            authorizationToken: LocalStorage.getVendorAuthToken().toString(),
            vendorId: LocalStorage.getVendorId().toString(),
          ),
        ),
      );
    } else if (role == 'Rider') {
      Navigator.pushNamed(context, '/riderPage', arguments: userName);
    } else if (role == 'User') {
      Navigator.pushNamed(context, '/userPage', arguments: userName);
    }
  }

  // Navigate to respective login pages
  void _handleLoginTap(String title) {
    if (title == 'Start Shopping') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPageUser()));
    } else if (title == 'Vendor Login') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VendorLoginPage()),
      );
    } else if (title == 'Rider Login') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RiderLoginPage()),
      );
    } else if (title == 'Admin') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPageUser()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Panda'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Wrap the VendorCarousel in a SizedBox to provide a fixed height
                SizedBox(
                  height: screenHeight * 0.40, // Set height for carousel
                  child: VendorCarousel(),
                ),
                const SizedBox(height: 24),
                // Grid for other cards like Login, Admin, etc.
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: cardData.length,
                  itemBuilder: (context, index) {
                    final card = cardData[index];
                    return DashboardCard(
                      title: card['title']!,
                      icon: card['icon']!,
                      color: card['color']!,
                      buttonText: card['buttonText']!,
                      onTap: () => _handleLoginTap(card['title']!),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Card Data for Login, Admin, etc.
final List<Map<String, dynamic>> cardData = [
  {
    'title': 'Start Shopping',
    'icon': Icons.shopping_cart,
    'color': Colors.purple,
    'buttonText': 'Login',
  },
  {
    'title': 'Vendor Login',
    'icon': Icons.store,
    'color': Colors.teal,
    'buttonText': 'Login',
  },
  {
    'title': 'Rider Login',
    'icon': Icons.directions_bike,
    'color': Colors.brown,
    'buttonText': 'Login',
  },
  // {
  //   'title': 'Admin',
  //   'icon': Icons.admin_panel_settings,
  //   'color': const Color.fromARGB(255, 253, 155, 120),
  //   'buttonText': 'Login',
  // },
];
