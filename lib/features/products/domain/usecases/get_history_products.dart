import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/history.dart';
import '../../../../core/error/failures.dart';
import '../entities/invoices.dart';
import '../repositories/products_repository.dart';

class GetHistoryProductsUsecase {
  final ProductsRepository repository;

  GetHistoryProductsUsecase(this.repository);

  Future<Either<Failure, List<HistoryProduct>>> call(int invoiceId,String accessToken) async {
    return await repository.getHistoryProducts(invoiceId, accessToken);
  }
}