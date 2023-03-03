import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:school_cafteria/features/balance/domain/usecases/store_weekly_balance.dart';
import '../../../../app_localizations.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/add_balance_usecase.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  AddBalanceUsecase addBalanceUsecase;
  StoreWeeklyBalanceUsecase storeWeeklyBalanceUsecase;
  BalanceBloc({required this.addBalanceUsecase,required this.storeWeeklyBalanceUsecase}) : super(BalanceInitial()) {
    on<BalanceEvent>((event, emit) async {
      if(event is AddBalanceEvent)
        {
          emit(LoadingState());
          final failureOrUnit = await addBalanceUsecase(event.childId,event.balance,event.accessToken);
          failureOrUnit.fold(
                  (failure) =>
                  emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
                  (_) {

                emit(SuccessMsgState(
                    message: "Order needs to be reviewed from the admin"));

              });
        }
      else if(event is StoreWeeklyBalanceEvent)
        {
          emit(LoadingState());
          final failureOrUnit = await storeWeeklyBalanceUsecase(event.childId,event.balance,event.accessToken);
          failureOrUnit.fold(
                  (failure) =>
                  emit(ErrorMsgState(message: _mapFailureToMessage(failure))),
                  (_) {

                emit(SuccessMsgState(
                    message: "Weekly Balanced has been set"));

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
