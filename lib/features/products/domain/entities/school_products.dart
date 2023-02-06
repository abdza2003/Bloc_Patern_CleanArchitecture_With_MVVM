import 'package:equatable/equatable.dart';
import 'package:school_cafteria/features/products/data/models/products_model.dart';
import 'package:school_cafteria/features/products/domain/entities/products.dart';

class SchoolProducts extends Equatable
{
  List<ProductModel>? market;
  List<ProductModel>? restaurant;
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  SchoolProducts({this.market, this.restaurant});
}