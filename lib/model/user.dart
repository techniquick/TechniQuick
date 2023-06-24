import 'package:techni_quick/model/cart_order.dart';
import 'package:techni_quick/model/portfolio.dart';

import 'Supplies.dart';
import 'categories.dart';

enum UserType {
  client('client'),
  supplier('supplier'),
  technician('technician');

  final String type;
  const UserType(this.type);
  factory UserType.fromValue(String type) {
    switch (type) {
      case 'client':
        return UserType.client;
      case 'supplier':
        return UserType.supplier;
      case 'technician':
        return UserType.technician;
      default:
        return UserType.client;
    }
  }
}

BaseUser userFromJson(Map<String, dynamic> map) {
  if (UserType.fromValue(map['type']) == UserType.client) {
    return Client.fromJson(map);
  } else if (UserType.fromValue(map['type']) == UserType.supplier) {
    return Supplier.fromJson(map);
  } else {
    return Technician.fromJson(map);
  }
}

abstract class BaseUser {
  final String id;
  final String fcmToken;
  final UserType type;
  final String name;
  final String email;
  final String phone;
  final String addressCord;
  final String image;
  final bool isVerfied;
  BaseUser({
    required this.id,
    required this.fcmToken,
    required this.type,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.addressCord,
    required this.isVerfied,
  });
  Map<String, dynamic> toMap();
}

class Client extends BaseUser {
  Client(
      {required super.image,
      required super.id,
      required super.fcmToken,
      required super.type,
      required super.addressCord,
      required super.name,
      required super.isVerfied,
      required super.email,
      required super.phone});

  factory Client.fromJson(Map<String, dynamic> map) {
    return Client(
      image: map['image'],
      id: map['id'],
      isVerfied: map['is_verfied'] ?? false,
      fcmToken: map['fcm_token'] ?? "",
      type: UserType.fromValue(map['type']),
      addressCord: map['address_cord'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }
  @override
  Map<String, dynamic> toMap() => {
        'image': image,
        'id': id,
        'fcm_token': fcmToken,
        'type': type.type,
        'is_verfied': isVerfied,
        'address_cord': addressCord,
        'name': name,
        'email': email,
        'phone': phone,
      };
}

class Technician extends BaseUser {
  final TechCategory techCategory;
  final String nationalId;
  final List<Portfolio> portfolios;
  final List<Rate> rates;
  final bool isOnline;
  Technician(
      {required super.image,
      required this.portfolios,
      required this.rates,
      required this.techCategory,
      required this.nationalId,
      required this.isOnline,
      required super.id,
      required super.isVerfied,
      required super.fcmToken,
      required super.type,
      required super.addressCord,
      required super.name,
      required super.email,
      required super.phone});

  factory Technician.fromJson(Map<String, dynamic> map) {
    return Technician(
      isOnline: map["is_online"] ?? false,
      isVerfied: map["is_verfied"] ?? false,
      fcmToken: map["fcm_token"] ?? "",
      image: map['image'],
      techCategory: TechCategory.fromMap(map['tech_category']),
      portfolios: List<Portfolio>.from(
          map["portfolio"].map((x) => Portfolio.fromJson(x))),
      rates: map["rates"] == null
          ? []
          : List<Rate>.from(map["rates"].map((x) => Rate.fromJson(x))),
      nationalId: map['national_id'],
      id: map['id'],
      type: UserType.fromValue(map['type']),
      addressCord: map['address_cord'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }
  @override
  Map<String, dynamic> toMap() => {
        'image': image,
        'is_online': isOnline,
        'fcm_token': fcmToken,
        'tech_category': techCategory.toMap(),
        'national_id': nationalId,
        'id': id,
        'is_verfied': isVerfied,
        'type': type.type,
        'address_cord': addressCord,
        'name': name,
        'email': email,
        'phone': phone,
        "portfolio": List<dynamic>.from(portfolios.map((x) => x.toJson())),
        "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
      };
}

class Supplier extends BaseUser {
  final List<Supplies> supplies;
  final List<Rate> rates;
  Supplier(
      {required super.image,
      required this.supplies,
      required this.rates,
      required super.id,
      required super.fcmToken,
      required super.isVerfied,
      required super.type,
      required super.addressCord,
      required super.name,
      required super.email,
      required super.phone});

  factory Supplier.fromJson(Map<String, dynamic> map) {
    return Supplier(
      image: map['image'],
      fcmToken: map['fcm_token'] ?? "",
      isVerfied: map["is_verfied"] ?? false,
      supplies:
          List<Supplies>.from(map["supplies"].map((x) => Supplies.fromJson(x))),
      rates: map["rates"] == null
          ? []
          : List<Rate>.from(map["rates"].map((x) => Rate.fromJson(x))),
      id: map['id'],
      type: UserType.fromValue(map['type']),
      addressCord: map['address_cord'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }
  @override
  Map<String, dynamic> toMap() => {
        'image': image,
        'id': id,
        'fcm_token': fcmToken,
        'type': type.type,
        'address_cord': addressCord,
        'name': name,
        'is_verfied': isVerfied,
        'email': email,
        'phone': phone,
        "supplies": List<dynamic>.from(supplies.map((x) => x.tojson())),
        "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
      };
}
