import 'package:equatable/equatable.dart';

class School extends Equatable {
  int? id;
  String? name;
  String? countryId;
  String? createdAt;
  String? updatedAt;

   School({ this.id, this.name, this.countryId, this.createdAt, this.updatedAt});

  @override
  List<Object?> get props => [id,name,countryId,createdAt,updatedAt];
}
