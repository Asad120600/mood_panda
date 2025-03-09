import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ConfirmProduct extends StatefulWidget {
  const ConfirmProduct({super.key});

  @override
  State<ConfirmProduct> createState() => _ConfirmProductState();
}

class _ConfirmProductState extends State<ConfirmProduct> {
  List<Map<String, dynamic>> allData = [];
  bool isLoading = true;
  String errorMessage = "";

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
       String? token = await getToken(); // Retrieve token

      if (token == null || token.isEmpty) {
        print('Error: No token found. User must log in.');
        return;
      }

      final response = await http.get(
        Uri.parse('https://moodpandaa.com/public/api/vendor/accept-orders'),
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
            allData = List<Map<String, dynamic>>.from(responseData['data']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "No data found!";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to load data!";
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

  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredData = _selectedDate == null
        ? allData
        : allData
            .where(
              (row) => DateTime.parse(row['created_at'])
                  .isAtSameMomentAs(_selectedDate!),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                autofocus: true,
              )
            : const Text('Confirm Product'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Container(
                  color: Colors.deepPurple[50],
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Confirm Product Detail',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[800],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Select Date: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null && picked != _selectedDate) {
                                  setState(() {
                                    _selectedDate = picked;
                                  });
                                }
                              },
                              child: Text(
                                _selectedDate == null
                                    ? 'Pick a Date'
                                    : '${_selectedDate!.toLocal()}'
                                        .split(' ')[0],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PaginatedDataTable(
                                header: Text('Confirmed Orders'),
                                columns: const [
                                  DataColumn(label: Text('Order ID')),
                                  DataColumn(label: Text('User Name')),
                                  DataColumn(label: Text('Vendor Name')),
                                  DataColumn(label: Text('Menu Name')),
                                  DataColumn(label: Text('Quantity')),
                                  DataColumn(label: Text('Total Price')),
                                  DataColumn(label: Text('Payment Method')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('Date')),
                                ],
                                source: _OrderDataSource(filteredData),
                                rowsPerPage: 5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _OrderDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;

  _OrderDataSource(this.data);

  @override
  DataRow getRow(int index) {
    final row = data[index];
    return DataRow(
      cells: [
        DataCell(Text(row['order_id'].toString())),
        DataCell(Text(row['user_name'] ?? '')),
        DataCell(Text(row['vendor_name'] ?? '')),
        DataCell(Text(row['menu_name'] ?? '')),
        DataCell(Text(row['quantity'].toString())),
        DataCell(Text(row['total_price'].toString())),
        DataCell(Text(row['payment_method'] ?? '')),
        DataCell(Text(row['status'] ?? '')),
        DataCell(Text(row['created_at'].split('T')[0])),
      ],
    );
  }

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  @override
  bool get isRowCountApproximate => false;
}
