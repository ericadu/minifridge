import 'package:minifridge_app/models/base_item.dart';

enum Freshness {
  not_ready,
  ready,
  in_range,
  past
}

extension FreshnessUtil on BaseItem {
  int getDays() {
    DateTime current = new DateTime.now();
    DateTime utcCurrent = new DateTime.utc(current.year, current.month, current.day);

    DateTime utcRangeStart = new DateTime.utc(rangeStartDate().year, rangeStartDate().month, rangeStartDate().day);
    return utcRangeStart.difference(utcCurrent).inDays;
  }

  int getLifeSoFar() {
    DateTime current = new DateTime.now();
    DateTime reference = referenceDatetime();
    DateTime utcCurrent = new DateTime.utc(current.year, current.month, current.day);
    DateTime utcReference = new DateTime.utc(reference.year, reference.month, reference.day);
    return utcCurrent.difference(utcReference).inDays;
  }

  int getDaysPast() {
    int lifeSoFar = getLifeSoFar();
    if (shelfLife.dayRangeEnd != null) {
      return lifeSoFar - shelfLife.dayRangeEnd.inDays;
    }

    return lifeSoFar - shelfLife.dayRangeStart.inDays;
  }

  DateTime expirationDate() {
    if (shelfLife.dayRangeEnd != null) { 
      return rangeEndDate();
    }

    return rangeStartDate();
  }

  Freshness getFreshness() {
    int lifeSoFar = getLifeSoFar();
    
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