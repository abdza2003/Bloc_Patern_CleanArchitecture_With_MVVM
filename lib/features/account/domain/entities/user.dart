import 'package:school_cafteria/features/account/data/models/child_model.dart';
import 'package:school_cafteria/features/account/data/models/school_model.dart';

class User {
  int? id;
  var name;
  var userName;
  var email;
  var image;
  var mobile;
  var schoolId;
  var createdAt;
  var updatedAt;
  var uuid;
  var accessToken;
  var roleId;
  List<ChildModel>? childern;
  List<SchoolModel>? schools;
  SchoolModel? school;
  var supervisorId;
  bool? addChildren;

  User(
      {this.id,
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
      this.addChildren,
      this.roleId});
}
