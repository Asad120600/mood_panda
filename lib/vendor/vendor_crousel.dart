import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Vendor {
  final String name;
  final String email;
  final String phone;
  final String storeName;
  final String city;
  final String town;
  final String? shopPicture;

  Vendor({
    required this.name,
    required this.email,
    required this.phone,
    required this.storeName,
    required this.city,
    required this.town,
    this.shopPicture,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      storeName: json['store_name'] ?? '',
      city: json['city'] ?? '',
      town: json['town'] ?? '',
      shopPicture: json['shop_picture'], // Nullable field, no need for ?? ''
    );
  }
}

class VendorCarousel extends StatefulWidget {
  const VendorCarousel({super.key});

  @override
  State<VendorCarousel> createState() => _VendorCarouselState();
}

class _VendorCarouselState extends State<VendorCarousel> {
  late Future<List<Vendor>> vendors;

  Future<List<Vendor>> fetchVendors() async {
    try {
      final response = await http
          .get(Uri.parse('https://moodpandaa.com/public/api/get/vendors'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Vendor> vendorList = [];
        for (var vendorData in data['allvendor']) {
          vendorList.add(Vendor.fromJson(vendorData));
        }
        return vendorList;
      } else {
        print(
            'Error: Failed to load vendors. Status Code: ${response.statusCode}');
        throw Exception('Failed to load vendors');
      }
    } catch (e, stackTrace) {
      print('Exception occurred: $e');
      print('Stack Trace: $stackTrace');
      throw Exception('Failed to load vendors: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    vendors = fetchVendors();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<List<Vendor>>(
        future: vendors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No vendors found.'));
          }

          List<Vendor> vendorList = snapshot.data!;

          return Column(
            children: [
              CarouselSlider(
                items: vendorList.map((vendor) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width:
                            screenWidth, // Ensure all items have the same width
                        child: Card(
                          elevation: 2,
                          margin: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              vendor.shopPicture != null
                                  ? Image.network(
                                      'https://moodpandaa.com/${vendor.shopPicture}',
                                      height: screenHeight * 0.16,
                                    )
                                  : Container(
                                      width: screenWidth,
                                      height: screenHeight * 0.15,
                                      color: Colors.grey,
                                      child: Center(
                                          child: Text("No Image Available")),
                                    ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vendor.storeName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      "Owner: ${vendor.name}",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      "Phone: ${vendor.phone}",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      "City: ${vendor.city.isNotEmpty ? vendor.city : 'Not Available'}",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      "Town: ${vendor.town.isNotEmpty ? vendor.town : 'Not Available'}",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: screenHeight * 0.35,
                  aspectRatio: 10 / 9,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
