import 'package:flutter/material.dart';
import 'package:multi_vendor_app/user/foodies_page.dart';
import 'package:multi_vendor_app/utils/carousel_slider.dart';
import '../user/customdrawer.dart';
import 'restaurant_page.dart';
import 'grocery_page.dart';
// import 'medicine_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class UserPage extends StatelessWidget {
  final String userName;

  UserPage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $userName!',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 4,
      ),
      drawer: UserCustomDrawer(
        onItemSelected: (String value) {
          switch (value) {
            case 'Profile':
              Navigator.pushNamed(context, '/userprofilePage',
                  arguments: userName);
              break;
            case 'User':
              Navigator.pushNamed(context, '/userPage', arguments: userName);
              break;
          }
        },
        userName: userName,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInUp(
                    duration: Duration(milliseconds: 800),
                    child: Text(
                      'Explore Our Services',
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Restaurant Card
                  BounceInLeft(
                    duration: Duration(milliseconds: 800),
                    child: DashboardCard(
                      title: 'Restaurant',
                      icon: Icons.restaurant,
                      color: Colors.redAccent.shade200,
                      width: screenWidth * 0.9,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RestaurantPage()));
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  // Grocery Card
                  BounceInRight(
                    duration: Duration(milliseconds: 900),
                    child: DashboardCard(
                      title: 'Grocery',
                      icon: Icons.shopping_cart,
                      color: Colors.green.shade400,
                      width: screenWidth * 0.9,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GroceryPage()));
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  // // Medicine Card
                  // BounceInLeft(
                  //   duration: Duration(milliseconds: 1000),
                  //   child: DashboardCard(
                  //     title: 'Medicine',
                  //     icon: Icons.medical_services,
                  //     color: Colors.blueAccent.shade200,
                  //     width: screenWidth * 0.9,
                  //     onTap: () {
                  //      Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MedicinePage()));
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: 24),

                  BounceInLeft(
                    duration: Duration(milliseconds: 1000),
                    child: DashboardCard(
                      title: 'Foodies',
                      icon: Icons.video_settings,
                      color: const Color.fromARGB(159, 0, 54, 29),
                      width: screenWidth * 0.9,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FoodiesPage()),
                        );
                      },
                    ),
                  ),

                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      'Mostly Weekly Ordered Products',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 16),
                  CarouselSliderWidget(
                    imagePaths: [
                      'assets/banner.jpeg',
                      'assets/banner2.jpg',
                      'assets/banner5.jpg',
                      'assets/banner3.webp',
                      'assets/banner6.jpeg',
                      'assets/banner4.jpeg',
                    ],
                    height: screenHeight * 0.3,
                    width: screenWidth,
                    autoPlayInterval: const Duration(seconds: 3),
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

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final double width;
  final VoidCallback onTap;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.width,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black45,
        child: Container(
          width: width,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
