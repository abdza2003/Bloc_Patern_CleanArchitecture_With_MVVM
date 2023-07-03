import 'package:school_cafteria/features/products/data/models/products_model.dart';

class HistoryProduct {
  int? id;
  dynamic quantity;
  dynamic price;
  dynamic productId;
  dynamic schoolId;
  dynamic saleInvoiceId;
  dynamic createdAt;
  dynamic updatedAt;
  ProductModel? product;

  HistoryProduct(
      {this.id,
      this.quantity,
      this.price,
      this.productId,
      this.schoolId,
      this.saleInvoiceId,
      this.createdAt,
      this.updatedAt,
      this.product});
}
