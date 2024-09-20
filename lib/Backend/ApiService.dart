import 'dart:convert';

import 'package:demo/models/DeviceInfo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Apiservice {
  String baseurl = "http://devapiv4.dealsdray.com/api/v2/user/";
  Future<String> addDevice(DeviceInfo info) async {
    var url = "${baseurl}device/add";
    try {
      print(info.toJson());
      final response =
          await http.post(Uri.parse(url), body: jsonEncode(info.toJson()));
      if (response.statusCode == 200) {
        print('Device added successfully');
        var jsonResponse = response.body;
        Map<String, dynamic> parsedJson = json.decode(jsonResponse);
        return parsedJson['data']['deviceId'];
      } else {
        print('Failed to send data: ${response.body}');
      }
    } catch (e) {
      print('error sending data: $e');
    }
    return '';
  }

  Future<String> requestOTP(String mobileNumber, String deviceId) async {
    var url = "${baseurl}otp";

    List<String> output = [];
    try {
      final response = await http.post(Uri.parse(url),
          body: {"mobileNumber": mobileNumber, "deviceId": deviceId});
      if (response.statusCode == 200) {
        print('Device added successfully');
        var jsonResponse = response.body;
        Map<String, dynamic> parsedJson = json.decode(jsonResponse);
        return parsedJson['data']['userId'];
      } else {
        print('Failed to send data: ${response.body}');
      }
    } catch (e) {
      print('error sending data: $e');
    }
    return '';
  }

  Future<List<dynamic>> verifyOTP(String otp, String deviceId, String userId) async {
    var url = "${baseurl}otp/verification";
    List<String> output = [];
    try {
      final response = await http.post(Uri.parse(url),
          body:
              {"otp": otp, "deviceId": deviceId, "userId": userId});
              print(otp);
              print(deviceId);
              print(userId);
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        Map<String, dynamic> parsedJson = json.decode(jsonResponse);
        print(parsedJson);
        output.add(parsedJson['status'].toString());
        output.add(parsedJson['data']['registration_status']);
        output.add(parsedJson['data']['message']);
        return output;

        // output.add(response.body.otp);
        // output.add(response.body.userId);
      } else {
        print('Failed to send data: ${response.body}');
      }
    } catch (e) {
      print('error sending data: $e');
    }
    return ['',''];
  }

  Future<void> registerInfo(
      String email, String password, String? referral, String userId) async {
    var url = "${baseurl}email/referral";
    try {
      final response = await http.post(Uri.parse(url),
          body: referral != null
              ? {
                  "email": email,
                  "password": password,
                  "referralCode": referral,
                  "userId": userId
                }
              : {"email": email, "password": password, "userId": userId});
      if (response.statusCode == 200) {
        print('User Registered successfully');
        print(response.body);
        // output.add(response.body.otp);
        // output.add(response.body.userId);
      } else if (response.statusCode == 409) {
        print('User already exists');
        print(response.body);
        // output.add(response.body.otp);
        // output.add(response.body.userId);
      } else {
        print('Failed to send data: ${response.body}');
      }
    } catch (e) {
      print('error sending data: $e');
    }
  }
}
