import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_vendor_app/local_storage.dart';
import 'package:http/http.dart ' as http;
import 'package:multi_vendor_app/vendor/order.dart';
import 'package:multi_vendor_app/vendor/order_card.dart';
import 'package:multi_vendor_app/vendor/vendor_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  final String userName;
  final String authorizationToken;
  final String vendorId;

  DashboardPage({
    Key? key,
    required this.userName,
    required this.authorizationToken,
    required this.vendorId,
  }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

// class _DashboardPageState extends State<DashboardPage>
//     with SingleTickerProviderStateMixin {
//   late Future<List<Order>> orders;
//   late TabController _tabController;
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     orders = fetchOrders(); // Fetch orders when the page loads
//   }
//   Future<List<Order>> fetchOrders() async {
//     try {
//       final authToken = await LocalStorage.getAuthToken();
//       if (authToken == null) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Authentication failed. Please log in again.'),
//         ));
//         throw Exception('Authentication failed');
//       }
//       final response = await http.get(
//         Uri.parse(
//             'https://moodpandaa.com/public/api/vendor-notifications?vendor_id=${widget.vendorId}'),
//         headers: {
//           'Authorization': 'Bearer $authToken',
//           'Content-Type': 'application/json',
//         },
//       );
//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body);
//         return data.map((order) => Order.fromJson(order)).toList();
//       } else {
//         throw Exception('Failed to load orders');
//       }
//     } catch (error) {
//       print('Error occurred while fetching orders: $error');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error fetching orders: $error'),
//       ));
//       throw Exception('Failed to fetch orders');
//     }
//   }
//   List<Order> filterOrdersByDate(List<Order> orders, bool isToday) {
//     DateTime today = DateTime.now();
//     return orders.where((order) {
//       DateTime orderDate = DateTime.parse(order.createdAt);
//       return isToday
//           ? orderDate.year == today.year &&
//               orderDate.month == today.month &&
//               orderDate.day == today.day
//           : orderDate.isBefore(today);
//     }).toList();
//   }
//   // Future<void> updateStatus(int orderId, String status) async {
//   //   try {
//   //     // Ensure status is not empty
//   //     if (status.isEmpty) {
//   //       throw Exception('Status cannot be empty');
//   //     }
// //     final authToken = await LocalStorage.getAuthToken();
//   //     if (authToken == null) {
//   //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //         content: Text('Authentication failed. Please log in again.'),
//   //       ));
//   //       return;
//   //     }
//   //     final response = await http.post(
//   //       Uri.parse('https://moodpandaa.com/public/api/update-status/$orderId'),
//   //       headers: {
//   //         'Authorization': 'Bearer $authToken',
//   //         'Content-Type': 'application/json',
//   //         'Accept': 'application/json',
//   //       },
//   //       body: jsonEncode({
//   //         "status": status, // Pass the status directly without the array
//   //       }),
//   //     );
//   //     if (response.statusCode == 200) {
//   //       print(response.body);
//   //       print(response.statusCode);
//   //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //         content: Text('$status successfully for Order ID: $orderId'),
//   //       ));
//   //     } else {
//   //       print('Error response: ${response.statusCode}');
//   //       print('Response body: ${response.body}');
//   //       throw Exception('Failed to update status');
//   //     }
//   //   } catch (error) {
//   //     print('Error occurred: $error');
//   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //       content: Text('Error updating status: $error'),
//   //     ));
//   //   }
//   // }
// Future<void> updateStatus(int orderId, String status) async {
//   try {
//     // Ensure status is not empty
//     if (status.isEmpty) {
//       throw Exception('Status cannot be empty');
//     }
//     final authToken = await LocalStorage.getAuthToken();
//     if (authToken == null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Authentication failed. Please log in again.'),
//       ));
//       return;
//     }
//     final response = await http.post(
//       Uri.parse('https://moodpandaa.com/public/api/update-status/$orderId'),
//       headers: {
//         'Authorization': 'Bearer $authToken',
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//       body: jsonEncode({
//         "status": status, // Pass the status directly without the array
//       }),
//     );
//     if (response.statusCode == 200) {
//       print(response.body);
//       print(response.statusCode);
//       // After status update, disable buttons for this order
//       setState(() {
//         // Find the order and update its status flag
//         final updatedOrder = orders.firstWhere((order) => order.orderId == orderId);
//         updatedOrder.isStatusUpdated = true;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('$status successfully for Order ID: $orderId'),
//       ));
//     } else {
//       print('Error response: ${response.statusCode}');
//       print('Response body: ${response.body}');
//       throw Exception('Failed to update status');
//     }
//   } catch (error) {
//     print('Error occurred: $error');
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Error updating status: $error'),
//     ));
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard Page'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(text: 'Today'),
//             Tab(text: 'History'),
//           ],
//         ),
//       ),
//       drawer: VendorDrawer(
//         onItemSelected: (String value) {
//           switch (value) {
//             case 'Profile':
//               Navigator.pushNamed(context, '/profilePage',
//                   arguments: widget.userName);
//               break;
//             case 'AddVendor':
//               Navigator.pushNamed(context, '/addVendorPage',
//                   arguments: widget.userName);
//               break;
//             case 'Dashboard':
//               Navigator.pushNamed(context, '/dashboardPage',
//                   arguments: widget.userName);
//               break;
//             case 'Vendor':
//               Navigator.pushNamed(context, '/vendorPage',
//                   arguments: widget.userName);
//               break;
//           }
//         },
//         userName: widget.userName,
//       ),
//       body: FutureBuilder<List<Order>>(
//         future: orders,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Failed to load orders'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No orders available'));
//           } else {
//             final allOrders = snapshot.data!;
//             final todayOrders = filterOrdersByDate(allOrders, true);
//             final historyOrders = filterOrdersByDate(allOrders, false);
//             return TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildOrderList(todayOrders, showButtons: true),
//                 _buildOrderList(historyOrders, showButtons: false),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
//   Widget _buildOrderList(List<Order> orders, {required bool showButtons}) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           for (var order in orders)
//             OrderCard(
//               order: order,
//               onUpdateStatus: (id, status) {
//                 if (order.status != 'Accepted') {
//                   updateStatus(id, status);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Status is already accepted.'),
//                   ));
//                 }
//               },
//               showButtons: showButtons,
//             ),
//         ],
//       ),
//     );
//   }
// }

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late Future<List<Order>> orders;
  late TabController _tabController;

  List<Order> _orders = []; // Add this line to track orders locally

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    orders = fetchOrders(); // Fetch orders when the page loads
  }

  List<Order> filterOrdersByDate(List<Order> orders, bool isToday) {
    DateTime today = DateTime.now();
    return orders.where((order) {
      DateTime orderDate = DateTime.parse(order.createdAt);
      return isToday
          ? orderDate.year == today.year &&
              orderDate.month == today.month &&
              orderDate.day == today.day
          : orderDate.isBefore(today);
    }).toList();
  }

