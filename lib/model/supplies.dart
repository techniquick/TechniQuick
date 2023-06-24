import 'package:techni_quick/model/categories.dart';

class Supplies {
  final String name;
  final SuppliesCategory suppliesCategory;
  final String image;
  final String price;
  final String discription;
  final String id;
  final String userId;
  final double rate;
  Supplies({
    required this.name,
    required this.suppliesCategory,
    required this.image,
    required this.price,
    required this.discription,
    required this.id,
    required this.rate,
    required this.userId,
  });

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'supplies_category': suppliesCategory.toMap(),
      'image': image,
      'price': price,
      'discription': discription,
      'id': id,
      'rate': rate,
      'user_id': userId,
    };
  }

  factory Supplies.fromJson(Map<String, dynamic> map) {
    return Supplies(
      name: map['name'] ?? '',
      rate: map['rate'] ?? 0.0,
      suppliesCategory: SuppliesCategory.fromMap(map['supplies_category']),
      image: map['image'] ?? '',
      price: map['price'] ?? '',
      id: map['id'] ?? '',
      discription: map['discription'] ?? '',
      userId: map['user_id'] ?? '',
    );
  }
}

class CartSupplies extends Supplies {
  final int quantity;
  CartSupplies(
      {required super.name,
      required super.suppliesCategory,
      required super.rate,
      required this.quantity,
      required super.image,
      required super.price,
      required super.discription,
      required super.id,
      required super.userId});

  @override
  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'supplies_category': suppliesCategory.toMap(),
      'image': image,
      'price': price,
      'discription': discription,
      'id': id,
      'rate': rate,
      'user_id': userId,
      'quantity': quantity,
    };
  }

  factory CartSupplies.fromJson(Map<String, dynamic> map) {
    return CartSupplies(
      name: map['name'] ?? '',
      rate: map['rate'] ?? 0.0,
      quantity: map['quantity'] ?? '',
      suppliesCategory: SuppliesCategory.fromMap(map['supplies_category']),
      image: map['image'] ?? '',
      price: map['price'] ?? '',
      id: map['id'] ?? '',
      discription: map['discription'] ?? '',
      userId: map['user_id'] ?? '',
    );
  }
}
