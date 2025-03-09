import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VendorAnnouncements extends StatefulWidget {
  const VendorAnnouncements({super.key});

  @override
  State<VendorAnnouncements> createState() => _VendorAnnouncementsState();
}

class _VendorAnnouncementsState extends State<VendorAnnouncements> {
  List<dynamic> announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchAnnouncements() async {
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
        Uri.parse('https://moodpandaa.com/public/api/vendor/annoucement'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log(response.body);
        setState(() {
          announcements = data[0];
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
        title: Text('Announcements'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : announcements.isEmpty
              ? Center(
                  child: Text(
                    'No announcements available.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final announcement = announcements[index];
                      return Card(
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                announcement['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                announcement['des'],
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Posted: ${announcement['created_at'].split('T')[0]}',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
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
