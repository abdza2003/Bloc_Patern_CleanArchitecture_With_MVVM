import 'package:school_cafteria/features/products/data/models/products_model.dart';
import 'package:school_cafteria/features/products/domain/entities/school_products.dart';

class SchoolProductModel extends SchoolProducts {
  SchoolProductModel({super.market, super.restaurant});

  SchoolProductModel.fromJson(Map<String, dynamic> json) {
    if (json['market_products'] != null) {
      market = <ProductModel>[];
      json['market_products'].forEach((v) {
        market!.add( ProductModel.fromJson(v));
      });
    }
    if (json['restaurant_products'] != null) {
      restaurant = <ProductModel>[];
      json['restaurant_products'].forEach((v) {
        restaurant!.add( ProductModel.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (market != null) {
      data['market_products'] = market!.map((v) => v.toJson()).toList();
    }
    if (restaurant != null) {
      data['restaurant_products'] = restaurant!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  }
