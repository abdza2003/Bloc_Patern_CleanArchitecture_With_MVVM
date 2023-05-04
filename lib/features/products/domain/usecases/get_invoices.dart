import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/invoices.dart';
import '../repositories/products_repository.dart';

class GetInvoicesUsecase {
  final ProductsRepository repository;

  GetInvoicesUsecase(this.repository);

  Future<Either<Failure, List<Invoice>>> call(int childId ,String accessToken,String? from,String? to) async {
    return await repository.getInvoices(childId,accessToken,from,to);
  }
}