class AppInfo {
  final String version;
  final DateTime? installTimeStamp;
  final DateTime? uninstallTimeStamp;
  final DateTime? downloadTimeStamp;

  AppInfo({
    required this.version,
    required this.installTimeStamp,
    required this.uninstallTimeStamp,
    required this.downloadTimeStamp,
  });
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'installTimeStamp': installTimeStamp?.toIso8601String(),
      'uninstallTimeStamp': uninstallTimeStamp?.toIso8601String(),
      'downloadTimeStamp': downloadTimeStamp?.toIso8601String(),
    };
  }
}