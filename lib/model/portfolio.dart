class Portfolio {
  final String image;
  final String userName;
  final String orderDescription;
  Portfolio({
    required this.image,
    required this.userName,
    required this.orderDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'user_name': userName,
      'order_description': orderDescription,
    };
  }

  factory Portfolio.fromJson(Map<String, dynamic> map) {
    return Portfolio(
      image: map['image'] ?? '',
      userName: map['user_name'] ?? '',
      orderDescription: map['order_description'] ?? '',
    );
  }
}
