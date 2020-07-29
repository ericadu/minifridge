import 'package:minifridge_app/models/base_item.dart';

enum Freshness {
  not_ready,
  ready,
  fresh_min,
  fresh_max,
  in_range,
  in_range_start,
  in_range_min,
  in_range_max,
  in_range_end,
  past
}

extension FreshnessUtil on BaseItem {
  int getDays() {
    DateTime current = new DateTime.now();
    DateTime utcCurrent = new DateTime.utc(current.year, current.month, current.day);

    DateTime utcRangeStart = new DateTime.utc(rangeStartDate().year, rangeStartDate().month, rangeStartDate().day);
    return utcRangeStart.difference(utcCurrent).inDays;
  }

  Freshness getFreshness() {
    DateTime current = new DateTime.now();
    DateTime reference = referenceDatetime();
    DateTime utcCurrent = new DateTime.utc(current.year, current.month, current.day);
    DateTime utcReference = new DateTime.utc(reference.year, reference.month, reference.day);

    int lifeSoFar = utcCurrent.difference(utcReference).inDays;
    
    if (lifeSoFar < 0) {
      return Freshness.not_ready;
    }

    int freshnessTime = shelfLife.dayRangeStart.inDays;

    if (shelfLife.dayRangeEnd != null) {
      int expirationTime = shelfLife.dayRangeEnd.inDays;
      if (lifeSoFar > expirationTime) {
        return Freshness.past;
      }

      if (lifeSoFar <= expirationTime && lifeSoFar >= freshnessTime) {
        return Freshness.in_range;
      }

      if (lifeSoFar < freshnessTime) {
        return Freshness.ready;
      }
    }

    if (lifeSoFar > freshnessTime) {
      return Freshness.past; 
    }

    if (lifeSoFar == freshnessTime) {
      return Freshness.in_range;
    }

    return Freshness.ready;
  }
}