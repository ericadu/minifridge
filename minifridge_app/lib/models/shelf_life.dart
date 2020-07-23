import 'package:meta/meta.dart';

class ShelfLife {
  Duration dayRangeStart;
  Duration dayRangeEnd;

  ShelfLife({
    @required this.dayRangeStart,
    this.dayRangeEnd,
  });

  ShelfLife.fromMap(Map data) {
    dayRangeStart = Duration(days: data['dayRangeStart']);

    if (data['dayRangeEnd'] != null) {
      dayRangeEnd = Duration(days: data['dayRangeEnd']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dayRangeStart'] = this.dayRangeStart.inDays;

    if (this.dayRangeEnd != null) {
      data['dayRangeEnd'] = this.dayRangeEnd.inDays;
    }
    return data;
  }
}