part of 'products_bloc.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class LoadingState extends ProductsState {}

class ListProductsChangedState extends ProductsState {
  final SchoolProducts schoolProducts;
  ListProductsChangedState({required this.schoolProducts});
}

class ErrorMsgState extends ProductsState {
  late final String message;

  ErrorMsgState({required this.message});
}

class SuccessMsgState extends ProductsState {
  late final String message;

  SuccessMsgState({required this.message});
}

class LoadedBannedState extends ProductsState {
  final List<Product> products;

  LoadedBannedState({required this.products});
}

class LoadedInvoicesState extends ProductsState {
  final List<Invoice> invoices;

  LoadedInvoicesState({required this.invoices});
}

class LoadedHistoryProductsState extends ProductsState {
  final List<HistoryProduct> historyProduct;

  LoadedHistoryProductsState({required this.historyProduct});
}

class LoadedSchoolDaysState extends ProductsState {
  final WeekDays weekDays;

  LoadedSchoolDaysState({required this.weekDays});
}

class LoadedSchoolProductsByPriceState extends ProductsState {
  final List<ProductModel> products;
  List<ProductModel>? filteredProducts;

  LoadedSchoolProductsByPriceState({required this.products});
}

class LoadedDayProductsState extends ProductsState {
  final List<Product> products;

  LoadedDayProductsState({required this.products});
}

class LoadedProductsSchoolState extends ProductsState {
  final List<ProductModel> products;

  LoadedProductsSchoolState({required this.products});
}

class LoadedDatedProductsState extends ProductsState {
  List<Product> products = [];

  LoadedDatedProductsState({required this.products});
}

class LoadedBookedProductsState extends ProductsState {
  final List<Product> products;

  LoadedBookedProductsState({required this.products});
}

class SuccessMsgStateStoredBookedProducts extends ProductsState {
  late final String message;

  SuccessMsgStateStoredBookedProducts({required this.message});
}