Future<List<Order>> fetchOrders() async {
  try {
    final authToken = await LocalStorage.getAuthToken();

    if (authToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Authentication failed. Please log in again.'),
      ));
      throw Exception('Authentication failed');
    }

    final response = await http.get(
      Uri.parse(
          'https://moodpandaa.com/public/api/vendor-notifications?vendor_id=${widget.vendorId}'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      // Load status updates from SharedPreferences and update orders
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Order> orders = data.map((order) {
        Order orderObj = Order.fromJson(order);
        // Check if status is updated and set the flag accordingly
        bool isStatusUpdated = prefs.getBool('isStatusUpdated_${orderObj.orderId}') ?? false;
        orderObj.isStatusUpdated = isStatusUpdated;
        return orderObj;
      }).toList();

      setState(() {
        _orders = orders; // Update the local orders list
      });

      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  } catch (error) {
    print('Error occurred while fetching orders: $error');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error fetching orders: $error'),
    ));
    throw Exception('Failed to fetch orders');
  }
}

Future<void> updateStatus(int orderId, String status) async {
  try {
    // Ensure status is not empty
    if (status.isEmpty) {
      throw Exception('Status cannot be empty');
    }

    final authToken = await LocalStorage.getAuthToken();
    if (authToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Authentication failed. Please log in again.'),
      ));
      return;
    }

    final response = await http.post(
      Uri.parse('https://moodpandaa.com/public/api/update-status/$orderId'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "status": status, // Pass the status directly without the array
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      print(response.statusCode);

      // Save the updated status to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isStatusUpdated_$orderId', true); // Persist the status update

      setState(() {
        // Update the order status locally
        final updatedOrder = _orders.firstWhere((order) => order.orderId == orderId);
        updatedOrder.isStatusUpdated = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$status successfully for Order ID: $orderId'),
      ));
    } else {
      print('Error response: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update status');
    }
  } catch (error) {
    print('Error occurred: $error');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error updating status: $error'),
    ));
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Page'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Today'),
            Tab(text: 'History'),
          ],
        ),
      ),
      drawer: VendorDrawer(
        onItemSelected: (String value) {
          switch (value) {
            case 'Profile':
              Navigator.pushNamed(context, '/profilePage',
                  arguments: widget.userName);
              break;
            case 'AddVendor':
              Navigator.pushNamed(context, '/addVendorPage',
                  arguments: widget.userName);
              break;
            case 'Dashboard':
              Navigator.pushNamed(context, '/dashboardPage',
                  arguments: widget.userName);
              break;
            case 'Vendor':
              Navigator.pushNamed(context, '/vendorPage',
                  arguments: widget.userName);
              break;
          }
        },
        userName: widget.userName,
      ),
      body: FutureBuilder<List<Order>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load orders'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders available'));
          } else {
            final allOrders = snapshot.data!;
            final todayOrders = filterOrdersByDate(allOrders, true);
            final historyOrders = filterOrdersByDate(allOrders, false);

            return TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(todayOrders, showButtons: true),
                _buildOrderList(historyOrders, showButtons: false),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders, {required bool showButtons}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          for (var order in orders)
            OrderCard(
              order: order,
              onUpdateStatus: (id, status) {
                if (order.status != 'Accepted') {
                  updateStatus(id, status);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Status is already accepted.'),
                  ));
                }
              },
              showButtons: showButtons,
            ),
        ],
      ),
    );
  }
}
