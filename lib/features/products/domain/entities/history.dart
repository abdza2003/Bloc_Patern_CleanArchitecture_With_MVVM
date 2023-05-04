import 'package:school_cafteria/features/products/data/models/products_model.dart';

class HistoryProduct {
  int? id;
  String? quantity;
  String? price;
  String? productId;
  String? schoolId;
  String? saleInvoiceId;
  String? createdAt;
  String? updatedAt;
  ProductModel? product;

  HistoryProduct({this.id,
    this.quantity,
    this.price,
    this.productId,
    this.schoolId,
    this.saleInvoiceId,
    this.createdAt,
    this.updatedAt,
    this.product});
}