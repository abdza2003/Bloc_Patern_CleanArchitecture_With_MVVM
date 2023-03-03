import 'package:school_cafteria/features/products/domain/entities/selected_products.dart';

class SelectedProductsModel extends SelectedProducts
{
  SelectedProductsModel({super.id, super.productsId, super.mealsId,super.dayId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productsId != null) {
      data['products_ids'] = productsId!.map((v) => v.toString()).toList();
    }
    if (mealsId != null) {
      data['meals_ids'] = mealsId!.map((v) => v.toString()).toList();
    }
    data['student_id']=id;
    data['day_id']=dayId;
    return data;
  }
}