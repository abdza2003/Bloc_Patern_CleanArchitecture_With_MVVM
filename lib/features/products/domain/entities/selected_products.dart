import 'package:equatable/equatable.dart';

class SelectedProducts extends Equatable {
  int? id;
  List<int>? productsId;
  List<int>? mealsId;



  @override
  List<Object?> get props => [];

  SelectedProducts({this.id,this.productsId, this.mealsId});
}
