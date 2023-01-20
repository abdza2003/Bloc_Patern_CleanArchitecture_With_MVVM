import 'package:school_cafteria/features/account/domain/entities/school.dart';

class SchoolModel extends School {
   SchoolModel({ super.id,
     super.name,
     super.countryId,
     super.createdAt,
     super.updatedAt});

   SchoolModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country_id'] = countryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
