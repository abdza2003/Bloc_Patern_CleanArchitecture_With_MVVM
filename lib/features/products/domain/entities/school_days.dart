import 'package:equatable/equatable.dart';

class SchoolDays  extends Equatable {
  int? dayId;
  String? dayName;
  int? productsCount;
  int? mealsCount;
  dynamic productsPrice;

  SchoolDays({this.dayId, this.dayName, this.productsCount, this.productsPrice,this.mealsCount});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}