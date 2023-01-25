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
      super.quantity});
}
