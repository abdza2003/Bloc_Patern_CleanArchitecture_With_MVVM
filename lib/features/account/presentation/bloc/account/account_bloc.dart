import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/features/account/domain/usecases/account_check_login.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/child.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/account_add_child.dart';
import '../../../domain/usecases/account_login.dart';
import '../../../domain/usecases/account_login_again.dart';
import '../../../domain/usecases/account_logout.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountLoginUsecase login;
  final AccountLoginAgainUsecase loginAgainUsecase;
  final AccountLogoutUsecase logout;
  final AccountCheckLoginUsecase checkLoginUsecase;
  final AccountAddChildUsecase accountAddChildUsecase;

  AccountBloc({
    required this.login,
    required this.logout,
    required this.checkLoginUsecase,
    required this.loginAgainUsecase,
    required this.accountAddChildUsecase,
  }) : super(AccountInitial()) {
    on<AccountEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoadingState());
        final failureOrUser =
            await login(event.usernameOrEmail, event.password, event.isEmail);
        failureOrUser.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (user) {
          emit(LoggedInState(user: user));
        });
      } else if (event is LogoutEvent) {
        emit(LoadingState());
        final failureOrUnit = await logout();
        failureOrUnit.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (_) {
          emit(LoggedOutState());
          emit(SuccessMsgState(
              message: AppLocalizations.instance
                  .translate("LOGGED_OUT_SUCCESSFULLY")));
        });
        //Fluttertoast.showToast(msg: "logged out successfully");
      } else if (event is CheckLoginEvent) {
        final failureOrUser = await checkLoginUsecase();
        failureOrUser.fold((_) {
          emit(LoggedOutState());
        }, (user) {
          emit(LoggedInState(user: user));
        });
      } else if (event is SecondLoginEvent) {
        emit(LoadingState());
        final failureOrUser = await loginAgainUsecase(
            event.usernameOrEmail, event.password, event.isEmail);
        failureOrUser.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (user) {
          emit(LoggedInState(user: user));
        });
      } else if (event is AddChildEvent) {
        emit(LoadingState());
        final failureOrUnit = await accountAddChildUsecase(
            event.name,
            event.userName,
            event.password,
            event.email,
            event.mobile,
            event.image,
            event.accessToken
        );
        failureOrUnit.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (_) {
          emit(SuccessMsgState(message: AppLocalizations.instance
              .translate("ADD_SUCCESSFULLY")));
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
