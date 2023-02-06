import 'package:equatable/equatable.dart';

class Product  {
  int? id;
  String? name;
  String? barcode;
  String? image;
  String? description;
  String? price;
  String? modelType;
  String? modelId;
  String? createdAt;
  String? updatedAt;
  String? showOnMobile;
  int? quantity;
  bool selected=false;
  String isMarket="true";


  Product({
      this.id,
      this.name,
      this.barcode,
      this.image,
      this.description,
      this.price,
      this.modelType,
      this.modelId,
      this.createdAt,
      this.updatedAt,
      this.showOnMobile,
      this.quantity,
  });
}
