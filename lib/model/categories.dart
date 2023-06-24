import '../presentation/pages/auth/select_category_screen.dart';

class TechCategory {
  final String categoryName;
  final List<String> subCategory;

  TechCategory({
    required this.categoryName,
    required this.subCategory,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_name': categoryName,
      "sub_category": List<dynamic>.from(subCategory.map((x) => x))
    };
  }

  factory TechCategory.fromJob(Job job) {
    return TechCategory(
      categoryName: job.name,
      subCategory: job.professions,
    );
  }
  factory TechCategory.fromMap(Map<String, dynamic> map) {
    return TechCategory(
      categoryName: map['category_name'] ?? '',
      subCategory: List<String>.from(map["sub_category"].map((x) => x)),
    );
  }
}

class SuppliesCategory {
  final String suppliesName;
  SuppliesCategory({
    required this.suppliesName,
  });

  Map<String, dynamic> toMap() {
    return {
      'supplies_name': suppliesName,
    };
  }

  factory SuppliesCategory.fromMap(Map<String, dynamic> map) {
    return SuppliesCategory(
      suppliesName: map['supplies_name'] ?? '',
    );
  }
}
