import 'package:school_cafteria/features/products/domain/entities/selected_products.dart';

import '../../domain/entities/selected_products_quantity.dart';

class SelectedProductsQuantityModel extends SelectedProductsQuantity
{
  SelectedProductsQuantityModel({super.dayId, super.productsIds, super.mealsIds,super.studentId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = studentId;
    data['day_id'] = dayId;
    if (productsIds != null) {
      data['products_ids'] = productsIds!.map((v) => v.toJson()).toList();
    }
    if (mealsIds != null) {
      data['meals_ids'] = mealsIds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}