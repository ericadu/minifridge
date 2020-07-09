import 'package:meta/meta.dart';

class ShelfLife {
  Duration dayRangeStart;
  Duration dayRangeEnd;

  ShelfLife({
    @required this.dayRangeStart,
    @required this.dayRangeEnd,
  });

  ShelfLife.fromMap(Map data) {
    dayRangeStart = Duration(days: data['dayRangeStart']);
    dayRangeEnd = Duration(days: data['dayRangeEnd']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dayRangeStart'] = this.dayRangeStart.inDays;
    data['dayRangeEnd'] = this.dayRangeEnd.inDays;
    return data;
  }
}