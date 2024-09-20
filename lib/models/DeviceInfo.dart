import 'package:demo/models/AppInfo.dart';

class DeviceInfo {
  final String deviceType;
  final String deviceId;
  final String deviceName;
  final String deviceOSVersion;
  final String deviceIPAddress;
  final double? lat;
  final double? long;
  final String? buyer_gcmid;
  final String buyer_pemid;
  final AppInfo app;

  DeviceInfo({
    required this.deviceType,
    required this.deviceId,
    required this.deviceName,
    required this.deviceOSVersion,
    required this.deviceIPAddress,
    required this.lat,
    required this.long,
    required this.buyer_gcmid,
    required this.buyer_pemid,
    required this.app,
  });
    Map<String, dynamic> toJson() {
    return {
      'deviceType': deviceType,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceOSVersion': deviceOSVersion,
      'deviceIPAddress': deviceIPAddress,
      'lat': lat,
      'long': long,
      'buyer_gcmid': buyer_gcmid,
      'buyer_pemid':buyer_pemid,
      'app': app.toJson(), // Convert AppInfo to JSON
    };
    }

}