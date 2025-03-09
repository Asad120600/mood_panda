import 'package:flutter/material.dart';
import 'groceryorderprogresspage.dart'; // Import the new page

class GroceryCartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  GroceryCartPage({required this.cartItems});

  @override
  _GroceryCartPageState createState() => _GroceryCartPageState();
}

class _GroceryCartPageState extends State<GroceryCartPage> {
  String selectedPaymentMethod = 'Cash';
  double deliveryCharge = 50.0;

  @override
  Widget build(BuildContext context) {
    double totalPayment = widget.cartItems.fold(0.0, (sum, item) {
      double price = item['price'] != null ? double.tryParse(item['price'].toString()) ?? 0.0 : 0.0;
      return sum + price;
    });

    totalPayment += deliveryCharge;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Cart items list
          Expanded(
            child: widget.cartItems.isEmpty
                ? Center(child: Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)))
                : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.cartItems[index]['store_name'] ?? 'Store Name',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Category: ${widget.cartItems[index]['category_name']}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                              Text(
                                'City: ${widget.cartItems[index]['city']}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Price: \$${widget.cartItems[index]['price']}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Footer section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: selectedPaymentMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPaymentMethod = newValue!;
                    });
                  },
                  items: <String>['Cash', 'Credit']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12),
                Text(
                  'Delivery Charge: \$${deliveryCharge.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Payment:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalPayment.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroceryOrderProcessingPage(
                            totalPayment: totalPayment,
                            paymentMethod: selectedPaymentMethod,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Confirm Order',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
