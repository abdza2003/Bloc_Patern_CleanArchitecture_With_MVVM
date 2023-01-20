import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/user_model.dart';
import '../entities/child.dart';
import '../entities/user.dart';

abstract class AccountRepository {
  //Future<Either<Failure, List<Post>>> getAllPosts();
  Future<Either<Failure, User>> login(String userOrEmail,String password);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User>> loginAgain(String userOrEmail,String password);
  Future<Either<Failure, User>> checkLogin();
  Future<Either<Failure, Unit>> addChild(Child child);
}