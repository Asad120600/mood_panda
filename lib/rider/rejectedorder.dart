import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class RejectOrder extends StatefulWidget {
  const RejectOrder({super.key});

  @override
  State<RejectOrder> createState() => _RejectOrderState();
}

class _RejectOrderState extends State<RejectOrder> {
  List<dynamic> rejectedOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRejectedOrders();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchRejectedOrders() async {
    try {
      String? token = await getToken(); // Retrieve token

      if (token == null || token.isEmpty) {
        print('Error: No token found. User must log in.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://moodpandaa.com/public/api/rider/reject-orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log(response.body);
        setState(() {
          rejectedOrders = data['data'];
          isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}, Response: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Request failed: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rejected Orders'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple[50],
        padding: EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : rejectedOrders.isEmpty
                ? Center(
                    child: Text(
                      'No rejected orders found.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: rejectedOrders.length,
                    itemBuilder: (context, index) {
                      final order = rejectedOrders[index];
                      return Card(
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
