import 'package:flutter/material.dart';

class ProductTable extends StatefulWidget {
  const ProductTable({super.key});

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  final List<Map<String, String>> allData = List.generate(
    15, // Total 15 entries
        (index) => {
      'invoice_number': 'INV00${index + 1}',
      'customer_name': 'Customer ${index + 1}',
      'vendor_name': 'Vendor ${index + 1}',
      'price': '\$${(index + 1) * 100}',
      'date': '2025-01-0${(index % 3) + 1}',
    },
  );

  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    // Filter data based on the selected date
    List<Map<String, String>> filteredData = _selectedDate == null
        ? allData
        : allData
        .where(
          (row) =>
          DateTime.parse(row['date'] ?? '').isAtSameMomentAs(_selectedDate!),
    )
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Change the app bar color
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
            : const Text('Order Rejected'),
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
      body: Container(
        color: Colors.deepPurple[50], // Background color matching app color
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading above the table
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Rejected Order Detail',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),
            ),
            // Date Picker for filtering data
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    'Select Date: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                          : '${_selectedDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                ],
              ),
            ),
            // Paginated DataTable
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PaginatedDataTable(
                      header: Text('Order Confirmations'),
                      columns: const [
                        DataColumn(label: Text('Invoice Number')),
                        DataColumn(label: Text('Customer Name')),
                        DataColumn(label: Text('Vendor Name')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Date')),
                      ],
                      source: _OrderDataSource(filteredData),
                      rowsPerPage: 5, // 5 rows per page
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
  final List<Map<String, String>> data;

  _OrderDataSource(this.data);

  @override
  DataRow getRow(int index) {
    final row = data[index];
    return DataRow(
      cells: [
        DataCell(Text(row['invoice_number'] ?? '')),
        DataCell(Text(row['customer_name'] ?? '')),
        DataCell(Text(row['vendor_name'] ?? '')),
        DataCell(Text(row['price'] ?? '')),
        DataCell(Text(row['date'] ?? '')),
      ],
    );
  }

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  // Add this getter to indicate whether the row count is approximate
  @override
  bool get isRowCountApproximate => false;
}

