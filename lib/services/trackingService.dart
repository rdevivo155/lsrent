import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class TrackingService {
  Future<String> initTracking() async {
    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
    return AppTrackingTransparency.getAdvertisingIdentifier();
  }
}