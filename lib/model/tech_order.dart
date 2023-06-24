import 'dart:convert';

import 'cart_order.dart';
import 'user.dart';

class TechRequest extends BaseOrder {
  String id = "";
  final String problemDetails;
  final String? image;
  final Client endUser;
  final String endUserId;
  final String address;
  final String addressCord;
  final DateTime createdAt;
  final double finalPrice;
  OrderStatus status;
  final String categoryName;
  final Offer? currentOffer;
  final bool? isRate;
  TechRequest({
    required this.id,
    required this.problemDetails,
    required this.categoryName,
    this.image,
    this.isRate,
    required this.endUser,
    required this.endUserId,
    required this.address,
    required this.addressCord,
    required this.createdAt,
    required this.finalPrice,
    required this.status,
    this.currentOffer,
  });
  double getLat() => double.parse(addressCord.split(",").first);
  double getLng() => double.parse(addressCord.split(",").last);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'problem_details': problemDetails,
      'image': image,
      'is_rate': isRate,
      'end_user': endUser.toMap(),
      'category_name': categoryName,
      'end_user_id': endUserId,
      'address_cord': addressCord,
      'address': address,
      'created_at': createdAt.millisecondsSinceEpoch,
      'final_price': finalPrice,
      'status': status.name,
      'current_offer': currentOffer?.toMap(),
    };
  }

  factory TechRequest.fromMap(Map<String, dynamic> map) {
    return TechRequest(
      id: map['id'] ?? '',
      problemDetails: map['problem_details'] ?? '',
      categoryName: map['category_name'] ?? '',
      addressCord: map['address_cord'] ?? '',
      image: map['image'] ?? "",
      isRate: map['is_rate'] ?? false,
      endUser: Client.fromJson(map['end_user']),
      endUserId: map['end_user_id'] ?? '',
      address: map['address'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      finalPrice: map['final_price']?.toDouble() ?? 0.0,
      status: map['status'].toString().fromString(),
      currentOffer: map['current_offer'] != null
          ? Offer.fromMap(map['current_offer'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TechRequest.fromJson(String source) =>
      TechRequest.fromMap(json.decode(source));
}

enum OfferStatus {
  newOffer,
  accepted,
  rejected,
  rejectedByTech,
}

extension OfferStatusExtintion on String {
  OfferStatus offerStatusfromString() {
    switch (this) {
      case 'newOffer':
        return OfferStatus.newOffer;
      case 'accepted':
        return OfferStatus.accepted;
      case 'rejected':
        return OfferStatus.rejected;
      case 'rejectedByTech':
        return OfferStatus.rejectedByTech;
      default:
        throw Exception('Invalid CartOrderStatus name');
    }
  }
}

class Offer {
  final Technician technician;
  final String technicianId;
  final String priceMin;
  final String priceMax;
  String? finalPrice;
  String? image;
  final OfferStatus offerStatus;
  Offer({
    required this.technicianId,
    required this.technician,
    required this.priceMin,
    required this.priceMax,
    this.finalPrice,
    required this.offerStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'technician_id': technicianId,
      'technician': technician.toMap(),
      'price_min': priceMin,
      'final_price': finalPrice,
      'price_max': priceMax,
      'offer_status': offerStatus.name,
    };
  }

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      technicianId: map["technician_id"] ?? "",
      technician: Technician.fromJson(map['technician']),
      priceMin: map['price_min'] ?? "",
      finalPrice: map['final_price'] ?? "",
      priceMax: map['price_max'] ?? "",
      offerStatus: map['offer_status'].toString().offerStatusfromString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Offer.fromJson(String source) => Offer.fromMap(json.decode(source));
}
