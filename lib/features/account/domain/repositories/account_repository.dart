import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_cafteria/features/account/domain/entities/notification.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AccountRepository {
  Future<Either<Failure, User>> login(String userOrEmail,String password,bool isEmail);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User>> loginAgain(String userOrEmail,String password,bool isEmail);
  Future<Either<Failure, User>> refresh(List<String> accessTokens);
  Future<Either<Failure, User>> checkLogin();
  Future<Either<Failure, Unit>> addChild(String name,String userName,String password,String email,String mobile,String classRoom, String division,String accessToken);
  Future<Either<Failure, Unit>> registerUser(String token);
  Future<Either<Failure, Unit>> changePassword(String oldPass,String newPass,String confirmPass,String accessToken);
  Future<Either<Failure, List<NotificationMassage>>> getNotifications(List<String> accessTokens);
  Future<Either<Failure, Unit>> readNotifications(List<String> accessTokens);
  Future<Either<Failure, Unit>> deleteNotification(int id);
  Future<Either<Failure, String>> editPhoto(XFile? image,List<String> accessTokens);
}