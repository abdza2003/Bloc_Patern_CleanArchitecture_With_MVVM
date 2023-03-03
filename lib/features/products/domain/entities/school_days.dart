import 'package:equatable/equatable.dart';

class SchoolDays  extends Equatable {
  int? dayId;
  String? dayName;
  int? productsCount;
  dynamic productsPrice;

  SchoolDays({this.dayId, this.dayName, this.productsCount, this.productsPrice});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}