import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor_app/rider/Rider_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiderPage extends StatefulWidget {
  final String userName;

  RiderPage({Key? key, required this.userName}) : super(key: key);

  @override
  _RiderPageState createState() => _RiderPageState();
}

class _RiderPageState extends State<RiderPage> {
  List<dynamic> allOrders = [];
  List<dynamic> todayOrders = [];
  List<dynamic> historyOrders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchOrders() async {
    try {
      String? token = await getToken();
      if (token == null || token.isEmpty) {
        print('Error: No token found. User must log in.');
        return;
      }

      final response = await http.get(
        Uri.parse('https://moodpandaa.com/public/api/rider-getorder'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> orders = json.decode(response.body);
        DateTime now = DateTime.now();
        setState(() {
          allOrders = orders;
          todayOrders = orders
              .where(
                  (order) => DateTime.parse(order['created_at']).day == now.day)
              .toList();
          historyOrders = orders
              .where(
                  (order) => DateTime.parse(order['created_at']).day != now.day)
              .toList();
        });
      } else {
        print('Error: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      String? token = await getToken();
      if (token == null || token.isEmpty) {
        print('Error: No token found. User must log in.');
        return;
      }

      final response = await http.post(
        Uri.parse(
            'https://moodpandaa.com/public/api/update-rider-notification/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        print('Order #$orderId updated to $status');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$status successfully for Order ID: $orderId'),
      ));
        fetchOrders();
      } else {
        print(
            'Error updating order: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rider Dashboard'),
          bottom: TabBar(
            tabs: [
              Tab(text: "Today's Orders"),
              Tab(text: "Order History"),
            ],
          ),
        ),
        drawer: CustomDrawer(
          onItemSelected: (String value) {},
          userName: widget.userName,
        ),
        body: TabBarView(
          children: [
            OrderList(
                orders: todayOrders, updateOrderStatus: updateOrderStatus),
            OrderList(orders: historyOrders),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final List<dynamic> orders;
  final Function(int, String)? updateOrderStatus;

  const OrderList({Key? key, required this.orders, this.updateOrderStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        bool isAccepted = order['status'] == 'Accepted';
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text('Order #${order['id']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vendor: ${order['vendor']}'),
                Text('Order User: ${order['order_user']}'),
                Text('Status: ${order['status']}'),
                Text('Created At: ${order['created_at']}'),
                Text('Updated At: ${order['updated_at']}'),
                if (updateOrderStatus !=
                    null) // Show buttons only in today's orders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: isAccepted
                            ? null
                            : () => updateOrderStatus!(order['id'], 'Accepted'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: Text('Accept'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: isAccepted
                            ? null
                            : () => updateOrderStatus!(order['id'], 'Rejected'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text('Reject'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
