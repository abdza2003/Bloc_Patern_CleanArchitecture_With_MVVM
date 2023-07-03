class Invoice {
  int? id;
  dynamic referenceCode;
  dynamic date;
  dynamic studentId;
  dynamic createdBy;
  dynamic schoolId;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic? total;

  Invoice(
      {this.id,
      this.referenceCode,
      this.date,
      this.studentId,
      this.createdBy,
      this.schoolId,
      this.createdAt,
      this.updatedAt,
      this.total});
}
