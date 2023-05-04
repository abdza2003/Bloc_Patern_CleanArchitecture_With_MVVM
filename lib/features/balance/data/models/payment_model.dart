import 'package:school_cafteria/features/account/data/models/child_model.dart';
import 'package:school_cafteria/features/balance/domain/entities/payment.dart';

class PaymentModel extends Payment
{
  PaymentModel(
      {
        super.id,
        super.balanceValue,
        super.status,
        super.type,
        super.refuseReason,
        super.userId,
        super.schoolId,
        super.createdAt,
        super.updatedAt,
        super.statusName,
        super.canDelete,
        super.typeName,
        super.child});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balanceValue = json['balance_value'];
    status = json['status'];
    type = json['type'];
    refuseReason = json['refuse_reason'];
    userId = json['user_id'];
    schoolId = json['school_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    statusName = json['status_name'];
    canDelete = json['can_delete'];
    typeName = json['type_name'];
    child = json['user'] != null ? ChildModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['balance_value'] = balanceValue;
    data['status'] = status;
    data['type'] = type;
    data['refuse_reason'] = refuseReason;
    data['user_id'] = userId;
    data['school_id'] = schoolId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status_name'] = statusName;
    data['can_delete'] = canDelete;
    data['type_name'] = typeName;
    if (child != null) {
      data['user'] = child!.toJson();
    }
    return data;
  }
}