import 'package:image_picker/image_picker.dart';

import '../entities/notification.dart';
import '../repositories/account_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AccountEditPhotoUsecase {
  final AccountRepository repository;

  AccountEditPhotoUsecase(this.repository);

  Future<Either<Failure, String>> call(XFile? image,List<String> accessTokens) async {
    return await repository.editPhoto(image, accessTokens);
  }
}
