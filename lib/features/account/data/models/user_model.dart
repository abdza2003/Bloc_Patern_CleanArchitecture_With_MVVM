import 'package:school_cafteria/features/account/data/models/child_model.dart';
import 'package:school_cafteria/features/account/data/models/school_model.dart';
import 'package:school_cafteria/features/account/domain/entities/user.dart';

class UserModel extends User {
  UserModel(
      {super.id,
      super.name,
      super.userName,
      super.email,
      super.image,
      super.mobile,
      super.schoolId,
      super.supervisorId,
      super.createdAt,
      super.updatedAt,
      super.accessToken,
      super.childern,
      super.schools,
      super.school,
      super.addChildren,
      super.roleId});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userName = json['user_name'];
    email = json['email'];
    image = json['image'];
    mobile = json['mobile'];
    schoolId = json['school_id'];
    supervisorId = json['supervisor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roleId = json['role_id'];
    uuid = json['uuid'];
    accessToken = json['accessToken'];
    if (json['childern'] != null) {
      childern = <ChildModel>[];
      json['childern'].forEach((v) {
        childern!.add(ChildModel.fromJson(v));
      });
    }
    if (json['schools'] != null) {
      schools = <SchoolModel>[];
      json['schools'].forEach((v) {
        schools!.add(SchoolModel.fromJson(v));
      });
    }
    school =
        json['school'] != null ? SchoolModel.fromJson(json['school']) : null;
    addChildren = json['add_children'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_name'] = userName;
    data['email'] = email;
    data['image'] = image;
    data['mobile'] = mobile;
    data['school_id'] = schoolId;
    data['supervisor_id'] = supervisorId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['uuid'] = uuid;
    data['role_id'] = roleId;
    data['accessToken'] = accessToken;
    data['add_children'] = addChildren;
    if (childern != null) {
      data['childern'] = childern!.map((v) => v.toJson()).toList();
    }
    if (schools != null) {
      data['schools'] = schools!.map((v) => v.toJson()).toList();
    }
    if (school != null) {
      data['school'] = school!.toJson();
    }
    return data;
  }
}
