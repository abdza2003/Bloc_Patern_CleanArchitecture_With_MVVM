import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:school_cafteria/features/products/data/models/products_model.dart';
import 'package:school_cafteria/features/products/data/models/school_days_model.dart';
import 'package:school_cafteria/features/products/domain/entities/school_products.dart';
import 'package:school_cafteria/features/products/domain/entities/week_days.dart';
import '../../../../app_localizations.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/selected_products_model.dart';
import '../../domain/entities/products.dart';
import '../../domain/entities/school_days.dart';
import '../../domain/usecases/delete_banned_products.dart';
import '../../domain/usecases/delete_day_product.dart';
import '../../domain/usecases/get_all_banned_products..dart';
import '../../domain/usecases/get_all_school_products..dart';
import '../../domain/usecases/get_day_products.dart';
import '../../domain/usecases/get_school_days.dart';
import '../../domain/usecases/get_school_product_by_price.dart';
import '../../domain/usecases/store_banned_products.dart';
import '../../domain/usecases/store_day_products.dart';
import '../../domain/usecases/store_week_products.dart';

part 'products_event.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  DeleteBannedProductsUsecase deleteBannedProductsUsecase;
  GetAllBannedProductsUsecase getAllBannedProductsUsecase;
  GetAllSchoolProductsUsecase getAllSchoolProductsUsecase;
  StoreBannedProductsUsecase storeBannedProductsUsecase;

  GetDayProductsUsecase getDayProductsUsecase;
  GetSchoolDaysUsecase getSchoolDaysUsecase;
  GetSchoolProductsByPriceUsecase getSchoolProductsByPriceUsecase;
  StoreDayProductsUsecase storeDayProductsUsecase;
  StoreWeekProductsUsecase storeWeekProductsUsecase;
  DeleteDayProductUsecase deleteDayProductUsecase;

  ProductsBloc(
      {required this.storeBannedProductsUsecase,
      required this.getAllSchoolProductsUsecase,
      required this.getAllBannedProductsUsecase,
      required this.deleteBannedProductsUsecase,
      required this.getSchoolProductsByPriceUsecase,
      required this.getSchoolDaysUsecase,
      required this.getDayProductsUsecase,
      required this.deleteDayProductUsecase,
      required this.storeDayProductsUsecase,
        required this.storeWeekProductsUsecase
      })
      : super(ProductsInitial()) {
    on<ProductsEvent>((event, emit) async {
      if (event is GetAllSchoolProductsEvent) {
        emit(LoadingState());
        final failureOrSchoolProducts =
            await getAllSchoolProductsUsecase(event.childId, event.accessToken);
        failureOrSchoolProducts.fold(
            (failure) =>
                emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
            (schoolProducts) {
              List <ProductModel> pm=schoolProducts.restaurant!+schoolProducts.market!;
              emit(LoadedProductsSchoolState(products: pm));
            }
        );
            }else if (event is GetAllBannedProductsEvent) {
        emit(LoadingState());
        final failureOrProducts =
            await getAllBannedProductsUsecase(event.childId, event.accessToken);
        failureOrProducts.fold(
            (failure) =>
                emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
            (products) => emit(LoadedBannedState(products: products)));
      } else if (event is DeleteBannedProductsEvent) {
        emit(LoadingState());
        final failureOrUnit = await deleteBannedProductsUsecase(
            event.productId, event.childId, event.accessToken);
        failureOrUnit.fold(
            (failure) =>
                emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
            (_) => emit(SuccessMsgState(
                message: AppLocalizations.instance
                    .translate("PRODUCT_ITEM_DELETE"))));
      } else if (event is StoreBannedProductsEvent) {
        emit(LoadingState());
        final failureOrUnit = await storeBannedProductsUsecase(
            event.selectedProducts, event.accessToken);
        failureOrUnit.fold(
            (failure) =>
                emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
            (_) {

            emit(SuccessMsgState(
                message: AppLocalizations.instance
                    .translate("BANNED_PRODUCTS_ADDED")));

            });
      }
      else if (event is DeleteDayProductEvent)
        {
          emit(LoadingState());
          final failureOrUnit = await deleteDayProductUsecase(
              event.productId, event.childId, event.accessToken,event.dayId);
          failureOrUnit.fold(
                  (failure) =>
                  emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
                  (_) => emit(SuccessMsgState(
                  message: AppLocalizations.instance
                      .translate("PRODUCT_ITEM_DELETE"))));
        }
      else if (event is StoreDayProductsEvent)
        {
          emit(LoadingState());
          final failureOrUnit = await storeDayProductsUsecase(
              event.selectedProducts, event.accessToken);
          failureOrUnit.fold(
                  (failure) =>
                  emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
                  (_) {

                emit(SuccessMsgState(
                    message: AppLocalizations.instance
                        .translate("PRODUCTS_ADDED")));

              });
        }
      else if (event is GetDayProductsEvent)
        {
          emit(LoadingState());
          final failureOrSchoolProducts =
          await getDayProductsUsecase(event.childId, event.accessToken,event.dayId);
          failureOrSchoolProducts.fold(
                  (failure) =>
                  emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
                  (schoolProducts) {
                emit(LoadedDayProductsState(products: schoolProducts));
              }
          );
        }
      else if (event is GetSchoolProductsByPriceEvent)
        {
          emit(LoadingState());
          final failureOrSchoolProducts =
          await getSchoolProductsByPriceUsecase(event.childId, event.accessToken, event.maxPrice);
          failureOrSchoolProducts.fold(
                  (failure) =>
                  emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
                  (schoolProducts) {
                List <ProductModel> pm=schoolProducts.restaurant!+schoolProducts.market!;
                emit(LoadedSchoolProductsByPriceState(products: pm));
              }
          );
        }
      else if(event is GetSchoolDaysEvent)
        {
          emit(LoadingState());
          final failureOrWeekDays =
          await getSchoolDaysUsecase(event.childId, event.accessToken);
          failureOrWeekDays.fold(
                  (failure) =>
                  emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
                  (weekDays) {
                emit(LoadedSchoolDaysState(weekDays: weekDays));
              }
          );
        }
      else if (event is StoreWeekProductsEvent)
        {
          emit(LoadingState());
          final failureOrUnit = await storeWeekProductsUsecase(
              event.selectedProducts, event.accessToken);
          failureOrUnit.fold(
                  (failure) =>
                  emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
                  (_) {

                emit(SuccessMsgState(
                    message: "Products added to whole week , you can change it any time"));

              });
        }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppLocalizations.instance.translate("SERVER_FAILURE_MESSAGE");
      case WrongRegistrationInformationFailure:
        return AppLocalizations.instance.translate("WRONG_REGISTRATION_DATA");
      case OfflineFailure:
        return AppLocalizations.instance.translate("OFFLINE_FAILURE_MESSAGE");
      case WrongLoginInformationFailure:
        return AppLocalizations.instance.translate("WRONG_LOGIN_MESSAGE");
      default:
        return AppLocalizations.instance.translate("UNEXPECTED_ERROR_MESSAGE");
    }
  }
}
