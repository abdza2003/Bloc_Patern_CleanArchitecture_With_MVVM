import '../../../../core/network/api.dart';
import '../../../../core/network/common_response.dart';

abstract class BalanceRemoteDataSource {
  Future<dynamic> addBalance(int childId,double balance,String accessToken);
  Future<dynamic> storeWeeklyBalance(int childId,double balance,String accessToken);

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

}