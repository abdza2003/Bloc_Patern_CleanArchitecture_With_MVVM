import 'package:school_cafteria/features/balance/data/models/payment_model.dart';

class PaymentsView {
  List<PaymentModel>? userBalances;
  dynamic totalSpent;

  PaymentsView({this.userBalances, this.totalSpent});
}