import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class VendorStats extends StatefulWidget {
  const VendorStats({super.key});

  @override
  State<VendorStats> createState() => _VendorStatsState();
}

class _VendorStatsState extends State<VendorStats> {
  Map<String, dynamic> statisticsData = {};
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchOrderStatistics();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchOrderStatistics() async {
    try {
      String? token = await getToken(); // Retrieve token

      if (token == null || token.isEmpty) {
        print('Error: No token found. User must log in.');
        return;
      }

      final response = await http.get(
        Uri.parse('https://moodpandaa.com/public/api/vendor/orders/statistics'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        log(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          setState(() {
            statisticsData = responseData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "No statistics data found!";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to load statistics!";
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = "An error occurred: $error";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Vendor Order Statistics'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading
                      Text(
                        'Order Statistics',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Total Orders Card
                      _buildStatisticCard('Total Orders', statisticsData['total_orders']),
                      const SizedBox(height: 20),
                      // Pending Orders Card
                      _buildStatisticCard('Pending Orders', statisticsData['pending_orders']),
                      const SizedBox(height: 20),
                      // Accepted Orders Card
                      _buildStatisticCard('Accepted Orders', statisticsData['accepted_orders']),
                      const SizedBox(height: 20),
                      // Rejected Orders Card
                      _buildStatisticCard('Rejected Orders', statisticsData['rejected_orders']),
                    ],
                  ),
                ),
    );
  }

  // Helper function to build the statistic cards
  Widget _buildStatisticCard(String title, dynamic value) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple[800],
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
