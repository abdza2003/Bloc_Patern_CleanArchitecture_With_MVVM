import 'package:school_cafteria/features/account/data/models/child_model.dart';

class Payment {
  int? id;
  String? balanceValue;
  String? status;
  String? type;
  String? refuseReason;
  String? userId;
  String? schoolId;
  String? createdAt;
  String? updatedAt;
  String? statusName;
  bool? canDelete;
  String? typeName;
  ChildModel? child;

  Payment({this.id,
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