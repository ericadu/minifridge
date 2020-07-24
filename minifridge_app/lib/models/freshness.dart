import 'package:minifridge_app/models/base_item.dart';

enum Freshness {
  not_ready,
  ready,
  fresh_min,
  fresh_max,
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
    double freshnessTimePart = freshnessTime > 2 ? freshnessTime / 5 : 0;

    // if (shelfLife.dayRangeEnd != null) {
      // Handle range case.
    if (shelfLife.dayRangeEnd != null) {
      int range = shelfLife.dayRangeEnd.inDays - shelfLife.dayRangeStart.inDays;
      int rangePart = range ~/ 4;
      int expirationTime = shelfLife.dayRangeEnd.inDays;

      if (lifeSoFar > expirationTime) {
        return Freshness.past;
      }

      if (lifeSoFar == expirationTime) {
        return Freshness.in_range_end;
      }

      if (lifeSoFar >= (expirationTime - rangePart) && lifeSoFar < expirationTime) {
        return Freshness.in_range_max;
      }

      if (lifeSoFar >= freshnessTime + rangePart && lifeSoFar < expirationTime - rangePart) {
        return Freshness.in_range_min;
      }

      if (lifeSoFar >= freshnessTime && lifeSoFar < freshnessTime + rangePart) {
        return Freshness.in_range_start;
      }
    } else {
      if (lifeSoFar + 1 == freshnessTime) {
        return Freshness.in_range_end;
      }
      
      if (lifeSoFar > freshnessTime) {
        return Freshness.past; 
      }
    }

    if (lifeSoFar >= freshnessTime - freshnessTimePart && lifeSoFar < freshnessTime) {
      return Freshness.fresh_max;
    }

    if (lifeSoFar >= freshnessTimePart && lifeSoFar < freshnessTime - freshnessTimePart) {
      return Freshness.fresh_min;
    }

    return Freshness.ready;
  }
}