import 'dart:async';
import 'dart:io';

import 'package:demo/Backend/ApiService.dart';
import 'package:demo/HomePage.dart';
import 'package:demo/loginPage.dart';
import 'package:demo/models/AppInfo.dart';
import 'package:demo/models/DeviceInfo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _storedString;
  Apiservice a = Apiservice();
  late DeviceInfo info;
  late AppInfo appInfo;
  var ipAddress = IpAddress(type: RequestType.json);
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _locationMessage = "";
  String deviceId = "";
  late bool Loggedin = false;

  @override
  void initState() {
    super.initState();

    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedin') ?? false;

    if (isLoggedIn) {
      Timer(Duration(seconds: 10), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const DummyWidget(),
          ),
        );
      });
    } else {
      _getCurrentLocation();
      getDeviceInfo();
      Timer(Duration(seconds: 10), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginPage(deviceId: deviceId),
          ),
        );
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

    // Check for location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }
//   Future<void> _checkFirstLaunch() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool b=await prefs.setBool('isLoggedin',false);
// setState(() {
//   Loggedin=b;
// });
//   }

  Future<String> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      dynamic data = await ipAddress.getIpAddress();
      appInfo = AppInfo(
          version: '1.0.0',
          downloadTimeStamp: DateTime.parse("2022-02-10T12:33:30.696Z"),
          installTimeStamp: DateTime.parse("2022-02-10T12:33:30.696Z"),
          uninstallTimeStamp: DateTime.parse("2022-02-10T12:33:30.696Z"));
      info = DeviceInfo(
          deviceType: 'android',
          deviceId: androidInfo.id,
          deviceName: androidInfo.device,
          deviceOSVersion: androidInfo.version.release,
          deviceIPAddress: data['ip'].toString(),
          lat: _latitude,
          long: _longitude,
          buyer_gcmid: await FirebaseMessaging.instance.getToken(),
          buyer_pemid: "",
          app: appInfo);

      var id = await a.addDevice(info);
      setState(() {
        deviceId = id;
      });
      return id;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://is2-ssl.mzstatic.com/image/thumb/Purple114/v4/b5/60/9b/b5609b14-e928-3f4d-0a34-6ead78a0ada4/source/512x512bb.jpg"))),
            ),
            SizedBox(height: 10),
            Text(
              "DealsDray",
              style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "The Best Deals, always.",
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            SizedBox(height: 110),
            SpinKitWave(
              color: Colors.white,
              size: 40,
              type: SpinKitWaveType.start,
            ),
          ],
        ),
      ),
    );
  }
}
