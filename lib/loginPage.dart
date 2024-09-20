import 'package:demo/Backend/ApiService.dart';
import 'package:demo/verification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late List<dynamic> list;
  Apiservice a = Apiservice();
  String output = "";
  late PageController _pageController;
  late TabController _tabController;
  late TabController _tabbarController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final prefs=SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    print(widget.deviceId);
    _pageController = PageController();
    _tabController = TabController(length: 3, vsync: this);
    _tabbarController = TabController(length: 2, vsync: this);

    // Syncing TabController index with PageView
    _pageController.addListener(() {
      _tabController.index = _pageController.page!.round();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    _tabbarController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String number = _controller.text;
      output = await a.requestOTP(number, widget.deviceId);
      print(output);
      print(widget.deviceId);
      

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Verification(
                    deviceId: widget.deviceId,
                    number: number,
                    userId: output,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Make the entire body scrollable
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 270, // Set a fixed height for PageView
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          child: Lottie.network(
                            'https://lottie.host/9c8b9b57-3adc-42c7-bbc8-c7653a3e7cea/4pxz7TPOWE.json',
                            width: 150,
                            height: 200,
                            fit: BoxFit.contain,
                            animate: true,
                          ),
                        ),
                        Text(
                          "Download the App & Register",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          child: Lottie.network(
                            'https://lottie.host/a085159c-4772-4add-8029-bfed5272d13d/MbMkTK7o1h.json',
                            width: 150,
                            height: 200,
                            fit: BoxFit.contain,
                            animate: true,
                          ),
                        ),
                        Text(
                          "Browse Products and Place Orders",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          child: Lottie.network(
                            'https://lottie.host/ccca5a2b-1318-4690-bfd1-9166dc423989/TYakSi9tDH.json',
                            width: 150,
                            height: 200,
                            fit: BoxFit.contain,
                            animate: true,
                          ),
                        ),
                        Text(
                          "Orders Delivered (Fast & Quick)",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ],
                ),
              ),
             Align(
                          alignment: AlignmentDirectional(0, 1),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                            child: smooth_page_indicator.SmoothPageIndicator(
                              controller: _pageController ??=
                                  PageController(initialPage: 0),
                              count: 3,
                              axisDirection: Axis.horizontal,
                              onDotClicked: (i) async {
                                await _pageController!.animateToPage(
                                  i,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.ease,
                                );
                                setState(() {});
                              },
                              effect: smooth_page_indicator.SlideEffect(
                                spacing: 8,
                                radius: 8,
                                dotWidth: 8,
                                dotHeight: 8,
                                dotColor:
                                    const Color.fromARGB(255, 200, 156, 208),
                                activeDotColor: Theme.of(context).primaryColor,
                                paintStyle: PaintingStyle.fill,
                              ),
                            ),
                          ),
                        ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 3, // Spread radius
                      blurRadius: 3, // Blur radius
                      // Position of the shadow
                    ),
                  ],
                ),
                // Add padding for better layout

                child: Column(
                  children: [
                    TabBar(
                      // Link TabBar with Tabbar Controller
                      indicator: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      indicatorColor: Theme.of(context).primaryColor,
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),

                      labelColor: Colors.white,
                      labelPadding: const EdgeInsets.all(0),
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      automaticIndicatorColorAdjustment: true,

                      controller: _tabbarController,
                      tabs: const [
                        Tab(text: "Phone"),
                        Tab(text: "Email"),
                      ],
                    ),
                    const SizedBox(
                        height:
                            10), // Optional spacing between TabBar and TabBarView
                    SizedBox(
                      // Wrap TabBarView in a Container with fixed height
                      height: MediaQuery.of(context).size.height *
                          0.4, // Set a fixed height for TabBarView
                      child: TabBarView(
                        controller:
                            _tabbarController, // Link TabBarView with Tabbar Controller
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome",
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Please sign in to continue",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                    "Enter your phone number to receive a verification code and gain instant access",
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 28),
                                Row(
                                  children: [
                                    // Leading country code
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: Text(
                                        '+91',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),

                                    // Space between country code and text field
                                    Expanded(
                                      child: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          controller: _controller,
                                          // controller: _controller,

                                          keyboardType: TextInputType.phone,

                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          // decoration: InputDecoration(
                                          //     enabledBorder: UnderlineInputBorder(
                                          //         borderSide: BorderSide(
                                          //             color: Theme.of(context)
                                          //                 .primaryColor)),
                                          //     border: UnderlineInputBorder(
                                          //         borderSide: BorderSide(
                                          //             style: BorderStyle.solid,
                                          //             color: Theme.of(context)
                                          //                 .primaryColor,
                                          //             strokeAlign: BorderSide
                                          //                 .strokeAlignCenter))),

                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 2),
                                            fillColor: Colors.white,
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                            hoverColor:
                                                Theme.of(context).primaryColor,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            hintText:
                                                'Enter your mobile number',
                                            hintStyle: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your number';
                                            } else if (value.length < 10) {
                                              return "Number must contain 10 digits";
                                            }else if (value.length > 10) {
                                              return "Number must contain 10 digits";
                                            }

                                            return null; // Return null if the input is valid
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: Text(
                                        "Request OTP",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Almost There!",
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Just a Quick Step Left to Log In!",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Text("Sign in using your email and password.",
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 38),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        // controller: _controller,
                                        cursorColor:
                                            Theme.of(context).primaryColor,

                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 2),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          hintText: 'Enter your mail address',
                                          hintStyle: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.person),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          // Optionally add an error message if needed

                                          // _controller.text.length != 10 ? 'Enter a valid number' : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const Verification()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: Text(
                                        "Request OTP",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
