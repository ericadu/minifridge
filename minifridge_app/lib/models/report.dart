class Report {
  String id;
  String reportedBy;
  String itemId;
  String baseId;
  String reason;

  Report({
    this.id,
    this.reportedBy,
    this.itemId,
    this.baseId,
    this.reason
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['reportedBy'] = this.reportedBy;
    data['itemId'] = this.itemId;
    data['baseId'] = this.baseId;
    data['reason'] = this.reason;
    return data;
  }
}