// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:multi_vendor_app/user/cartpage.dart';
// import 'package:multi_vendor_app/user/grocerydetailspage.dart';

// class GroceryPage extends StatefulWidget {
//   @override
//   _GroceryPageState createState() => _GroceryPageState();
// }

// class _GroceryPageState extends State<GroceryPage> {
//   List<dynamic> vendors = [];
//   List<dynamic> filteredVendors = [];
//   List<dynamic> sharedCart = []; // Shared cart across all stores
//   int _selectedIndex = 0; // Current index of the selected tab
//   TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchVendors();
//   }

//   Future<void> fetchVendors() async {
//     final response = await http
//         .get(Uri.parse('https://moodpandaa.com/public/api/platforms/grosory'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         vendors = data['grocory'];
//         filteredVendors = vendors; // Initially show all vendors
//       });
//     } else {
//       throw Exception('Failed to load vendors');
//     }
//   }

//   // Search function
//   void _filterVendors(String query) {
//     final filteredList = vendors.where((vendor) {
//       final storeName = vendor['store_name'].toLowerCase();
//       final searchQuery = query.toLowerCase();
//       return storeName.contains(searchQuery);
//     }).toList();

//     setState(() {
//       filteredVendors = filteredList;
//     });
//   }

//   // Pages for the BottomNavigationBar
//   Widget _buildPage(int index) {
//     if (index == 0) {
//       // Home Page
//       return ListView.builder(
//         padding: EdgeInsets.all(10),
//         itemCount: vendors.length,
//         itemBuilder: (context, index) {
//           return Container(
//             margin: EdgeInsets.only(bottom: 10),
//             decoration: BoxDecoration(
//               color: Colors.grey.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 8,
//                   spreadRadius: 2,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ListTile(
//               contentPadding: EdgeInsets.all(16),
//               title: Text(
//                 vendors[index]['store_name'],
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.teal.shade900,
//                 ),
//               ),
//               trailing: Icon(Icons.store, color: Colors.teal),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => GroceryDetailsPage(
//                       userId: vendors[index]['id'],
//                       storeName: vendors[index]['store_name'],
//                       sharedCart: sharedCart,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       );
//     } else if (index == 1) {
//       // Search Page
//       return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _searchController,
//               onChanged: _filterVendors,
//               decoration: InputDecoration(
//                 hintText: 'Search by store name...',
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 prefixIcon: Icon(Icons.search, color: Colors.teal),
//               ),
//             ),
//             Expanded(
//               child: filteredVendors.isEmpty
//                   ? Center(child: Text('No results found'))
//                   : ListView.builder(
//                       itemCount: filteredVendors.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.2),
//                                 blurRadius: 10,
//                                 spreadRadius: 2,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: ListTile(
//                             contentPadding: EdgeInsets.all(16),
//                             title: Text(
//                               filteredVendors[index]['store_name'],
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.teal.shade900,
//                               ),
//                             ),
//                             leading: CircleAvatar(
//                               backgroundColor: Colors.grey.withOpacity(0.1),
//                               child: Icon(
//                                 Icons.store,
//                                 color: Colors.teal,
//                               ),
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => GroceryDetailsPage(
//                                     userId: filteredVendors[index]['id'],
//                                     storeName: filteredVendors[index]['store_name'],
//                                     sharedCart: sharedCart,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Cart Page
//       return CartPage(cartItems: sharedCart);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Grocery'),
//         backgroundColor: Colors.grey.withOpacity(0.2), // Light teal shade for AppBar
//       ),
//       body: _buildPage(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor_app/user/cartpage.dart';
import 'package:multi_vendor_app/user/grocerydetailspage.dart';

class GroceryPage extends StatefulWidget {
  @override
  _GroceryPageState createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage> {
  List<dynamic> vendors = [];
  List<dynamic> filteredVendors = [];
  List<dynamic> sharedCart = [];
  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVendors();
  }

  Future<void> fetchVendors() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
        Uri.parse('https://moodpandaa.com/public/api/platforms/grosory'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        vendors = data['grocory'];
        filteredVendors = vendors;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load vendors');
    }
  }

  void _filterVendors(String query) {
    final filteredList = vendors.where((vendor) {
      final storeName = vendor['store_name'].toLowerCase();
      final searchQuery = query.toLowerCase();
      return storeName.contains(searchQuery);
    }).toList();

    setState(() {
      filteredVendors = filteredList;
    });
  }

  Widget _buildPage(int index) {
    if (index == 0) {
      if (isLoading) {
        return Center(child: CircularProgressIndicator(color: Colors.teal));
      }
      return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                vendors[index]['store_name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade900,
                ),
              ),
              trailing: Icon(Icons.store, color: Colors.teal),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroceryDetailsPage(
                      userId: vendors[index]['id'],
                      storeName: vendors[index]['store_name'],
                      sharedCart: sharedCart,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    } else if (index == 1) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _filterVendors,
              decoration: InputDecoration(
                hintText: 'Search by store name...',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.teal),
              ),
            ),
            Expanded(
              child: filteredVendors.isEmpty
                  ? Center(child: Text('No results found'))
                  : ListView.builder(
                      itemCount: filteredVendors.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              filteredVendors[index]['store_name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade900,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              child: Icon(
                                Icons.store,
                                color: Colors.teal,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroceryDetailsPage(
                                    userId: filteredVendors[index]['id'],
                                    storeName:
                                        filteredVendors[index]['store_name'],
                                    sharedCart: sharedCart,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    } else {
      return CartPage(cartItems: sharedCart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery'),
        backgroundColor: Colors.grey.withOpacity(0.2),
      ),
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}
