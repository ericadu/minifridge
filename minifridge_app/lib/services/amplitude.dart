import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:quiver/strings.dart';

class AnalyticsService {
  final Amplitude analytics = Amplitude.getInstance(instanceName: "foodbase-mobile-dev");
  String _userId;

  AnalyticsService() {
    analytics.init('b8ec044b4d49005b07704fc9050fb680');
    // analytics.trackingSessionEvents(true);

    final Identify identify1 = Identify()
      ..set('identify_test',
          'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
      ..add('identify_count', 1);
    analytics.identify(identify1);
  }

  setUserId(String userId) {
    if (isEmpty(_userId)) {
      _userId = userId;
      analytics.setUserId(_userId);
    }
  }

  logEvent(String eventName, Map<String, String> eventProperties) {
    analytics.logEvent(eventName, eventProperties: eventProperties);
  }
}