import 'reviewstartcampaign6.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'error_boundary.dart';
import 'reviewstartcampaign6.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Reviewstartcampaign4 extends StatelessWidget {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String amount;
  final String id;

  const Reviewstartcampaign4({super.key, required this.title, required this.description, required this.startDate, required this.endDate, required this.amount, required this.id});


  @override
   Widget build(BuildContext context) {

    void _showErrorDialog(context,String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void login() async {
      final response = await http.post(
        Uri.parse('https://greyfoundr-backend.onrender.com/campaign/create'),
        body: {
          'title': title,
          'description': description,
          'startDate': startDate,
          'endDate': endDate,
          'amount': amount,
          'id': id,

        },
      );
      if (response.statusCode == 200) {
        // Handle successful login
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String message = responseData['msg'];
        String id = responseData['id'].toString();
        print(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Campaign Saved successful!'),
            duration: Duration(seconds: 2), // Optional: how long it shows
            backgroundColor: Colors.green, // Optional: customize color
          ),
        );
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => reviewstartcampaign6(id:title)),
          );
        });
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String message = responseData['msg'];
        print('Response from Node.js: $responseData');

        _showErrorDialog(context,message);


      }

    }

    return Scaffold(
        appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: ErrorBoundary(
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1.0)),
          child: SingleChildScrollView(
            child: Builder(
              builder: (BuildContext context) {
                Future.delayed(Duration(seconds: 3), () {

                 login();
                });
                return ErrorBoundary(
                  child: Builder(
                    builder: (BuildContext context) {

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 956.0,
                        child: LayoutBuilder(
                          builder: (BuildContext context, constraints) => Stack(
                            children: [
                              //Starus
                              Positioned(
                                top:
                                constraints.maxHeight *
                                    0.016736401673640166,
                                left: 21.0,
                                child: ErrorBoundary(
                                  child: ErrorBoundary(
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: ErrorBoundary(
                                        child: Container(
                                          width: 54.0,
                                          height:
                                          constraints.maxHeight *
                                              0.021966527196652718,
                                          child: LayoutBuilder(
                                            builder: (BuildContext context, constraints) => Stack(
                                              children: [
                                                //Time
                                                Positioned(
                                                  top:
                                                  (constraints.maxHeight /
                                                      2) -
                                                      (21.0 / 2 - 3.0),
                                                  left: 0.0,
                                                  child: ErrorBoundary(
                                                    child: Container(
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

                                                            children: [
                                                              TextSpan(
                                                                text: "1",
                                                                style: GoogleFonts.inter(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  fontSize:
                                                                  13.0,

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
                              ), //2. System Bar
                              Positioned(
                                top: 0.0,
                                left:
                                (constraints.maxWidth / 2) -
                                    (440.0 / 2 - 0.0),
                                child: ErrorBoundary(
                                  child: ErrorBoundary(
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: ErrorBoundary(
                                        child: Container(
                                          height: 53.0,
                                          width: 440.0,
                                          child: LayoutBuilder(
                                            builder: (BuildContext context, constraints) => Stack(
                                              children: [
                                                //Group
                                                Positioned(
                                                  left: 349.0,
                                                  top: 21.3306884765625,
                                                  child: ErrorBoundary(
                                                    child: SvgPicture.asset(
                                                      "assets/images/group_1.svg",
                                                      width: 66.66134643554688,
                                                      height: 11.3359956741333,
                                                    ),
                                                  ),
                                                ), //Starus
                                                Positioned(
                                                  left: 21.0,
                                                  top:
                                                  constraints.maxHeight *
                                                      0.3018867924528302,
                                                  child: ErrorBoundary(
                                                    child: ErrorBoundary(
                                                      child: Container(
                                                        decoration:
                                                        BoxDecoration(),
                                                        child: ErrorBoundary(
                                                          child: Container(
                                                            width: 54.0,
                                                            height:
                                                            constraints
                                                                .maxHeight *
                                                                0.39622641509433965,
                                                            child: LayoutBuilder(
                                                              builder:
                                                                  (
                                                                  BuildContext
                                                                  context,
                                                                  constraints,
                                                                  ) => Stack(
                                                                children: [
                                                                  //Time
                                                                  Positioned(
                                                                    top:
                                                                    (constraints.maxHeight /
                                                                        2) -
                                                                        (21.0 / 2 -
                                                                            3.0),
                                                                    left:
                                                                    0.0,
                                                                    child: ErrorBoundary(
                                                                      child: Container(
                                                                        width:
                                                                        constraints.maxWidth -
                                                                            0.0 +
                                                                            10,
                                                                        child: Align(
                                                                          alignment: Alignment.topCenter,
                                                                          child: RichText(
                                                                            textAlign: TextAlign.center,
                                                                            text: TextSpan(
                                                                              text: "9:4",
                                                                              style: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 13.0,

                                                                                color: Color.fromRGBO(
                                                                                  41,
                                                                                  47,
                                                                                  56,
                                                                                  1.0,
                                                                                ),
                                                                                decoration: TextDecoration.none,
                                                                              ),

                                                                              children: [
                                                                                TextSpan(
                                                                                  text: "1",
                                                                                  style: GoogleFonts.inter(
                                                                                    fontWeight: FontWeight.w400,
                                                                                    fontSize: 13.0,

                                                                                    color: Color.fromRGBO(
                                                                                      41,
                                                                                      47,
                                                                                      56,
                                                                                      1.0,
                                                                                    ),
                                                                                    decoration: TextDecoration.none,
                                                                                  ),
                                                                                ),
                                                                              ],
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
                              ), //Champion popo up
                              Positioned(
                                left: 0.0,
                                top: 399.0,
                                child: ErrorBoundary(
                                  child: Container(
                                    clipBehavior: Clip.none,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(0.0),
                                        bottomRight: Radius.circular(0.0),
                                      ),
                                    ),
                                    child: ErrorBoundary(
                                      child: Container(
                                        height: 523.0,
                                        width: 440.0,
                                        child: LayoutBuilder(
                                          builder: (BuildContext context, constraints) => Stack(
                                            children: [
                                              //Group 507
                                              Positioned(
                                                top: 26.0,
                                                left: 0.0,
                                                child: ErrorBoundary(
                                                  child: SvgPicture.asset(
                                                    "assets/images/group_507.svg",
                                                    height: 527.0,
                                                    width: 440.0,
                                                  ),
                                                ),
                                              ), //Rectangle 105
                                              Positioned(
                                                left: 24.0,
                                                top: 129.0,
                                                child: ErrorBoundary(
                                                  child: Opacity(
                                                    opacity: 0.500000,
                                                    child: Container(
                                                      width: 378.0,
                                                      clipBehavior: Clip.none,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          1.0,
                                                        ),
                                                        borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          topRight:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          bottomLeft:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          bottomRight:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                      height: 68.0,
                                                    ),
                                                  ),
                                                ),
                                              ), //Copy Link
                                              Positioned(
                                                top:
                                                (constraints.maxHeight /
                                                    2) -
                                                    (523.0 / 2 - 155.0),
                                                left:
                                                (constraints.maxWidth / 2) -
                                                    (440.0 / 2 - 91.0),
                                                child: ErrorBoundary(
                                                  child: Container(
                                                    width: 72.0 + 10,
                                                    child: Align(
                                                      alignment:
                                                      Alignment.topCenter,
                                                      child: Text(
                                                        "Copy Link",
                                                        style: GoogleFonts.inter(
                                                          color: Color.fromRGBO(
                                                            142,
                                                            150,
                                                            163,
                                                            0.9,
                                                          ),
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontSize: 14.0,

                                                          decoration:
                                                          TextDecoration
                                                              .none,
                                                        ),

                                                        textAlign:
                                                        TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ), //Ellipse 50
                                              Positioned(
                                                left: 32.0,
                                                top: 138.0,
                                                child: ErrorBoundary(
                                                  child: SvgPicture.asset(
                                                    "assets/images/ellipse_50.svg",
                                                    width: 51.0,
                                                    height: 51.0,
                                                  ),
                                                ),
                                              ), //vuesax/bold/copy
                                              Positioned(
                                                top: 151.0,
                                                left: 46.0,
                                                child: ErrorBoundary(
                                                  child: ErrorBoundary(
                                                    child: Container(
                                                      decoration:
                                                      BoxDecoration(),
                                                    ),
                                                  ),
                                                ),
                                              ), //Rectangle 107
                                              Positioned(
                                                top: 210.0001983642578,
                                                left: 25.0,
                                                child: ErrorBoundary(
                                                  child: Opacity(
                                                    opacity: 0.500000,
                                                    child: Container(
                                                      width: 378.0,
                                                      clipBehavior: Clip.none,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          1.0,
                                                        ),
                                                        borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          topRight:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          bottomLeft:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          bottomRight:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                      height: 68.0,
                                                    ),
                                                  ),
                                                ),
                                              ), //Send/Share and More
                                              Positioned(
                                                left: 92.0,
                                                top:
                                                (constraints.maxHeight /
                                                    2) -
                                                    (523.0 / 2 - 235.0),
                                                child: ErrorBoundary(
                                                  child: Container(
                                                    width: 157.0 + 2,
                                                    child: Align(
                                                      alignment:
                                                      Alignment.topCenter,
                                                      child: Text(
                                                        "Send/Share and More ",
                                                        style: GoogleFonts.inter(
                                                          color: Color.fromRGBO(
                                                            142,
                                                            150,
                                                            163,
                                                            0.9,
                                                          ),
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontSize: 14.0,

                                                          decoration:
                                                          TextDecoration
                                                              .none,
                                                        ),

                                                        textAlign:
                                                        TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ), //Ellipse 52
                                              Positioned(
                                                top: 219.0001983642578,
                                                left: 33.0,
                                                child: ErrorBoundary(
                                                  child: SvgPicture.asset(
                                                    "assets/images/ellipse_52.svg",
                                                    width: 51.0,
                                                    height: 51.0,
                                                  ),
                                                ),
                                              ), //Iconly/Light-Outline/Send
                                              Positioned(
                                                left:
                                                constraints.maxWidth *
                                                    0.10909090909090909,
                                                top:
                                                constraints.maxHeight *
                                                    0.3863938515774379,
                                                child: ErrorBoundary(
                                                  child: ErrorBoundary(
                                                    child: Container(
                                                      decoration:
                                                      BoxDecoration(),
                                                    ),
                                                  ),
                                                ),
                                              ), //vuesax/bold/share
                                              Positioned(
                                                left: 46.0,
                                                top: 233.0,
                                                child: ErrorBoundary(
                                                  child: ErrorBoundary(
                                                    child: Container(
                                                      decoration:
                                                      BoxDecoration(),
                                                    ),
                                                  ),
                                                ),
                                              ), //Rectangle 108
                                              Positioned(
                                                left: 25.0,
                                                top: 288.0,
                                                child: ErrorBoundary(
                                                  child: Opacity(
                                                    opacity: 0.500000,
                                                    child: Container(
                                                      width: 378.0,
                                                      clipBehavior: Clip.none,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          1.0,
                                                        ),
                                                        borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          topRight:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          bottomLeft:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          bottomRight:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                      height: 68.0,
                                                    ),
                                                  ),
                                                ),
                                              ), //Create Team
                                              Positioned(
                                                left: 92.0,
                                                top:
                                                (constraints.maxHeight /
                                                    2) -
                                                    (523.0 / 2 - 314.0),
                                                child: ErrorBoundary(
                                                  child: Container(
                                                    width: 93.0 + 10,
                                                    child: Align(
                                                      alignment:
                                                      Alignment.topCenter,
                                                      child: Text(
                                                        "Create Team",
                                                        style: GoogleFonts.inter(
                                                          color: Color.fromRGBO(
                                                            142,
                                                            150,
                                                            163,
                                                            0.9,
                                                          ),
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontSize: 14.0,

                                                          decoration:
                                                          TextDecoration
                                                              .none,
                                                        ),

                                                        textAlign:
                                                        TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ), //Ellipse 53
                                              Positioned(
                                                top: 297.0,
                                                left: 33.0,
                                                child: ErrorBoundary(
                                                  child: SvgPicture.asset(
                                                    "assets/images/ellipse_53.svg",
                                                    width: 51.0,
                                                    height: 51.0,
                                                  ),
                                                ),
                                              ), //vuesax/bold/people
                                              Positioned(
                                                top: 311.0,
                                                left: 46.0,
                                                child: ErrorBoundary(
                                                  child: SvgPicture.asset(
                                                    "assets/images/vuesaxboldpeople.svg",
                                                    width: 24.0,
                                                    height: 24.0,
                                                  ),
                                                ),
                                              ), //Rectangle 108
                                              Positioned(
                                                left: 26.0,
                                                top: 368.0,
                                                child: ErrorBoundary(
                                                  child: Opacity(
                                                    opacity: 0.500000,
                                                    child: Container(
                                                      width: 378.0,
                                                      clipBehavior: Clip.none,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          1.0,
                                                        ),
                                                        borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          topRight:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          bottomLeft:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                          bottomRight:
                                                          Radius.circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                      height: 68.0,
                                                    ),
                                                  ),
                                                ),
                                              ), //More Options
                                              Positioned(
                                                left: 92.0,
                                                top: 397.0,
                                                child: ErrorBoundary(
                                                  child: Container(
                                                    width: 99.0 + 10,
                                                    child: Align(
                                                      alignment:
                                                      Alignment.topCenter,
                                                      child: Text(
                                                        "More Options",
                                                        style: GoogleFonts.inter(
                                                          color: Color.fromRGBO(
                                                            142,
                                                            150,
                                                            163,
                                                            0.9,
                                                          ),
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontSize: 14.0,

                                                          decoration:
                                                          TextDecoration
                                                              .none,
                                                        ),

                                                        textAlign:
                                                        TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ), //Ellipse 53
                                              Positioned(
                                                left: 33.0,
                                                top: 377.0,
                                                child: ErrorBoundary(
                                                  child: SvgPicture.asset(
                                                    "assets/images/ellipse_53_1.svg",
                                                    width: 51.0,
                                                    height: 51.0,
                                                  ),
                                                ),
                                              ), //vuesax/bold/element-4
                                              Positioned(
                                                top: 391.0,
                                                left: 46.0,
                                                child: ErrorBoundary(
                                                  child: ErrorBoundary(
                                                    child: Container(
                                                      decoration:
                                                      BoxDecoration(),
                                                    ),
                                                  ),
                                                ),
                                              ), //Champion Your Campaign with Others
                                              Positioned(
                                                top: 59.0,
                                                left: 25.0,
                                                child: ErrorBoundary(
                                                  child: Container(
                                                    width: 252.0 + 2,
                                                    child: Text(
                                                      '''Champion Your Campaign
with Others''',
                                                      style: GoogleFonts.inter(
                                                        color: Color.fromRGBO(
                                                          0,
                                                          0,
                                                          0,
                                                          1.0,
                                                        ),
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontSize: 19.0,

                                                        decoration:
                                                        TextDecoration.none,
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
                              ), //Group
                              Positioned(
                                top: 78.0,
                                left: 180.0,
                                child: ErrorBoundary(
                                  child: SvgPicture.asset(
                                    "assets/images/group_2.svg",
                                    height: 79.33399963378906,
                                    width: 79.33399963378906,
                                  ),
                                ),
                              ), //Group
                              Positioned(
                                top: 374.0,
                                left: 41.0,
                                child: ErrorBoundary(
                                  child: SvgPicture.asset(
                                    "assets/images/group_3.svg",
                                    height: 20.0,
                                    width: 20.0,
                                  ),
                                ),
                              ), //Pending Approval
                              Positioned(
                                left:
                                (constraints.maxWidth / 2) -
                                    (440.0 / 2 - 134.0),
                                top: 171.0,
                                child: ErrorBoundary(
                                  child: Container(
                                    width: 171.0 + 10,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "Pending Approval",
                                        style: GoogleFonts.inter(
                                          color: Color.fromRGBO(0, 0, 0, 1.0),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 19.0,

                                          decoration: TextDecoration.none,
                                        ),

                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ), //vuesax/bold/verify
                              Positioned(
                                top: 244.0,
                                left: 39.0,
                                child: ErrorBoundary(
                                  child: ErrorBoundary(
                                    child: Container(
                                      decoration: BoxDecoration(),
                                    ),
                                  ),
                                ),
                              ), //vuesax/bold/verify
                              Positioned(
                                top: 286.0,
                                left: 39.0,
                                child: ErrorBoundary(
                                  child: ErrorBoundary(
                                    child: Container(
                                      decoration: BoxDecoration(),
                                    ),
                                  ),
                                ),
                              ), //Group
                              Positioned(
                                top: 329.0,
                                left: 41.0,
                                child: ErrorBoundary(
                                  child: SvgPicture.asset(
                                    "assets/images/group_4.svg",
                                    height: 20.0,
                                    width: 20.0,
                                  ),
                                ),
                              ), //Posted to your GreyFundr
                              Positioned(
                                top: 248.0,
                                left: 69.0,
                                child: ErrorBoundary(
                                  child: Container(
                                    width: 186.0 + 2,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "Posted to your GreyFundr ",
                                        style: GoogleFonts.inter(
                                          color: Color.fromRGBO(0, 0, 0, 1.0),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,

                                          decoration: TextDecoration.none,
                                        ),

                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ), //Shared with team for review
                              Positioned(
                                left: 75.0,
                                top: 290.0,
                                child: ErrorBoundary(
                                  child: Container(
                                    width: 204.0 + 2,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "Shared with team for review",
                                        style: GoogleFonts.inter(
                                          color: Color.fromRGBO(0, 0, 0, 1.0),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,

                                          decoration: TextDecoration.none,
                                        ),

                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ), //Pending approval from Stakeholder(s) 0/4
                              Positioned(
                                left: 75.0,
                                top: 330.0,
                                child: ErrorBoundary(
                                  child: Container(
                                    width: 305.0 + 2,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: RichText(
                                        text: TextSpan(
                                          text:
                                          "Pending approval from Stakeholder(s)",
                                          style: GoogleFonts.inter(
                                            color: Color.fromRGBO(0, 0, 0, 1.0),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,

                                            decoration: TextDecoration.none,
                                          ),

                                          children: [
                                            TextSpan(
                                              text: " 0/4",
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,

                                                decoration: TextDecoration.none,
                                                color: Color.fromRGBO(
                                                  34,
                                                  171,
                                                  225,
                                                  1.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ), //Awaiting approval from Greyfundr
                              Positioned(
                                left: 75.0,
                                top: 375.0,
                                child: ErrorBoundary(
                                  child: Container(
                                    width: 245.0 + 2,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "Awaiting approval from Greyfundr ",
                                        style: GoogleFonts.inter(
                                          color: Color.fromRGBO(0, 0, 0, 1.0),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,

                                          decoration: TextDecoration.none,
                                        ),

                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ), //Frame 178
                              Positioned(
                                top: 969.0,
                                left:
                                (constraints.maxWidth / 2) -
                                    (440.0 / 2 - 90.0),
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
                                      child: ErrorBoundary(
                                        child: InkWell(

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
                                                    height: 16.0,
                                                    width: 122.0,
                                                    child: LayoutBuilder(
                                                      builder:
                                                          (
                                                          BuildContext
                                                          context,
                                                          constraints,
                                                          ) => Stack(
                                                        children: [
                                                          //Back to Donation
                                                          Positioned(
                                                            top: 0.0,
                                                            left:
                                                            (constraints
                                                                .maxWidth /
                                                                2) -
                                                                (122.0 / 2 -
                                                                    0.0),
                                                            child: ErrorBoundary(
                                                              child: Container(
                                                                width:
                                                                122.0 +
                                                                    2,
                                                                child: Text(
                                                                  "Back to Donation",
                                                                  style: GoogleFonts.inter(
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                    fontSize:
                                                                    13.0,

                                                                    color: Color.fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      1.0,
                                                                    ),
                                                                    decoration:
                                                                    TextDecoration.none,
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
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
