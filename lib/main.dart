import 'dart:math';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/auth/login_user.dart';
import 'package:multi_vendor_app/auth/rider_login_page.dart';
import 'package:multi_vendor_app/auth/vendor_login_page.dart';
import 'package:multi_vendor_app/auth/sign_up.dart';
import 'package:multi_vendor_app/frontendpage.dart';
import 'package:multi_vendor_app/local_storage.dart';
import 'package:multi_vendor_app/vendor/dashboard_page.dart';
import 'package:multi_vendor_app/vendor/profile_page.dart';
import 'package:multi_vendor_app/vendor/add_vendor.dart';
import 'package:multi_vendor_app/admin/admin.dart';
import 'package:multi_vendor_app/rider/rider_dashboard.dart';
import 'package:multi_vendor_app/user/user_page.dart';
import 'package:multi_vendor_app/user/userprofile.dart';
import 'package:multi_vendor_app/rider/RiderProfile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Panda',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboardPage') {
          final userName = settings.arguments as String? ?? 'Guest';
          return MaterialPageRoute(
            builder: (context) => DashboardPage(
              userName: userName,
              authorizationToken: LocalStorage.getAuthToken().toString(),
              vendorId: LocalStorage.getVendorId().toString(),
            ), // Pass userName and vendorId
          );
        } else if (settings.name == '/profilePage') {
          final userName = settings.arguments as String? ?? 'Guest';
          return MaterialPageRoute(
            builder: (context) => ProfilePage(userName: userName),
          );
        } else if (settings.name == '/vendorPage') {
          final arguments = settings.arguments;
          String userName = 'Guest';
          int vendorId = 0;

          if (arguments is Map<String, dynamic>) {
            userName = arguments['userName'] as String? ?? 'Guest';
            vendorId = arguments['vendorId'] as int? ?? 0;
          }

          return MaterialPageRoute(
            builder: (context) =>
               DashboardPage(userName: userName,authorizationToken: LocalStorage.getVendorAuthToken().toString(), vendorId: LocalStorage.getVendorId().toString(),), // Pass vendorId as int
          );
        } else if (settings.name == '/addVendorPage') {
          final userName = settings.arguments as String? ?? 'Ammar';
          return MaterialPageRoute(
            builder: (context) => AddVendorPage(userName: userName),
          );
        } else if (settings.name == '/adminPage') {
          return MaterialPageRoute(
            builder: (context) => AdminPage(),
          );
        } else if (settings.name == '/riderPage') {
          final userName = settings.arguments as String? ?? 'User';
          return MaterialPageRoute(
            builder: (context) => RiderPage(userName: userName),
          );
        } else if (settings.name == '/userPage') {
          final userName = settings.arguments as String? ?? 'User';
          return MaterialPageRoute(
            builder: (context) => UserPage(userName: userName),
          );
        } else if (settings.name == '/userprofilePage') {
          final userName = settings.arguments as String? ?? 'User';
          return MaterialPageRoute(
            builder: (context) => UserProfilePage(userName: userName),
          );
        } else if (settings.name == '/riderprofilepage') {
          final userName = settings.arguments as String? ?? 'User';
          return MaterialPageRoute(
            builder: (context) => RiderProfilePage(userName: userName),
          );
        }
        return null;
      },
      routes: {
        '/': (context) => SplashScreen(),
        '/FrontendPage': (context) => const FrontendPage(),
        '/riderlogin': (context) => RiderLoginPage(),
        '/userlogin': (context) => LoginPageUser(),
        '/vendorlogin': (context) => VendorLoginPage(),
        '/signup': (context) => SignupPage(),
        '/loginuser': (context) => LoginPageUser(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Animation duration
      vsync: this, // Provide the ticker provider
    );

    // Start the flipping animation
    _animationController.forward().then((_) {
      // Flip back after the first flip completes
      Future.delayed(const Duration(milliseconds: 500), () {
        _animationController.reverse().then((_) {
          // Navigate to the next screen after the flip-back
          _navigateToNextScreen();
        });
      });
    });
  }

  void _navigateToNextScreen() {
    // Directly navigate to the desired screen (skip login check)
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => const FrontendPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              child: Image.asset('assets/mainicon.png'), // Your image asset
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(
                    _animationController.value * pi, // Flip effect
                  ),
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
