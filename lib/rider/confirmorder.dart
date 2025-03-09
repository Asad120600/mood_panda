import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor_app/auth/rider_signup_page.dart';
import 'package:multi_vendor_app/local_storage.dart';
import 'package:multi_vendor_app/rider/rider_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderConfirm extends StatefulWidget {
  const OrderConfirm({super.key});

  @override
  State<OrderConfirm> createState() => _OrderConfirmState();
}

class _OrderConfirmState extends State<OrderConfirm> {
  List<dynamic> acceptedOrders = [];

  @override
  void initState() {
    super.initState();
    fetchAcceptedOrders();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchAcceptedOrders() async {
    try {
      String? token = await getToken(); // Retrieve token

      if (token == null || token.isEmpty) {
        print('Error: No token found. User must log in.');
        return;
      }

      final response = await http.get(
        Uri.parse('https://moodpandaa.com/public/api/rider/accept-orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          acceptedOrders = data['data'];
        });
      } else {
        print('Error: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Orders'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple[50],
        padding: EdgeInsets.all(8.0),
        child: acceptedOrders.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: acceptedOrders.length,
                itemBuilder: (context, index) {
                  final order = acceptedOrders[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text('Order ID: ${order['order_id']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer: ${order['user_name']}'),
                          Text('Vendor: ${order['vendor_name']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
