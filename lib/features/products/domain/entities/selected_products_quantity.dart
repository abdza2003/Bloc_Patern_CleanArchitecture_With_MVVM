import 'package:equatable/equatable.dart';

class SelectedProductsQuantity extends Equatable {
  dynamic studentId;
  dynamic dayId;
  List<ProductSelection>? productsIds;
  List<ProductSelection>? mealsIds;

  @override
  List<Object?> get props => [];

  SelectedProductsQuantity(
      {this.studentId, this.dayId, this.productsIds, this.mealsIds});
}

class ProductSelection {
  int? id;
  int? quantity;
  dynamic scheduleId;
  dynamic date;

  ProductSelection({this.id, this.quantity, this.scheduleId, this.date});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['schedule_id'] = scheduleId;
    data['date'] = date;
    return data;
  }
}
