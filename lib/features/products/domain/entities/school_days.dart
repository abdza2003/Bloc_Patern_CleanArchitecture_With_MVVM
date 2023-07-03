import 'package:equatable/equatable.dart';

class SchoolDays extends Equatable {
  dynamic dayId;
  dynamic dayName;
  dynamic productsCount;
  dynamic mealsCount;
  dynamic productsPrice;

  SchoolDays(
      {this.dayId,
      this.dayName,
      this.productsCount,
      this.productsPrice,
      this.mealsCount});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
