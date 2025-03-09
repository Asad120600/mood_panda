import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VendorsShowScreen extends StatefulWidget {
  const VendorsShowScreen({super.key});

  @override
  State<VendorsShowScreen> createState() => _VendorsShowScreenState();
}

class _VendorsShowScreenState extends State<VendorsShowScreen> {
  List vendors = [];

  @override
  void initState() {
    super.initState();
    fetchVendors();
  }

  Future<void> fetchVendors() async {
    final response = await http.get(Uri.parse('https://moodpandaa.com/public/api/get/vendors'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        vendors = data['allvendor'];
      });
    } else {
      throw Exception('Failed to load vendors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendors List'),
        backgroundColor: Colors.teal,
      ),
      body: vendors.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: vendors.length,
              itemBuilder: (context, index) {
                final vendor = vendors[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      backgroundImage: vendor['shop_picture'] != null
                          ? NetworkImage('https://moodpandaa.com${vendor['shop_picture']}')
                          : null,
                      child: vendor['shop_picture'] == null
                          ? const Icon(Icons.store, color: Colors.white)
                          : null,
                    ),
                    title: Text(vendor['store_name'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Owner: ${vendor['name']}', style: const TextStyle(fontSize: 14)),
                        Text('Email: ${vendor['email']}', style: const TextStyle(fontSize: 12)),
                        Text('Phone: ${vendor['phone']}', style: const TextStyle(fontSize: 12)),
                        Text('City: ${vendor['city'] ?? "N/A"}', style: const TextStyle(fontSize: 12)),
                        Text('Town: ${vendor['town'] ?? "N/A"}', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
