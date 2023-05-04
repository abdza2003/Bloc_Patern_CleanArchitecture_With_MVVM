import 'package:school_cafteria/features/products/domain/entities/invoices.dart';

class InvoiceModel extends Invoice
{
  InvoiceModel({super.id,
    super.referenceCode,
    super.date,
    super.studentId,
    super.createdBy,
    super.schoolId,
    super.createdAt,
    super.updatedAt,
    super.total});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referenceCode = json['reference_code'];
    date = json['date'];
    studentId = json['student_id'];
    createdBy = json['created_by'];
    schoolId = json['school_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['reference_code'] = referenceCode;
    data['date'] = date;
    data['student_id'] = studentId;
    data['created_by'] = createdBy;
    data['school_id'] = schoolId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total'] = total;
    return data;
  }
}