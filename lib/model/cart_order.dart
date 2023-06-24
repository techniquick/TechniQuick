import 'dart:convert';

import 'package:techni_quick/model/user.dart';

import 'Supplies.dart';

abstract class BaseOrder {}

enum OrderStatus {
  newOrder,
  processing,
  finished,
  canceled;
}

extension CartOrderStatusExtension on String {
  OrderStatus fromString() {
    switch (this) {
      case 'newOrder':
        return OrderStatus.newOrder;
      case 'processing':
        return OrderStatus.processing;
      case 'finished':
        return OrderStatus.finished;
      case 'canceled':
        return OrderStatus.canceled;
      default:
        throw Exception('Invalid CartOrderStatus name');
    }
  }
}

class CartOrder extends BaseOrder {
  String id = "";
  final List<CartSupplies> cartSupplies;
  final String supplierUserId;
  final String endUserId;
  final String address;
  final BaseUser endUser;
  final BaseUser supplierUser;
  final DateTime createdAt;
  final OrderStatus status;
  final bool? isRate;
  CartOrder({
    required this.cartSupplies,
    required this.supplierUserId,
    required this.address,
    required this.endUserId,
    required this.endUser,
    required this.supplierUser,
    required this.createdAt,
    required this.status,
    this.isRate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cart_supplies': cartSupplies.map((x) => x.tojson()).toList(),
      'supplier_user_id': supplierUserId,
      'address': address,
      'end_user_id': endUserId,
      'end_user': endUser.toMap(),
      'supplier_user': supplierUser.toMap(),
      'created_at': createdAt.millisecondsSinceEpoch,
      'status': status.name,
      'is_rate': isRate,
    };
  }

  factory CartOrder.fromMap(Map<String, dynamic> map) {
    return CartOrder(
      cartSupplies: List<CartSupplies>.from(
          map['cart_supplies']?.map((x) => CartSupplies.fromJson(x))),
      supplierUserId: map['supplier_user_id'] ?? '',
      address: map['address'] ?? '',
      endUserId: map['end_user_id'] ?? '',
      endUser: userFromJson((map['end_user'])),
      supplierUser: userFromJson(map['supplier_user']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      status: (map['status']).toString().fromString(),
      isRate: map['is_rate'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartOrder.fromJson(String source) =>
      CartOrder.fromMap(json.decode(source));
}

class Rate {
  final String comment;
  final int rate;
  Rate({
    required this.comment,
    required this.rate,
  });

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'rate': rate,
    };
  }

  factory Rate.fromMap(Map<String, dynamic> map) {
    return Rate(
      comment: map['comment'] ?? '',
      rate: map['rate'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rate.fromJson(String source) => Rate.fromMap(json.decode(source));
}
