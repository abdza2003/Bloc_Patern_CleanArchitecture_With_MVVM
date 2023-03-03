import 'package:school_cafteria/features/products/data/models/school_days_model.dart';
import 'package:school_cafteria/features/products/domain/entities/week_days.dart';

class WeekDaysModel extends WeekDays
{
  WeekDaysModel({super.days, super.weeklyBalance, super.weeklyProductsPrice});

  WeekDaysModel.fromJson(Map<String, dynamic> json) {
    if (json['days'] != null) {
      days = <SchoolDaysModel>[];
      json['days'].forEach((v) {
        days!.add(SchoolDaysModel.fromJson(v));
      });
    }
    weeklyBalance = json['weekly_balance'];
    weeklyProductsPrice = json['weekly_products_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (days != null) {
      data['days'] = days!.map((v) => v.toJson()).toList();
    }
    data['weekly_balance'] = weeklyBalance;
    data['weekly_products_price'] = weeklyProductsPrice;
    return data;
  }
}
