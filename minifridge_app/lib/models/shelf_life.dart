class ShelfLife {
  bool perishable;
  Duration dayRangeStart;
  Duration dayRangeEnd;

  ShelfLife({
    this.perishable,
    this.dayRangeStart,
    this.dayRangeEnd,
  });

  ShelfLife.fromMap(Map data) {
    perishable = data['perishable'] ?? true;

    if (perishable) {
      dayRangeStart = Duration(days: data['dayRangeStart']);

      if (data['dayRangeEnd'] != null) {
        dayRangeEnd = Duration(days: data['dayRangeEnd']);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['perishable'] = this.perishable;

    if (this.perishable) {
      data['dayRangeStart'] = this.dayRangeStart.inDays;

      if (this.dayRangeEnd != null) {
        data['dayRangeEnd'] = this.dayRangeEnd.inDays;
      }
    }
    return data;
  }
}