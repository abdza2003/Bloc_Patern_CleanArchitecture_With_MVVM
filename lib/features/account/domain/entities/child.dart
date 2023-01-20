import 'package:equatable/equatable.dart';

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

   Child(
      { this.id,
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
       });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
