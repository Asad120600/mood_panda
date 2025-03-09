import 'package:flutter/material.dart';

class VendorPackagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Packages'),
      ),
      body: ListView(
        children: [
          VendorPackageCard(
            packageName: 'Silver',
            price: '\$99/month',
            benefits: [
              'Basic vendor profile',
              'Up to 20 product listings',
              'Basic customer support',
              'Standard analytics',
            ],
          ),
          VendorPackageCard(
            packageName: 'Gold',
            price: '\$199/month',
            benefits: [
              'Advanced vendor profile',
              'Up to 50 product listings',
              'Priority customer support',
              'Advanced analytics',
              'Discount on transactions',
            ],
          ),
          VendorPackageCard(
            packageName: 'Platinum',
            price: '\$299/month',
            benefits: [
              'Premium vendor profile',
              'Unlimited product listings',
              '24/7 customer support',
              'Premium analytics',
              'Free transaction fees',
              'Marketing boost',
            ],
          ),
        ],
      ),
    );
  }
}

class VendorPackageCard extends StatelessWidget {
  final String packageName;
  final String price;
  final List<String> benefits;

  VendorPackageCard({
    required this.packageName,
    required this.price,
    required this.benefits,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              packageName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Benefits:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: benefits
                  .map((benefit) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.check, size: 16, color: Colors.green),
                            SizedBox(width: 8),
                            Text(benefit),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
