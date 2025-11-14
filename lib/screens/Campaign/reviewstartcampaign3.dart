import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'error_boundary.dart';
import 'package:intl/intl.dart';
import '../../class/auth_service.dart';
import '../../class/jwt_helper.dart';
import 'reviewstartcampaign4.dart';

class Reviewstartcampaign3 extends StatefulWidget {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String amount;


  const Reviewstartcampaign3(
      {super.key, required this.title, required this.description, required this.startDate, required this.endDate, required this.amount});

  @override
  State<Reviewstartcampaign3> createState() => _ReviewStartCampaign3ScreenState();
}

class _ReviewStartCampaign3ScreenState extends State<Reviewstartcampaign3> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    String? token = await AuthService().getToken();
    if (token != null && !JWTHelper.isTokenExpired(token)) {
      Map<String, dynamic> userData = JWTHelper.decodeToken(token);
      setState(() => user = userData['user']);
      print("User ID: ${userData['user']}");
    } else {
      print("Token is expired or invalid");

    }
    // setState(() => user = res['user']);
  }


  @override
  Widget build(BuildContext context) {

     DateTime startsDate = DateFormat('dd/MM/yyyy').parse(widget.startDate);
     DateTime endsDate = DateFormat('dd/MM/yyyy').parse(widget.endDate);

    Duration difference = endsDate.difference(startsDate);
    int days = difference.inDays;
    print(days);
    int i = user!['id'];
    String id = i.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: ErrorBoundary(
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1.0)),
          child: SingleChildScrollView(
            child: ErrorBoundary(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 956.0,
                child: LayoutBuilder(
                  builder: (BuildContext context, constraints) => Stack(
                    children: [
                      //Offers
                      Positioned(
                        left: 333.0,
                        top: 320.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 42.0 + 10,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Offers",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0,

                                  decoration: TextDecoration.none,
                                  color: Color.fromRGBO(251, 251, 255, 1.0),
                                ),

                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ), //Starus
                      Positioned(
                        top: constraints.maxHeight * 0.016736401673640166,
                        left: 21.0,
                        child: ErrorBoundary(
                          child: ErrorBoundary(
                            child: Container(
                              decoration: BoxDecoration(),
                              child: ErrorBoundary(
                                child: SizedBox(
                                  width: 54.0,
                                  height:
                                      constraints.maxHeight *
                                      0.021966527196652718,
                                  child: LayoutBuilder(
                                    builder:
                                        (
                                          BuildContext context,
                                          constraints,
                                        ) => Stack(
                                          children: [
                                            //Time
                                            Positioned(
                                              top:
                                                  (constraints.maxHeight / 2) -
                                                  (21.0 / 2 - 3.0),
                                              left: 0.0,
                                              child: ErrorBoundary(
                                                child: SizedBox(
                                                  width:
                                                      constraints.maxWidth -
                                                      0.0 +
                                                      10,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: "9:4",
                                                        style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 13.0,

                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          color: Color.fromRGBO(
                                                            251,
                                                            251,
                                                            255,
                                                            1.0,
                                                          ),
                                                        ),

                                                        children: [
                                                          TextSpan(
                                                            text: "1",
                                                            style: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 13.0,

                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              color:
                                                                  Color.fromRGBO(
                                                                    251,
                                                                    251,
                                                                    255,
                                                                    1.0,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), //Building 1000 borehole for rural community
                      Positioned(
                        top: 332.0,
                        left: 16.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 276.0 + 2,
                            child: Text(
                              widget.title,
                              style: GoogleFonts.inter(
                                fontSize: 17.0,

                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(41, 47, 56, 1.0),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ), //Rectangle 59
                      Positioned(
                        top: 391.0,
                        left: (constraints.maxWidth / 2) - (440.0 / 2 - 16.0),
                        child: ErrorBoundary(
                          child: Container(
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.0),
                                topRight: Radius.circular(6.0),
                                bottomLeft: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0),
                              ),
                              color: Color.fromRGBO(
                                238,
                                240,
                                239,
                                0.8100000023841858,
                              ),
                            ),
                            width: 408.0,
                            height: 78.0,
                          ),
                        ),
                      ), //Organizer
                      Positioned(
                        top: 477.0,
                        left: 17.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 47.0 + 10,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Organizer",
                                style: GoogleFonts.inter(
                                  color: Color.fromRGBO(0, 0, 0, 1.0),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9.0,

                                  decoration: TextDecoration.none,
                                ),

                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ), //See All
                      Positioned(
                        left: 389.0,
                        top: 478.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 33.0 + 10,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "See All  ",
                                style: GoogleFonts.inter(
                                  color: Color.fromRGBO(0, 0, 0, 1.0),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9.0,

                                  decoration: TextDecoration.none,
                                ),

                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ), //Group 73
                      Positioned(
                        top: 421.0,
                        left: 22.0,
                        child: ErrorBoundary(
                          child: SvgPicture.asset(
                            "assets/images/group_73.svg",
                            width: 392.0,
                            height: 8.0,
                          ),
                        ),
                      ), //70%
                      Positioned(
                        top: 421.0,
                        left: 396.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 17.0 + 10,
                            child: Text(
                              "0% ",
                              style: GoogleFonts.inter(
                                color: Color.fromRGBO(0, 0, 0, 1.0),
                                fontWeight: FontWeight.w500,
                                fontSize: 7.0,

                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ), //₦347,000 raised of ₦4,000,000
                      Positioned(
                        left: 24.0,
                        top: 397.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 182.0 + 2,
                            child: RichText(
                              text: TextSpan(
                                text: "₦ 0 Raised of ",
                                style: GoogleFonts.inter(
                                  fontSize: 11.0,

                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(41, 47, 56, 1.0),
                                  decoration: TextDecoration.none,
                                ),

                                children: [
                                  TextSpan(
                                    text: widget.amount,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11.0,

                                      color: Color.fromRGBO(41, 47, 56, 1.0),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ), //12 Days left
                      Positioned(
                        left: 358.0,
                        top: 397.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 56.0 + 2,
                            child: Text(
                              ('$days Days left'),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 9.0,

                                color: Color.fromRGBO(41, 47, 56, 1.0),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ), //15 Champions
                      Positioned(
                        left: 162.0,
                        top: 441.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 83.0 + 10,
                            child: Text(
                              "0 Champions",
                              style: GoogleFonts.inter(
                                color: Color.fromRGBO(41, 47, 56, 0.8),
                                fontSize: 11.0,

                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ), //100 Donors
                      Positioned(
                        top: 439.0,
                        left: 44.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 67.0 + 10,
                            child: Text(
                              "0 Donors                ",
                              style: GoogleFonts.inter(
                                color: Color.fromRGBO(41, 47, 56, 0.8),
                                fontSize: 11.0,

                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ), //vuesax/linear/people
                      Positioned(
                        left: 22.0,
                        top: 441.0,
                        child: ErrorBoundary(
                          child: ErrorBoundary(
                            child: Container(decoration: BoxDecoration()),
                          ),
                        ),
                      ), //vuesax/linear/award
                      Positioned(
                        left: 140.0,
                        top: 441.0,
                        child: ErrorBoundary(
                          child: SvgPicture.asset(
                            "assets/images/vuesaxlinearaward.svg",
                            height: 18.0,
                            width: 18.0,
                          ),
                        ),
                      ), //vuesax/linear/timer
                      Positioned(
                        left: 339.0,
                        top: 398.0,
                        child: ErrorBoundary(
                          child: ErrorBoundary(
                            child: Container(decoration: BoxDecoration()),
                          ),
                        ),
                      ), //Rectangle 64
                      Positioned(
                        top: 605.0,
                        left: 18.0,
                        child: ErrorBoundary(
                          child: Container(
                            height: 134.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(241, 241, 247, 1.0),
                            ),
                            width: 402.0,
                          ),
                        ),
                      ), //Welcome to [Charity Name], where together we can make a difference! We are dedicated to empowering lives and creating positive change in our community. Whether you’re here to volunteer, donate, or spread the word, your support helps us provide essential resources to those in need. Thank you for joining us on this journey of compassion, hope, and transformation. Together, we can build a brighter future for all! and shelter to those facing hardship. Your involvement fuels our mission to create lasting impact, one life at a time. Together, we can transform challenges into opportunities, and inspire hope for a brighter, more
                      Positioned(
                        top: 610.0,
                        left: 27.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 386.0 + 2,
                            child: Text(
                              "Welcome to [Charity Name], where together we can make a difference! We are dedicated to empowering lives and creating positive change in our community. Whether you’re here to volunteer, donate, or spread the word, your support helps us provide essential resources to those in need. Thank you for joining us on this journey of compassion, hope, and transformation. Together, we can build a brighter future for all!  and shelter to those facing hardship. Your involvement fuels our mission to create lasting impact, one life at a time. Together, we can transform challenges into opportunities, and inspire hope for a brighter, more ",
                              style: GoogleFonts.inter(
                                fontSize: 10.0,

                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ), //Frame 15
                      Positioned(
                        top: 581.0,
                        left: 18.0,
                        child: ErrorBoundary(
                          child: Container(
                            decoration: BoxDecoration(),
                            child: ErrorBoundary(
                              child: SizedBox(
                                height: 25.0,
                                width: 402.0,
                                child: LayoutBuilder(
                                  builder:
                                      (
                                        BuildContext context,
                                        constraints,
                                      ) => Stack(
                                        children: [
                                          //Rectangle 56
                                          Positioned(
                                            left: 0.0,
                                            top: 0.0,
                                            child: ErrorBoundary(
                                              child: Container(
                                                clipBehavior: Clip.none,
                                                height: 25.0,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                    241,
                                                    241,
                                                    247,
                                                    1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                              6.0,
                                                            ),
                                                        topRight:
                                                            Radius.circular(
                                                              6.0,
                                                            ),
                                                        bottomLeft:
                                                            Radius.circular(
                                                              6.0,
                                                            ),
                                                        bottomRight:
                                                            Radius.circular(
                                                              6.0,
                                                            ),
                                                      ),
                                                ),
                                                width: 404.0,
                                              ),
                                            ),
                                          ), //ABOUT
                                          Positioned(
                                            top: 6.0,
                                            left: 3.0,
                                            child: ErrorBoundary(
                                              child: SizedBox(
                                                width: 36.0 + 10,
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    "ABOUT",
                                                    style: GoogleFonts.inter(
                                                      color: Color.fromRGBO(
                                                        41,
                                                        47,
                                                        56,
                                                        0.8,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 9.0,

                                                      decoration:
                                                          TextDecoration.none,
                                                    ),

                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ), //BUDJETING
                                          Positioned(
                                            left: 85.0,
                                            top: 6.0,
                                            child: ErrorBoundary(
                                              child: SizedBox(
                                                width: 57.0 + 10,
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    "BUDJETING",
                                                    style: GoogleFonts.inter(
                                                      color: Color.fromRGBO(
                                                        142,
                                                        150,
                                                        163,
                                                        0.7,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 9.0,

                                                      decoration:
                                                          TextDecoration.none,
                                                    ),

                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ), //OFFERS
                                          Positioned(
                                            top: 6.0,
                                            left: 192.0,
                                            child: ErrorBoundary(
                                              child: SizedBox(
                                                width: 39.0 + 10,
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    "OFFERS",
                                                    style: GoogleFonts.inter(
                                                      color: Color.fromRGBO(
                                                        142,
                                                        150,
                                                        163,
                                                        0.7,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 9.0,

                                                      decoration:
                                                          TextDecoration.none,
                                                    ),

                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ), //DONATIONS
                                          Positioned(
                                            left: 271.0,
                                            top: 6.0,
                                            child: ErrorBoundary(
                                              child: SizedBox(
                                                width: 60.0 + 10,
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    "DONATIONS",
                                                    style: GoogleFonts.inter(
                                                      color: Color.fromRGBO(
                                                        142,
                                                        150,
                                                        163,
                                                        0.7,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 9.0,

                                                      decoration:
                                                          TextDecoration.none,
                                                    ),

                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ), //COMMENTS
                                          Positioned(
                                            left: 359.0,
                                            top: 6.0,
                                            child: ErrorBoundary(
                                              child: SizedBox(
                                                width: 60.0 + 10,
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    "COMMENTS",
                                                    style: GoogleFonts.inter(
                                                      color: Color.fromRGBO(
                                                        142,
                                                        150,
                                                        163,
                                                        0.7,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 9.0,

                                                      decoration:
                                                          TextDecoration.none,
                                                    ),

                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ), //Rectangle 65
                                          Positioned(
                                            left: 0.0,
                                            top: 23.0,
                                            child: ErrorBoundary(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                    217,
                                                    217,
                                                    217,
                                                    1.0,
                                                  ),
                                                ),
                                                width: 62.0,
                                                height: 7.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), //Rectangle 66
                      Positioned(
                        left: 44.0,
                        top: 769.0,
                        child: ErrorBoundary(
                          child: Container(
                            height: 43.0,
                            clipBehavior: Clip.none,
                            width: 162.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(255, 83, 79, 1.0),
                                width: 1,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.0),
                                topRight: Radius.circular(6.0),
                                bottomLeft: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0),
                              ),
                            ),
                          ),
                        ),
                      ), //Group 139
                      Positioned(
                        left: 44.0,
                        top: 769.0,
                        child: ErrorBoundary(
                          child: SvgPicture.asset(
                            "assets/images/group_139.svg",
                            height: 43.0,
                            width: 162.0,
                          ),
                        ),
                      ), //CUSTOMISE
                      Positioned(
                        left: (constraints.maxWidth / 2) - (440.0 / 2 - 82.0),
                        top: 784.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 86.0 + 10,
                            child: Text(
                              "CUSTOMISE ",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,

                                color: Color.fromRGBO(252, 100, 58, 1.0),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ), //Rectangle 66
                      Positioned(
                        left: 234.0,
                        top: 769.0,
                        child: ErrorBoundary(
                          child: Container(
                            height: 43.0,
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.0),
                                topRight: Radius.circular(6.0),
                                bottomLeft: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0),
                              ),
                              border: Border.all(
                                color: Color.fromRGBO(34, 171, 225, 1.0),
                                width: 1,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                            ),
                            width: 162.0,
                          ),
                        ),
                      ), //Rectangle 67
                      Positioned(
                        left: 234.0,
                        top: 769.0,
                        child: ErrorBoundary(
                          child: Container(
                            height: 43.0,
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.0),
                                topRight: Radius.circular(6.0),
                                bottomLeft: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0),
                              ),
                              border: Border.all(
                                color: Color.fromRGBO(34, 171, 225, 1.0),
                                width: 1,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                            ),
                            width: 162.0,
                          ),
                        ),
                      ), //EDIT CAMPAIGN
                      Positioned(
                        top: (constraints.maxHeight / 2) - (956.0 / 2 - 784.0),
                        left: (constraints.maxWidth / 2) - (440.0 / 2 - 258.0),
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 114.0 + 10,
                            child: Text(
                              "EDIT CAMPAIGN",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,

                                decoration: TextDecoration.none,
                                color: Color.fromRGBO(34, 171, 225, 1.0),
                              ),
                            ),
                          ),
                        ),
                      ), //Frame 17
                      Positioned(
                        top: 491.0,
                        left: 17.0,
                        child: ErrorBoundary(
                          child: Container(
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(247, 247, 249, 1.0),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: ErrorBoundary(
                              child: SizedBox(
                                height: 73.0,
                                width: 404.0,
                                child: LayoutBuilder(
                                  builder: (BuildContext context, constraints) => Stack(
                                    children: [
                                      //Rectangle 47
                                      Positioned(
                                        top: 1.0,
                                        left: 3.0,
                                        child: ErrorBoundary(
                                          child: Container(
                                            width: 388.0,
                                            height: 60.0,
                                            clipBehavior: Clip.none,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                251,
                                                251,
                                                255,
                                                1.0,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                                bottomLeft: Radius.circular(
                                                  10.0,
                                                ),
                                                bottomRight: Radius.circular(
                                                  10.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ), //Ellipse 29
                                      Positioned(
                                        top: 7.0,
                                        left: 13.0,

                                          child: Image.asset(
                                            'assets/images/avatar.png',
                                            height: 48.69182586669922,
                                            width: 49.0,
                                          ),

                                      ), //DAN_BADAMOSI
                                      Positioned(
                                        top: 15.0,
                                        left: 71.0,
                                        child: ErrorBoundary(
                                          child: SizedBox(
                                            width: 120.0 + 10,
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                "${user!['first_name']} - ${user!['last_name']}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 10.0,

                                                  color: Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    1.0,
                                                  ),
                                                  fontWeight: FontWeight.w500,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),

                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ), //Donate for the people or Borno State, where flood destroys life, properties and split families
                                      Positioned(
                                        top: 30.849050521850586,
                                        left: 71.0,
                                        child: ErrorBoundary(
                                          child: SizedBox(
                                            width: 217.0 + 2,
                                            child: Text(
                                              widget.description,
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 8.0,

                                                color: Color.fromRGBO(
                                                  4,
                                                  17,
                                                  36,
                                                  0.5,
                                                ),
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ), //Rectangle 43
                                      Positioned(
                                        left: 305.0,
                                        top: 18.924522399902344,
                                        child: ErrorBoundary(
                                          child: Container(
                                            height: 27.82390022277832,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                                bottomLeft: Radius.circular(
                                                  20.0,
                                                ),
                                                bottomRight: Radius.circular(
                                                  20.0,
                                                ),
                                              ),
                                              color: Color.fromRGBO(
                                                238,
                                                240,
                                                239,
                                                0.8100000023841858,
                                              ),
                                            ),
                                            clipBehavior: Clip.none,
                                            width: 70.0,
                                          ),
                                        ),
                                      ), //Donate
                                      Positioned(
                                        left: 322.0,
                                        top: 24.886748790740967,
                                        child: ErrorBoundary(
                                          child: SizedBox(
                                            width: 35.0 + 10,
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                "Donate",
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 9.0,

                                                  color: Color.fromRGBO(
                                                    41,
                                                    47,
                                                    56,
                                                    1.0,
                                                  ),
                                                  decoration:
                                                      TextDecoration.none,
                                                ),

                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ), //Rectangle 71
                                      Positioned(
                                        top: 14.0,
                                        left: 399.0,
                                        child: ErrorBoundary(
                                          child: Container(
                                            width: 5.0,
                                            clipBehavior: Clip.none,
                                            height: 41.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                                bottomLeft: Radius.circular(
                                                  20.0,
                                                ),
                                                bottomRight: Radius.circular(
                                                  20.0,
                                                ),
                                              ),
                                              color: Color.fromRGBO(
                                                217,
                                                217,
                                                217,
                                                1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), //Union
                      Positioned(
                        left: 0.0,
                        top: 0.0,
                        child: ErrorBoundary(
                          child: SvgPicture.asset(
                            "assets/images/union_1.svg",
                            height: 321.357421875,
                            width: 440.0,
                          ),
                        ),
                      ), //arrow_back
                      Positioned(
                        top: constraints.maxHeight * 0.06276150627615062,
                        left: constraints.maxWidth * 0.03636363636363636,
                        child: ErrorBoundary(
                          child: ErrorBoundary(
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0.0,
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    blurRadius: 4.0,
                                    offset: Offset(0.0, 4.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ), //Frame 178
                      Positioned(
                        left: (constraints.maxWidth / 2) - (440.0 / 2 - 90.0),
                        top: 827.0,
                        child: ErrorBoundary(
                          child: Container(
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.0),
                                topRight: Radius.circular(6.0),
                                bottomLeft: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0),
                              ),
                              color: Color.fromRGBO(0, 164, 175, 1.0),
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: ErrorBoundary(
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 45.0,
                                    padding: EdgeInsets.all(10.0),
                                    width: 260.0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ErrorBoundary(
                                          child: //Group 141
                                          SizedBox(
                                            width: 168.0,
                                            height: 16.0,
                                            child: LayoutBuilder(
                                              builder:
                                                  (
                                                    BuildContext context,
                                                    constraints,
                                                  ) => Stack(
                                                    children: [
                                                      //SUBMIT FOR APPROVAL
                                                      Positioned(
                                                        top: 0.0,
                                                        left:
                                                            (constraints
                                                                    .maxWidth /
                                                                2) -
                                                            (168.0 / 2 - 0.0),
                                                        child: ErrorBoundary(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      Reviewstartcampaign4(title:widget.title,description:widget.description,startDate:widget.startDate,endDate:widget.endDate,amount:widget.amount, id: id),
                                                                ),
                                                              );
                                                            },
                                                          child: SizedBox(
                                                            width: 168.0 + 2,
                                                            child: Text(

                                                              "SUBMIT FOR APPROVAL",
                                                              style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 13.0,

                                                                color:
                                                                    Color.fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      1.0,
                                                                    ),
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), //Vector 33
                      Positioned(
                        left: 1.5,
                        top: 763.5,
                        child: ErrorBoundary(
                          child: SvgPicture.asset(
                            "assets/images/vector_33.svg",
                            width: 435.5,
                          ),
                        ),
                      ), //END OF CAMPAIGN
                      Positioned(
                        left: (constraints.maxWidth / 2) - (440.0 / 2 - 173.0),
                        top: 748.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 94.0 + 2,
                            child: Text(
                              "END OF CAMPAIGN",
                              style: GoogleFonts.inter(
                                color: Color.fromRGBO(142, 150, 163, 0.9),
                                fontWeight: FontWeight.w600,
                                fontSize: 9.0,

                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
