import 'package:minifridge_app/models/base_item.dart';

enum Freshness {
  invalid,
  not_ready,
  ready,
  in_range,
  past,
}

extension FreshnessUtil on BaseItem {
  int get daysFromRangeStart {
    DateTime current = new DateTime.now();
    DateTime utcCurrent = new DateTime.utc(current.year, current.month, current.day);

    DateTime utcRangeStart = new DateTime.utc(rangeStartDate.year, rangeStartDate.month, rangeStartDate.day);
    return utcRangeStart.difference(utcCurrent).inDays;
  }

  int get lifeSoFar {
    DateTime current = new DateTime.now();
    DateTime reference = referenceDatetime;
    DateTime utcCurrent = new DateTime.utc(current.year, current.month, current.day);
    DateTime utcReference = new DateTime.utc(reference.year, reference.month, reference.day);
    return utcCurrent.difference(utcReference).inDays;
  }

  int get daysPast {
    if (shelfLife.dayRangeEnd != null) {
      return lifeSoFar - shelfLife.dayRangeEnd.inDays;
    }

    return lifeSoFar - shelfLife.dayRangeStart.inDays;
  }

  DateTime get expirationDate {
    if (shelfLife.dayRangeEnd != null) { 
      return rangeEndDate;
    }

    return rangeStartDate;
  }

  bool isValidFreshness() {
    return freshness != Freshness.invalid;
  }

  Freshness get freshness {    
    if (lifeSoFar < 0) {
      return Freshness.not_ready;
    }

    if (shelfLife.dayRangeStart == null) {
      return Freshness.invalid;
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

  String get freshnessMessage {
    String message;
    if (shelfLife.perishable) {
      switch(freshness) {
        case Freshness.invalid:
          message = "🙈  No info available.";
          break;
        case Freshness.in_range:
          message = "⏰ Eat me next";
          break;
        case Freshness.ready:      
          if (daysFromRangeStart == 1) {
            message = "⏳  1 day left";
          } else if (daysFromRangeStart > 7) {
            message = "💚​  Fresh AF";
          } else {
            message = "⏳  $daysFromRangeStart days left";
          }
          break;
        case Freshness.past:
          message = "😬  Caution";
          break;
        case Freshness.not_ready:
          message = "🐣  Not quite ready";
          break;
        default:
          message = "⏳  " + daysFromRangeStart.toString() + " days left";
      }
    } else {
      message = "🦄  Forever young";
    }

    return message;
  }

}