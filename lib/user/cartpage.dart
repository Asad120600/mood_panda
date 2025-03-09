import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor_app/local_storage.dart';
import 'package:multi_vendor_app/user/user_page.dart';

class CartPage extends StatefulWidget {
  final List<dynamic> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final double deliveryCharge = 50.0;
  String? selectedPaymentMethod;

  double calculateTotalPrice() {
    double total = 0;
    for (var item in widget.cartItems) {
      total += (double.tryParse(item['price'].toString()) ?? 0) *
          (item['quantity'] ?? 1);
    }
    return total;
  }

  // Future<void> placeOrder() async {
  //   const String url = 'https://moodpandaa.com/public/api/place-order';
  //   // Fetch the token
  //   final String? token = await LocalStorage.getAuthToken();
  //   if (token == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:
  //             Text('Authentication token is missing. Please log in again.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }
  //   if (widget.cartItems.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('No items in the cart. Add items to proceed.'),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //     return;
  //   }
  //   List<Map<String, dynamic>> items = [];
  //   // Check if each item has a valid category_id
  //   for (var item in widget.cartItems) {
  //     if (item['category_id'] == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Item missing category ID, cannot place order.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       return; // Stop if any item is missing category_id
  //     }
  //     items.add({
  //       "category_id": item['category_id'],
  //       "plateform_id": item['plateform_id'],
  //       "menu_id": item['menu_id'],
  //       "quantity": item['quantity'],
  //       "price": double.tryParse(item['price'].toString()) ?? 0.0,
  //     });
  //   }
  //   Map<String, dynamic> orderData = {
  //     "total_price": calculateTotalPrice() + deliveryCharge,
  //     "payment_method": selectedPaymentMethod,
  //     "vendor_id": 4,
  //     "store_name": "maskdaks",
  //     "items": items,
  //   };
  //   // Log the order data to the console for debugging
  //   print("Order Data: ${jsonEncode(orderData)}");
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode(orderData),
  //     );
  //     // Check if the response is JSON
  //     if (response.headers['content-type']?.contains('application/json') ==
  //         true) {
  //       final responseData = jsonDecode(response.body);
  //       print('API Response: $responseData');
  //       if (response.statusCode == 201) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Order placed successfully!'),
  //             backgroundColor: Colors.green,
  //           ),
  //         );
  //         // Navigate back to UserPage after success
  //         Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(
  //               builder: (context) =>
  //                   UserPage(userName: LocalStorage.getUserName().toString(),)), // Assuming UserPage is the destination
  //           (route) => false, // Removes all previous routes
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Failed to place order. Please try again.'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     } else {
  //       print('Error: Server returned non-JSON content');
  //       print('Response body: ${response.body}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content:
  //               Text('Failed to place order: Invalid response from server'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error occurred: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('An error occurred. Please try again later.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<void> placeOrder() async {
    const String url = 'https://moodpandaa.com/public/api/place-order';

    // Fetch the token
    final String? token = await LocalStorage.getAuthToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Authentication token is missing. Please log in again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No items in the cart. Add items to proceed.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    List<Map<String, dynamic>> items = [];

    for (var item in widget.cartItems) {
      if (item['category_id'] == null || item['plateform_id'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Item missing category ID or platform ID, cannot place order.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      items.add({
        "category_id": item['category_id'],
        "plateform_id":
            item['plateform_id'], // Ensure the key is correctly spelled
        "menu_id": item['menu_id'],
        "quantity": item['quantity'],
        "price": double.tryParse(item['price'].toString()) ?? 0.0,
      });
    }

    Map<String, dynamic> orderData = {
      "total_price": calculateTotalPrice() + deliveryCharge,
      "payment_method": selectedPaymentMethod,
      "vendor_id": 4,
      "store_name": "maskdaks",
      "items": items,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(orderData),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        print(orderData);

        // Navigate to UserPage with the username
        navigateToUserPage(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to place order. Status Code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Function to navigate to UserPage with the username
  void navigateToUserPage(BuildContext context) async {
    // Await the username retrieval
    String? userName = await LocalStorage.getUserName();

    // Navigate to the UserPage with the username
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => UserPage(userName: userName ?? "Guest"),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double itemTotal = calculateTotalPrice();
    double finalTotal = itemTotal + deliveryCharge;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: widget.cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final product = widget.cartItems[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          child: ListTile(
                            leading: Image.network(
                              'https://moodpandaa.com/public/storage/${product['image_path']}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                            ),
                            title: Text(
                              product['store_name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category: ${product['category_name']}'),
                                Text(
                                  'Price: \$${product['price']}',
                                  style: TextStyle(color: Colors.green),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline,
                                          color: Colors.red),
                                      onPressed: () => setState(() {
                                        product['quantity'] =
                                            (product['quantity'] ?? 1) - 1;
                                        if (product['quantity'] <= 0) {
                                          widget.cartItems.removeAt(index);
                                        }
                                      }),
                                    ),
                                    Text('Qty: ${product['quantity']}'),
                                    IconButton(
                                      icon: Icon(Icons.add_circle_outline,
                                          color: Colors.green),
                                      onPressed: () => setState(() {
                                        product['quantity'] =
                                            (product['quantity'] ?? 1) + 1;
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_shopping_cart,
                                  color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  widget.cartItems.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Items Total: \$${itemTotal.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Delivery Charge: \$${deliveryCharge.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Divider(),
                      Text(
                        'Final Total: \$${finalTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Select Payment Method",
                          border: OutlineInputBorder(),
                        ),
                        value: selectedPaymentMethod,
                        items: [
                          DropdownMenuItem(
                              child: Text("JazzCash"), value: "JazzCash"),
                          DropdownMenuItem(child: Text("Cash"), value: "Cash"),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: selectedPaymentMethod == null
                            ? null
                            : () {
                                placeOrder();
                              },
                        child: Text('Place Order'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
