class Items {
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
  final String date; // Store Nepali date as a formatted string

  Items({
    required this.classs,
    required this.customer,
    required this.groupcod,
    required this.cid,
    required this.groupid,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.checkout,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
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
    };
  }

  factory Items.fromMap(Map<String, dynamic> map) {
    return Items(
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
    );
  }
}
