import 'package:flutter/material.dart';
import 'package:multi_vendor_app/user/foodies_page.dart';
import 'package:multi_vendor_app/user/userprofile.dart';
import 'package:multi_vendor_app/vendor/profile_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Most Weekly Order')),
      body: Center(child: Text('Most Weekly Order')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add FAB action here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('FAB Clicked!')),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              // Most Order Section
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomePage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home, size: 18, color: Colors.blueAccent),
                      SizedBox(width: 5),
                      Text(
                        'Most Order',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Profile Section
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                            userName:AutofillHints.username,
                          )),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_2_rounded, size: 18, color: Colors.blueAccent),
                      SizedBox(width: 5),
                      Text(
                        'Profile',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Foodies Section
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FoodiesPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant, size: 18, color: Colors.blueAccent),
                      SizedBox(width: 5),
                      Text(
                        'Foodies',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
