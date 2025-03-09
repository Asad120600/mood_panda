import 'package:flutter/material.dart';

class GroceryOrderProcessingPage extends StatelessWidget {
  final double totalPayment;
  final String paymentMethod;

  GroceryOrderProcessingPage({required this.totalPayment, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Processing', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Order Progress Message
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_top, size: 100, color: Colors.teal),
                  SizedBox(height: 16),
                  Text(
                    'Your order is being processed!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total Payment: \$${totalPayment.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  Text(
                    'Payment Method: $paymentMethod',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
          // Return to Cart Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Return to Cart',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
