class OrderResponse {
  final String id; // Add the id field
  final String classs;
  final String customer;
  final String groupid;
  final String cid;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String groupcod;
  final String checkout;
  final String mealtime;
  final String date; // Store Nepali date as a formatted string
  final String orderType; // Add orderType field
  final String holdDate;

  OrderResponse({
    required this.id, // Update the constructor to include id
    required this.mealtime,
    required this.classs,
    required this.customer,
    required this.groupid,
    required this.cid,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.groupcod,
    required this.checkout,
    required this.date,
    required this.orderType, // Add orderType to the constructor
    required this.holdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id, // Add id to the map
      "mealtime": mealtime,
      'classs': classs,
      'customer': customer,
      'groupcod': groupcod,
      'groupid': groupid,
      'cid': cid,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'checkout': checkout,
      'date': date, // Store formatted Nepali date as a string
      'orderType': orderType, // Add orderType to the map
      'holdDate': holdDate,
    };
  }

  factory OrderResponse.fromJson(Map<String, dynamic> map) {
    return OrderResponse(
        id: map['id'], // Retrieve id from the map
        mealtime: map['mealtime'],
        classs: map['classs'],
        customer: map['customer'],
        groupcod: map['groupcod'],
        groupid: map['groupid'],
        cid: map['cid'],
        productName: map['productName'],
        productImage: map['productImage'],
        price: map['price'].toDouble(),
        quantity: map['quantity'],
        checkout: map['checkout'],
        date: map['date'], // Retrieve date as a string
        orderType: map['orderType'], // Retrieve orderType from the map
        holdDate: map['holdDate']);
  }
}
