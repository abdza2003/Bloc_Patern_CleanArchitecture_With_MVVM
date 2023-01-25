import 'package:school_cafteria/features/account/data/models/child_model.dart';
import 'package:school_cafteria/features/account/data/models/school_model.dart';


class User {
  int? id;
  String? name;
  String? userName;
  String? email;
  String? image;
  String? mobile;
  String? schoolId;
  String? createdAt;
  String? updatedAt;
  String? uuid;
  String? accessToken;
  List<ChildModel>? childern;
  List<SchoolModel>? schools;
  SchoolModel? school;
  String? supervisorId;
  bool? addChildren;


  User({this.id,
    this.name,
    this.userName,
    this.email,
    this.image,
    this.mobile,
    this.schoolId,
    this.supervisorId,
    this.createdAt,
    this.updatedAt,
    this.uuid,
    this.accessToken,
    this.childern,
    this.school,
    this.schools,
    this.addChildren

  });
}
