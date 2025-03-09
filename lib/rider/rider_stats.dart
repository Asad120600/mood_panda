import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RiderStats extends StatefulWidget {
  const RiderStats({super.key});

  @override
  State<RiderStats> createState() => _RiderStatsState();
}

class _RiderStatsState extends State<RiderStats> {
  Map<String, dynamic>? statistics;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchStatistics() async {
    try {
      String? token = await getToken();

      if (token == null || token.isEmpty) {
        print('Error: No token found. User must log in.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://moodpandaa.com/public/api/rider/orders/statistics'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          statistics = data['data'];
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
        title: Text('Rider Statistics'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : statistics == null
              ? Center(
                  child: Text(
                    'No statistics available.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Statistics',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          _buildStatCard(
                              'Total Orders',
                              statistics!['total_orders'],
                              Colors.lightBlueAccent),
                          _buildStatCard(
                              'Pending Orders',
                              statistics!['pending_orders'],
                              Colors.orangeAccent),
                          _buildStatCard(
                              'Accepted Orders',
                              statistics!['accepted_orders'],
                              Colors.lightGreenAccent),
                          _buildStatCard(
                              'Rejected Orders',
                              statistics!['rejected_orders'],
                              Colors.pinkAccent),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatCard(String title, int value, Color bgColor) {
    return Card(
      color: bgColor.withOpacity(0.3),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              value.toString(),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
