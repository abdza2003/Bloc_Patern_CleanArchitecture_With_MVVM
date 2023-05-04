class Invoice {
  int? id;
  String? referenceCode;
  String? date;
  String? studentId;
  String? createdBy;
  String? schoolId;
  String? createdAt;
  String? updatedAt;
  dynamic? total;

  Invoice({this.id,
    this.referenceCode,
    this.date,
    this.studentId,
    this.createdBy,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.total});
}