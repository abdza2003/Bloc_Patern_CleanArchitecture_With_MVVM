class NotificationMassage {
  int? id;
  var title;
  var body;
  var type;
  var status;
  var schoolId;
  var userId;
  var createdAt;
  var updatedAt;
  var statusName;
  var typeName;

  NotificationMassage(
      {this.id,
      this.title,
      this.body,
      this.type,
      this.status,
      this.schoolId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.statusName,
      this.typeName});
}
