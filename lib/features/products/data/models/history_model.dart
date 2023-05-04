import 'package:school_cafteria/features/products/data/models/products_model.dart';

import '../../domain/entities/history.dart';

class HistoryProductModel extends HistoryProduct
{
  HistoryProductModel({super.id,
    super.quantity,
    super.price,
    super.productId,
    super.schoolId,
    super.saleInvoiceId,
    super.createdAt,
    super.updatedAt,
    super.product});

  HistoryProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    productId = json['product_id'];
    schoolId = json['school_id'];
    saleInvoiceId = json['sale_invoice_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['price'] = price;
    data['product_id'] = productId;
    data['school_id'] = schoolId;
    data['sale_invoice_id'] = saleInvoiceId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}