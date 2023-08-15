import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/features/account/domain/usecases/account_check_login.dart';
import 'package:school_cafteria/features/account/domain/usecases/account_get_notification.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/account_add_child.dart';
import '../../../domain/usecases/account_change_password.dart';
import '../../../domain/usecases/account_delete_notification.dart';
import '../../../domain/usecases/account_edit_photo.dart';
import '../../../domain/usecases/account_login.dart';
import '../../../domain/usecases/account_login_again.dart';
import '../../../domain/usecases/account_logout.dart';
import '../../../domain/usecases/account_read_notification.dart';
import '../../../domain/usecases/account_refresh.dart';
import '../../../domain/usecases/account_register_token.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  late Box myBox = Hive.box('myAccounts');
  final AccountLoginUsecase login;
  final AccountLoginAgainUsecase loginAgainUsecase;
  final AccountLogoutUsecase logout;
  final AccountCheckLoginUsecase checkLoginUsecase;
  final AccountAddChildUsecase accountAddChildUsecase;
  final AccountRefreshUsecase accountRefreshUsecase;
  final AccountRegisterTokenUsecase accountRegisterTokenUsecase;
  final AccountChangePasswordUsecase accountChangePasswordUsecase;
  final AccountEditPhotoUsecase accountEditPhotoUsecase;
  final AccountGetNotificationUsecase accountGetNotificationUsecase;
  final AccountReadNotificationUsecase accountReadNotificationUsecase;
  final AccountDeleteNotificationUsecase accountDeleteNotificationUsecase;
  AccountBloc(
      {required this.accountRefreshUsecase,
      required this.login,
      required this.logout,
      required this.checkLoginUsecase,
      required this.loginAgainUsecase,
      required this.accountAddChildUsecase,
      required this.accountRegisterTokenUsecase,
      required this.accountChangePasswordUsecase,
      required this.accountReadNotificationUsecase,
      required this.accountGetNotificationUsecase,
      required this.accountDeleteNotificationUsecase,
      required this.accountEditPhotoUsecase})
      : super(AccountInitial()) {
    on<AccountEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoadingState());
        final failureOrUser =
            await login(event.usernameOrEmail, event.password, event.isEmail);
        failureOrUser.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
          print('==============#######===============${failure}');
        }, (user) {
          print('==============#######===============${user}');

          var result = myBox.values.any((element) =>
              element.toString().split('|')[0] == event.usernameOrEmail);
          if (result == false) {
            myBox.add('${event.usernameOrEmail}|${event.password}');
          }

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
          print('==================@@@@@@===========${failure}');
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (user) {
          print('==================@@@@@@===========${user}');
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
            event.classRoom,
            event.division,
            event.accessToken);
        failureOrUnit.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (_) {
          emit(SuccessMsgState(
              message:
                  AppLocalizations.instance.translate("ADD_SUCCESSFULLY")));
        });
      } else if (event is RefreshEvent) {
        emit(LoadingState());
        final failureOrUser = await accountRefreshUsecase(event.accessTokens);
        failureOrUser.fold((failure) {
          print('=================${failure}');
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (user) {
          emit(LoggedInState(user: user));
        });
      } else if (event is RegisterTokenEvent) {
        final failureOrUnit = await accountRegisterTokenUsecase(event.token);
      } else if (event is ChangePasswordEvent) {
        emit(LoadingState());
        final failureOrSuccess = await accountChangePasswordUsecase(
            event.oldPass, event.newPass, event.confirmPass, event.accessToken);
        failureOrSuccess.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (user) {
          emit(SuccessChangePasswordState(
              message: AppLocalizations.instance
                  .translate("PASSWORD_CHANGED_SUCCESSFULLY")));
        });
      } else if (event is GetNotificationEvent) {
        emit(LoadingState());
        final failureOrNotification =
            await accountGetNotificationUsecase(event.accessTokens);
        failureOrNotification.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (notifications) {
          emit(LoadedNotification(notifications: notifications));
        });
      } else if (event is EditPhotoEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await accountEditPhotoUsecase(event.image, event.accessTokens);
        failureOrSuccess.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (image) {
          emit(SuccessEditPhotoState(
              message: AppLocalizations.instance
                  .translate("PHOTO_CHANGED_SUCCESSFULLY"),
              image: image));
        });
      } else if (event is ReadNotificationEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await accountReadNotificationUsecase(event.accessTokens);
        failureOrSuccess.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (user) {
          emit(SuccessReadNotificationState(message: "Read"));
        });
      } else if (event is DeleteNotificationEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await accountDeleteNotificationUsecase(event.id);
        failureOrSuccess.fold((failure) {
          emit(ErrorMsgState(message: _mapFailureToMessage(failure)));
        }, (user) {
          emit(SuccessDeleteNotificationState(
              message: AppLocalizations.instance
                  .translate("MESSAGE_DELETED_SUCCESSFULLY")));
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
