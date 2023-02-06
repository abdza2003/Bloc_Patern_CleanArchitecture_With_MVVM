part of 'products_bloc.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}
class LoadingState extends ProductsState{}
class ListProductsChangedState extends ProductsState{
  final SchoolProducts schoolProducts;
  ListProductsChangedState({required this.schoolProducts});

}
class ErrorMsgState extends ProductsState{
  late final String message;

  ErrorMsgState({required this.message});

}
class SuccessMsgState extends ProductsState{
  late final String message;

  SuccessMsgState({required this.message});

}
class LoadedBannedState extends ProductsState {
  final List<Product> products;

  LoadedBannedState({ required this.products});


}
class LoadedProductsSchoolState extends ProductsState {
  final List<ProductModel> products;

  LoadedProductsSchoolState({required this.products});


}