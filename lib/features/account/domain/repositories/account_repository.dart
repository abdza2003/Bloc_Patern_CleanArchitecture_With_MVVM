import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AccountRepository {
  Future<Either<Failure, User>> login(String userOrEmail,String password,bool isEmail);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User>> loginAgain(String userOrEmail,String password,bool isEmail);
  Future<Either<Failure, User>> checkLogin();
  Future<Either<Failure, Unit>> addChild(String name,String userName,String password,String email,String mobile,XFile? image,String accessToken);
}