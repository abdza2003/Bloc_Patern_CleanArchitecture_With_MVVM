import 'package:school_cafteria/features/account/domain/entities/notification.dart';

class NotificationMassageModel extends NotificationMassage{
  NotificationMassageModel({super.id,
    super.title,
    super.body,
    super.type,
    super.status,
    super.schoolId,
    super.userId,
    super.createdAt,
    super.updatedAt,
    super.statusName,
    super.typeName});

  NotificationMassageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    status = json['status'];
    schoolId = json['school_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    statusName = json['status_name'];
    typeName = json['type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['type'] = type;
    data['status'] = status;
    data['school_id'] = schoolId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status_name'] = statusName;
    data['type_name'] = typeName;
    return data;
  }
}