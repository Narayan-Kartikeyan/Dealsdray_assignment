import 'dart:convert';
import 'dart:math';

import 'package:demo/Backend/ApiService.dart';
import 'package:demo/HomePage.dart';
import 'package:demo/models/User.dart';
import 'package:demo/verification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.userId});
  final String userId;
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Apiservice a = Apiservice();
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _mailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _referralcontroller = TextEditingController();

  Future<void> saveUsers(List<User> users) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList('users', jsonList);
  }

// Retrieve users from SharedPreferences
  Future<List<User>> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('users');

    if (jsonList != null) {
      return jsonList.map((json) => User.fromJson(jsonDecode(json))).toList();
    }

    return []; // Return an empty list if no users are found
  }

  Future<bool> checkAndAddUser(String userId) async {
    List<User> users = await getUsers();

    // Check if the user already exists
    for (var user in users) {
      if (user.userId == userId) {
        setState(() {
          
       user.isRegistered = true;
        });

      // Save updated list back to SharedPreferences
      await saveUsers(users);
      return true;// Return registration status if found
      }
    }

    // If not found, add the new user with isRegistered set to true
    User newUser = User(userId: userId, isRegistered: true);
    users.add(newUser);

    // Save updated list back to SharedPreferences
    await saveUsers(users);

    return true; // New user added with isRegistered as true
  }

  void _submit() async {
    final prefs = await SharedPreferences.getInstance();
    checkAndAddUser(widget.userId);
    if (_formkey.currentState!.validate()) {
      String email = _mailcontroller.text;
      String password = _passwordcontroller.text;
      String referral = _referralcontroller.text;
      await a.registerInfo(email, password, referral, widget.userId);
      prefs.setBool('isLoggedin', true);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DummyWidget()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://is2-ssl.mzstatic.com/image/thumb/Purple114/v4/b5/60/9b/b5609b14-e928-3f4d-0a34-6ead78a0ada4/source/512x512bb.jpg"))),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Text(
                "Let’s Get Started",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Text(
                "Share your info",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _mailcontroller,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Enter your mail address',
                        hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 14),
                        filled: true,
                        prefixIcon: const Icon(Icons.person),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        final RegExp emailRegExp = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address';
                        } else if (!emailRegExp.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordcontroller,
                      cursorColor: Theme.of(context).primaryColor,
                      obscureText: true,
                      style: GoogleFonts.poppins(fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        fillColor: Colors.white,
                        focusColor: Theme.of(context).primaryColor,
                        hoverColor: Theme.of(context).primaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Set a Password',
                        hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 14),
                        filled: true,
                        prefixIcon: const Icon(Icons.password_sharp),
                        suffixIcon: const Icon(Icons.visibility),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // Optionally add an error message if needed

                        // _controller.text.length != 10 ? 'Enter a valid number' : null,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        } else if (value.length < 8) {
                          return 'Password is too short';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                        controller: _referralcontroller,
                        cursorColor: Theme.of(context).primaryColor,
                        style: GoogleFonts.poppins(fontSize: 16),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          fillColor: Colors.white,
                          focusColor: Theme.of(context).primaryColor,
                          hoverColor: Theme.of(context).primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Enter Referral Code(Optional)',
                          hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 14),
                          filled: true,
                          prefixIcon: const Icon(Icons.numbers),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // Optionally add an error message if needed

                          // _controller.text.length != 10 ? 'Enter a valid number' : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          } else if (value.length < 8) {
                            return 'Referral code is too short';
                          }
                          return null;
                        }),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          elevation: 5,
          onPressed: _submit,
          backgroundColor: Theme.of(context).primaryColor,
          label: Row(
            children: [
              Text(
                "Continue",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_right,
              ),
            ],
          )),
    );
  }
}
