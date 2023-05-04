import 'package:school_cafteria/features/balance/data/models/payment_model.dart';
import 'package:school_cafteria/features/balance/domain/entities/payments_view.dart';

class PaymentsViewModel extends PaymentsView
{
  PaymentsViewModel({super.userBalances, super.totalSpent});
  PaymentsViewModel.fromJson(Map<String, dynamic> json) {
    if (json['user_balances'] != null) {
      userBalances = <PaymentModel>[];
      json['user_balances'].forEach((v) {
        userBalances!.add(PaymentModel.fromJson(v));
      });
    }
    totalSpent = json['total_spent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userBalances != null) {
      data['user_balances'] =
          userBalances!.map((v) => v.toJson()).toList();
    }
    data['total_spent'] = totalSpent;
    return data;
  }
}