import 'package:equatable/equatable.dart';

class Product extends Equatable {
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



  @override
  List<Object?> get props => [];

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
      this.quantity});
}
