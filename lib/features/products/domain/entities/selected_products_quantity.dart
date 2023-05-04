import 'package:equatable/equatable.dart';

class SelectedProductsQuantity extends Equatable {
  int? studentId;
  int? dayId;
  List<ProductSelection>? productsIds;
  List<ProductSelection>? mealsIds;



  @override
  List<Object?> get props => [];

  SelectedProductsQuantity({this.studentId,this.dayId, this.productsIds,this.mealsIds});

}
class ProductSelection {
  int? id;
  int? quantity;

  ProductSelection({this.id, this.quantity});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    return data;
  }
}