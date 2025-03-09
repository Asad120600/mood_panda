import 'package:flutter/material.dart';

class PendingPayment extends StatefulWidget {
  // final String userName;
  const PendingPayment({super.key});
  // PendingPayment({Key? key, required this.userName}) : super(key: key);

  @override
  State<PendingPayment> createState() => _PendingPaymentState();
}

class _PendingPaymentState extends State<PendingPayment> {
  final List<Map<String, String>> allData = List.generate(
    15,
        (index) => {
      'description': 'Product ${index + 1}',
      'category': index % 3 == 0
          ? 'Large'
          : index % 3 == 1
          ? 'Medium'
          : 'Small',
      'city': 'City ${index + 1}',
      'price': '\$${(index + 1) * 100}',
      'date': '2025-01-0${(index % 3) + 1}',
      'image': 'https://via.placeholder.com/100', // Sample image URL
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
            : const Text('Pending Payment'),
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
        color: Colors.deepPurple[50],
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Pending Payment',
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
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PaginatedDataTable(
                      header: Text('Pending Payment'),
                      columns: const [
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('City')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Image')),
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
  final List<Map<String, String>> data;

  _OrderDataSource(this.data);

  @override
  DataRow getRow(int index) {
    final row = data[index];
    return DataRow(
      cells: [
        DataCell(Text(row['description'] ?? '')),
        DataCell(Text(row['category'] ?? '')),
        DataCell(Text(row['city'] ?? '')),
        DataCell(Text(row['price'] ?? '')),
        DataCell(Text(row['date'] ?? '')),
        DataCell(
          Image.network(
            row['image'] ?? '',
            height: 50, // Minimized image height
            width: 50,  // Minimized image width
            fit: BoxFit.cover,
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
