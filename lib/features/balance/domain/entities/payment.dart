import 'package:school_cafteria/features/account/data/models/child_model.dart';

class Payment {
  int? id;
  dynamic balanceValue;
  dynamic status;
  dynamic type;
  dynamic refuseReason;
  dynamic userId;
  dynamic schoolId;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic statusName;
  bool? canDelete;
  dynamic typeName;
  ChildModel? child;

  Payment(
      {this.id,
      this.balanceValue,
      this.status,
      this.type,
      this.refuseReason,
      this.userId,
      this.schoolId,
      this.createdAt,
      this.updatedAt,
      this.statusName,
      this.canDelete,
      this.typeName,
      this.child});
}
