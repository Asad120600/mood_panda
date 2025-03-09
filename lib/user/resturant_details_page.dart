import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cartpage.dart';

class ResturantDetailsPage extends StatefulWidget {
  final int userId;
  final String storeName;
  final List<dynamic> sharedCart;

  ResturantDetailsPage(
      {required this.userId,
      required this.storeName,
      required this.sharedCart});

  @override
  _ResturantDetailsPageState createState() => _ResturantDetailsPageState();
}

class _ResturantDetailsPageState extends State<ResturantDetailsPage> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  int page = 1;
  bool isLoading = false;
  bool hasNextPage = true;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  Map<int, int> productQuantities = {}; // Track quantities for each product

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (isLoading || !hasNextPage) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          'https://moodpandaa.com/public/api/vendors/${widget.userId}/products?page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List newProducts = data['data'];
      print(data);

      setState(() {
        page++;
        products.addAll(newProducts);
        filteredProducts = products; // Sync filtered list with all products
        hasNextPage = data['next_page_url'] != null;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load products');
    }
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products
            .where((product) =>
                product['store_name']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                product['category_name']
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void addToCart(dynamic product) {
    setState(() {
      productQuantities[product['id']] =
          (productQuantities[product['id']] ?? 0) + 1;

      int existingIndex =
          widget.sharedCart.indexWhere((item) => item['id'] == product['id']);
      if (existingIndex != -1) {
        widget.sharedCart[existingIndex]['quantity'] =
            productQuantities[product['id']];
      } else {
        widget.sharedCart.add({
          ...product,
          'quantity': productQuantities[product['id']],
        });
      }
    });
  }

  void incrementQuantity(dynamic product) {
    setState(() {
      productQuantities[product['id']] =
          (productQuantities[product['id']] ?? 0) + 1;

      int existingIndex =
          widget.sharedCart.indexWhere((item) => item['id'] == product['id']);
      if (existingIndex != -1) {
        widget.sharedCart[existingIndex]['quantity'] =
            productQuantities[product['id']];
      }
    });
  }

  void decrementQuantity(dynamic product) {
    setState(() {
      if (productQuantities[product['id']] != null &&
          productQuantities[product['id']]! > 0) {
        productQuantities[product['id']] =
            productQuantities[product['id']]! - 1;

        int existingIndex =
            widget.sharedCart.indexWhere((item) => item['id'] == product['id']);
        if (existingIndex != -1) {
          if (productQuantities[product['id']] == 0) {
            widget.sharedCart.removeAt(existingIndex);
          } else {
            widget.sharedCart[existingIndex]['quantity'] =
                productQuantities[product['id']];
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.2),
        title: !isSearching
            ? Text('${widget.storeName} Products')
            : TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
                onChanged: filterProducts,
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  filterProducts('');
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.withOpacity(0.2),
              child: filteredProducts.isEmpty && !isLoading
                  ? Center(child: Text("No products available"))
                  : GridView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: filteredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return buildProductCard(filteredProducts[index]);
                      },
                    ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey.withOpacity(0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items in Cart: ${widget.sharedCart.length}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.withOpacity(0.9)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CartPage(cartItems: widget.sharedCart),
                      ),
                    );
                  },
                  child: Text('Go to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductCard(dynamic product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                'https://moodpandaa.com/public/storage/${product['image_path']}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['store_name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('City: ${product['city']}'),
                Text('Price: \$${product['price']}',
                    style: TextStyle(color: Colors.green)),
                SizedBox(height: 4),
                Text('Category: ${product['category_name']}',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                SizedBox(height: 4),
                Text('Platform ID: ${product['plateform_id']}',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (productQuantities[product['id']] == null ||
                    productQuantities[product['id']] == 0)
                  ElevatedButton(
                    onPressed: () => addToCart(product),
                    child: Text('Add to Cart'),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () => decrementQuantity(product),
                      ),
                      Text('Qty: ${productQuantities[product['id']] ?? 0}'),
                      IconButton(
                        icon:
                            Icon(Icons.add_circle_outline, color: Colors.green),
                        onPressed: () => incrementQuantity(product),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
