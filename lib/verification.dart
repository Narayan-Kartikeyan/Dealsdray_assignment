import 'dart:convert';

import 'package:demo/Backend/ApiService.dart';
import 'package:demo/HomePage.dart';
import 'package:demo/models/User.dart';
import 'package:demo/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verification extends StatefulWidget {
  const Verification(
      {super.key,
      required this.number,
      required this.deviceId,
      required this.userId});

  final String number;
  final String deviceId;
  final String userId;
  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool _isLoading = false;
  Apiservice a = Apiservice();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  late List<dynamic> temp;

  void _submit() async {
    final prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String otp = _pinController.text;
      print(widget.deviceId);
      print(widget.userId);
      print(otp);
      temp = await a.verifyOTP(otp, widget.deviceId, widget.userId);
      if (temp[0] == "1") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Successfully verified mobile number!",
              style: GoogleFonts.poppins(color: Colors.white)),
          duration: Duration(seconds: 5),
          backgroundColor: Theme.of(context).primaryColor,
        ));
        if (temp[1] == "Incomplete") {
          if (await checkAndAddUser(widget.userId)) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DummyWidget()));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignupPage(userId: widget.userId)));
          }
        }
      } else if (temp[0] == "2") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Otp Timed out"),
          duration: Duration(seconds: 10),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid OTP!!"),
          duration: Duration(seconds: 10),
        ));
      }
    }
  }

  Future<bool> checkAndAddUser(String userId) async {
    List<User> users = await getUsers();

    for (var user in users) {
      if (user.userId == userId) {
        return user.isRegistered;
      }
    }
    return false;
  }

  Future<void> saveUsers(List<User> users) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList('users', jsonList);
  }

  Future<List<User>> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('users');

    if (jsonList != null) {
      return jsonList.map((json) => User.fromJson(jsonDecode(json))).toList();
    }

    return []; // Return an empty list if no users are found
  }

  void _resendOTP() async {
    if (_formKey.currentState!.validate()) {
      var output = await a.requestOTP(widget.number, widget.deviceId);
      print(output);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Otp Generated Successfully!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Lottie.network(
                  "https://lottie.host/c7169ee1-2130-424f-a342-bc7db2f7ab94/1n3qE9H30V.json",
                  animate: true,
                  fit: BoxFit.contain,
                  width: 350,
                  height: 300,
                ),
              ),
            ),
            Text(
              "OTP Verification!",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text.rich(
                textAlign: TextAlign.center,
                TextSpan(children: [
                  TextSpan(
                      text: "We have sent a unique OTP \n to your mobile",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )),
                  TextSpan(
                      text: "+91 ${widget.number}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      )),
                ])),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Pinput(
                controller: _pinController,
                length: 4,
                obscureText: true,
                onCompleted: (pin) {
                  print('Entered PIN: $pin');
                },
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                submittedPinTheme: PinTheme(
                  textStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter OTP';
                  } else if (value.length < 4) {
                    return "OTP must contain 4 digits";
                  }

                  return null; // Return null if the input is valid
                },
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Didn't receive a code? ",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                InkWell(
                  onTap: _resendOTP,
                  child: Text(
                    "Click to Resend",
                    style: GoogleFonts.poppins(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 3)
                    : Text(
                        "Verify OTP",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
