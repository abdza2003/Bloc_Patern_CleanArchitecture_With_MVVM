import 'package:equatable/equatable.dart';

class School extends Equatable {
  int? id;
  var name;
  var countryId;
  var createdAt;
  var updatedAt;
  var accessToken;
  var currencyName;
  School(
      {this.id,
      this.name,
      this.countryId,
      this.createdAt,
      this.updatedAt,
      this.accessToken,
      this.currencyName});

  @override
  List<Object?> get props => [id, name, countryId, createdAt, updatedAt];
}
