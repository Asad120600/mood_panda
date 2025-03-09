import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:multi_vendor_app/local_storage.dart';

class VendorProducts extends StatefulWidget {
  final String userName;

  const VendorProducts({super.key, required this.userName});

  @override
  State<VendorProducts> createState() => _VendorProductsState();
}

class _VendorProductsState extends State<VendorProducts> {
  List<Map<String, dynamic>> productData = [];
  bool isLoading = true;
  String? errorMessage;
  int? vendorId;

  @override
  void initState() {
    super.initState();
    _getVendorId(); // Call the _getVendorId method during initialization
  }

  // Fetch the vendorId from LocalStorage
  Future<void> _getVendorId() async {
    vendorId =
        await LocalStorage.getVendorId(); // Retrieve vendorId from LocalStorage
    if (vendorId != null) {
      fetchProducts(); // Call fetchProducts if vendorId is available
    } else {
      setState(() {
        errorMessage = 'Vendor ID not found';
        isLoading = false;
      });
    }
  }

  Future<void> fetchProducts() async {
    final url = 'https://moodpandaa.com/public/api/vendors/$vendorId/products';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          productData = List<Map<String, dynamic>>.from(data['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Vendor Products'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : Container(
                  color: Colors.deepPurple[50],
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Product Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[800],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PaginatedDataTable(
                                header: const Text('Product List'),
                                columns: const [
                                  DataColumn(label: Text('ID')),
                                  DataColumn(label: Text('Store Name')),
                                  DataColumn(label: Text('City')),
                                  DataColumn(label: Text('Price')),
                                  DataColumn(label: Text('Category')),
                                  DataColumn(label: Text('Image')),
                                ],
                                source: _ProductDataSource(productData),
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

// class _ProductDataSource extends DataTableSource {
//   final List<Map<String, dynamic>> data;

//   _ProductDataSource(this.data);

//   @override
//   DataRow getRow(int index) {
//     final row = data[index];
//     return DataRow(
//       cells: [
//         DataCell(Text(row['id'].toString())),
//         DataCell(Text(row['store_name'] ?? 'N/A')),
//         DataCell(Text(row['city'] ?? 'N/A')),
//         DataCell(Text(row['price'].toString())),
//         DataCell(Text(row['category_name'] ?? 'N/A')),
//         DataCell(
//           Image.network(
//             'https://moodpandaa.com/public/${row['image_path']}',
//             height: 50,
//             width: 50,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;

//   @override
//   bool get isRowCountApproximate => false;
// }



class _ProductDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;

  _ProductDataSource(this.data);

  @override
  DataRow getRow(int index) {
    final row = data[index];
    return DataRow(
      cells: [
        DataCell(Text(row['id'].toString())),
        DataCell(Text(row['store_name'] ?? 'N/A')),
        DataCell(Text(row['city'] ?? 'N/A')),
        DataCell(Text(row['price'].toString())),
        DataCell(Text(row['category_name'] ?? 'N/A')),
        DataCell(
          CircleAvatar(
            radius: 25, // Adjust size of the circle avatar
            backgroundImage: NetworkImage(
              'https://moodpandaa.com/public/${row['image_path']}',
            ),
            backgroundColor: Colors.transparent, // To ensure no background color is used
          ),
        ),
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
