import 'package:equatable/equatable.dart';
import 'package:school_cafteria/features/account/data/models/school_model.dart';
import 'package:school_cafteria/features/account/domain/entities/school.dart';

class Child extends Equatable {
  var id;
  var name;
  var userName;
  var email;
  var image;
  var mobile;
  var isActive;
  var schoolId;
  var supervisorId;
  var createdAt;
  var updatedAt;
  var parentId;
  var uuid;
  dynamic balance;
  dynamic weeklyBalance;
  var accessTokenParent;
  SchoolModel? school;

  Child(
      {this.id,
      this.name,
      this.userName,
      this.email,
      this.image,
      this.mobile,
      this.isActive,
      this.schoolId,
      this.supervisorId,
      this.createdAt,
      this.updatedAt,
      this.parentId,
      this.uuid,
      this.balance,
      this.school,
      this.accessTokenParent,
      this.weeklyBalance});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
