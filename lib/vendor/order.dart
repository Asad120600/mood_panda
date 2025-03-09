class Order {
  final int orderId;
  final int userId;
  final int vendorId;
  final int categoryId;
  final int plateformId;
  final int menuId;
  final int quantity;
  final String totalPrice;
  final String paymentMethod;
  late final String status;
  final String createdAt;
  final String updatedAt;
  bool isStatusUpdated;  // Flag to track if the status is updated dynamically

  Order({
    required this.orderId,
    required this.userId,
    required this.vendorId,
    required this.categoryId,
    required this.plateformId,
    required this.menuId,
    required this.quantity,
    required this.totalPrice,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.isStatusUpdated = false, // Initialize as false
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      userId: json['user_id'],
      vendorId: json['vendor_id'],
      categoryId: json['category_id'],
      plateformId: json['plateform_id'],
      menuId: json['menu_id'],
      quantity: json['quantity'],
      totalPrice: json['total_price'],
      paymentMethod: json['payment_method'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isStatusUpdated: json['status'] == 'Accepted' || json['status'] == 'Rejected',  // Set flag if status is updated
    );
  }
}
