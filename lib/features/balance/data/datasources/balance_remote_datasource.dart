import '../../../../core/network/api.dart';
import '../../../../core/network/common_response.dart';

abstract class BalanceRemoteDataSource {
  Future<dynamic> addBalance(int childId,double balance,String accessToken);
  Future<dynamic> storeWeeklyBalance(int childId,double balance,String accessToken);
  Future<dynamic> getPayments(List<int> studentIds,String? from,String? to);
  Future<dynamic> cancelBalance(int requestId,String accessToken);

}
class BalanceRemoteDataSourceImpl implements BalanceRemoteDataSource
{
  @override
  Future addBalance(int childId, double balance, String accessToken) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance_value']=balance;
    data['student_id']=childId;
    return Network().postAuthData(data,"/student/add-cash-balance",accessToken).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future storeWeeklyBalance(int childId, double balance, String accessToken) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weekly_balance']=balance;
    data['student_id']=childId;
    return Network().postAuthData(data,"/student/store-weekly-balance",accessToken).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getPayments(List<int> studentIds,String? from,String? to) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['students_ids'] = studentIds.map((v) => v.toString()).toList();
    data['from']=from;
    data['to']=to;
    return Network().postAuthData(data,"/user/payments",null).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future cancelBalance(int requestId, String accessToken) {
    return Network().getAuthData("/user/cancel-balance/$requestId",accessToken).then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

}