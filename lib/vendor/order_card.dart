import 'package:flutter/material.dart';
import 'package:multi_vendor_app/vendor/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final Function(int, String) onUpdateStatus;
  final bool showButtons;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onUpdateStatus,
    required this.showButtons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.orderId}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('User ID: ${order.userId}'),
            Text('Vendor ID: ${order.vendorId}'),
            Text('Category ID: ${order.categoryId}'),
            Text('Platform ID: ${order.plateformId}'),
            Text('Menu ID: ${order.menuId}'),
            Text('Quantity: ${order.quantity}'),
            Text('Total Price: \$${order.totalPrice}'),
            Text('Payment Method: ${order.paymentMethod}'),
            Text('Status: ${order.status}'),
            Text('Created At: ${order.createdAt}'),
            Text('Updated At: ${order.updatedAt}'),
            if (showButtons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: order.isStatusUpdated
                        ? null // Disable if status is updated
                        : () => onUpdateStatus(order.orderId, 'Accepted'),
                    child: Text('Accept'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: order.isStatusUpdated
                        ? null // Disable if status is updated
                        : () => onUpdateStatus(order.orderId, 'Rejected'),
                    child: Text('Reject'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
