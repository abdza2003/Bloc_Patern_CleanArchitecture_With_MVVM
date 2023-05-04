import 'package:school_cafteria/features/products/domain/entities/products.dart';

class ProductModel extends Product {
  ProductModel({
      super.id,
      super.name,
      super.barcode,
      super.image,
      super.description,
      super.price,
      super.modelType,
      super.modelId,
      super.createdAt,
      super.updatedAt,
      super.showOnMobile,
      super.quantity,
      super.isAvailableToBook,
      super.restaurantDatedProduct
       //super.isMarket,
      // super.selected

  });

  ProductModel.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
      barcode = json['barcode'];
      image = json['image'];
      description = json['description'];
      price = json['price'];
      modelType = json['model_type'];
      modelId = json['model_id'];
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
      showOnMobile = json['show_on_mobile'];
      quantity = json['available_quantity'];
      isAvailableToBook = json['is_available_to_book'];
      restaurantDatedProduct = json['restaurant_dated_product'] != null
          ? RestaurantDatedProduct.fromJson(json['restaurant_dated_product'])
          : null;
  }

  Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = id;
      data['name'] = name;
      data['barcode'] = barcode;
      data['image'] = image;
      data['description'] = description;
      data['price'] = price;
      data['model_type'] = modelType;
      data['model_id'] = modelId;
      data['created_at'] = createdAt;
      data['updated_at'] = updatedAt;
      data['show_on_mobile'] = showOnMobile;
      data['available_quantity'] = quantity;
      data['is_available_to_book'] = isAvailableToBook;
      return data;
  }
}
