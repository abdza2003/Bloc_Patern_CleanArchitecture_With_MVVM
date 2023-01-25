import 'package:equatable/equatable.dart';
import 'package:school_cafteria/features/account/data/models/school_model.dart';
import 'package:school_cafteria/features/account/domain/entities/school.dart';

class Child extends Equatable {
  int? id;
  String? name;
  String? userName;
  String? email;
  String? image;
  String? mobile;
  String? isActive;
  String? schoolId;
  String? supervisorId;
  String? createdAt;
  String? updatedAt;
  String? parentId;
  String? uuid;
  int? balance;
  String? accessTokenParent;
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
      this.school});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
