import 'package:image_picker/image_picker.dart';

import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AccountAddChildUsecase {
  final AccountRepository repository;

  AccountAddChildUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String name,String userName,String password,String email,String mobile,XFile? image,String accessToken) async {
    return await repository.addChild(name,userName,password,email,mobile,image,accessToken);
  }
}
