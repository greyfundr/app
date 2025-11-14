import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'error_boundary.dart';
import 'detailedcampaign.dart';

class Profilepublicviewrequest15 extends StatelessWidget {
  const Profilepublicviewrequest15({super.key});

  static final campaignController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Existing Campaign'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ErrorBoundary(
        child: Container(
          decoration: BoxDecoration(),
          child: ErrorBoundary(
            child: SizedBox(
              height: 499.0,
              width: MediaQuery.of(context).size.width,
              child: LayoutBuilder(
                builder: (BuildContext context, constraints) => Stack(
                  children: [
                    //Rectangle 131
                    Positioned(
                      top: 27.0,
                      left: 0.0,
                      child: ErrorBoundary(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(241, 241, 247, 1.0),
                          ),
                          height: 472.0,
                          width: 440.0,
                        ),
                      ),
                    ), //Decline this bill
                    Positioned(
                      top: 1886.0,
                      left: -3108.0,
                      child: ErrorBoundary(
                        child: SizedBox(
                          width: 111.0 + 2,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Decline this bill",
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
                    ), //Vector 29
                    Positioned(
                      top: 6.0,
                      left: 437.99609375,
                      child: ErrorBoundary(
                        child: Transform(
                          alignment: Alignment.topLeft,
                          transform: Matrix4.identity()
                            ..scale(-1.000000, 1.000000),
                          child: SvgPicture.asset(
                            "assets/images/vector_29.svg",
                            height: 22.35698890686035,
                            width: 437.9954528808594,
                          ),
                        ),
                      ),
                    ), //Rectangle 310
                    Positioned(
                      top: 19.0,
                      left: (constraints.maxWidth / 2) - (440.0 / 2 - 204.0),
                      child: ErrorBoundary(
                        child: GestureDetector(
                          onPanUpdate: (_) {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(
                                0,
                                164,
                                175,
                                0.20000000298023224,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100.0),
                                topRight: Radius.circular(100.0),
                                bottomLeft: Radius.circular(100.0),
                                bottomRight: Radius.circular(100.0),
                              ),
                            ),
                            width: 32.0,
                            clipBehavior: Clip.none,
                            height: 5.0,
                          ),
                        ),
                      ),
                    ), //Rectangle 68
                    Positioned(
                      top: 426.0,
                      left: 87.0,
                      child: ErrorBoundary(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(1, 121, 129, 1.0),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6.0),
                              topRight: Radius.circular(6.0),
                              bottomLeft: Radius.circular(6.0),
                              bottomRight: Radius.circular(6.0),
                            ),
                          ),
                          clipBehavior: Clip.none,
                          height: 50.0,
                          width: 265.0,
                        ),
                      ),
                    ), //NEXT
                    Positioned(
                      left: (constraints.maxWidth / 2) - (440.0 / 2 - 191.0),
                      top: (constraints.maxHeight / 2) - (499.0 / 2 - 440.0),
                      child: ErrorBoundary(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CampaignDetailPage(id: campaignController.text),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 168.0 + 2,
                            child: Text(

                              "SEARCH",
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
                    ), //Rectangle 111
                    Positioned(
                      left: 30.0,
                      top: 106.0,
                      child: ErrorBoundary(
                        child: Opacity(
                          opacity: 0.500000,
                          child: Container(
                            width: 378.0,
                            height: 237.0,
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 0.0,
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  blurRadius: 4.0,
                                  offset: Offset(0.0, 4.0),
                                ),
                              ],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                              ),
                              color: Color.fromRGBO(255, 255, 255, 1.0),
                            ),
                          ),
                        ),
                      ),
                    ), //Search Existing Campagne
                    Positioned(
                      left: 50.0,
                      top: 135.0,
                      child: ErrorBoundary(
                        child: SizedBox(
                          width: 260.0 + 2,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Search Existing Campaign",
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
                    ), //Group 652
                    Positioned(
                      top: 117.0,
                      left: 46.0,
                      child: ErrorBoundary(
                        child: SvgPicture.asset(
                          "assets/images/group_652.svg",
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                    ), //vuesax/linear/search-normal
                    Positioned(
                      left: 61.0,
                      top: 133.0,
                      child: ErrorBoundary(
                        child: ErrorBoundary(
                          child: Container(decoration: BoxDecoration()),
                        ),
                      ),
                    ), //Frame 182
                    Positioned(
                      left: 55.0,
                      top: 183.0,
                      child: ErrorBoundary(
                        child: Container(
                          decoration: BoxDecoration(),
                          child: ErrorBoundary(
                            child: SizedBox(
                              height: 18.0,
                              width: 194.0,
                              child: LayoutBuilder(
                                builder: (BuildContext context, constraints) => Stack(
                                  children: [
                                    //Frame 178
                                    Positioned(
                                      left: 0.0,
                                      top: 0.0,
                                      child: ErrorBoundary(
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          child: ErrorBoundary(
                                            child: Container(
                                              width: 186.0,
                                              height: 18.0,
                                              padding: EdgeInsets.all(1.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ErrorBoundary(
                                                    child: Container(
                                                      child: Align(
                                                        alignment:
                                                        Alignment.topCenter,
                                                        child: Text(
                                                          "Ongoing Campaign or Bill",
                                                          style: GoogleFonts.inter(
                                                            color:
                                                            Color.fromRGBO(
                                                              0,
                                                              0,
                                                              0,
                                                              1.0,
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
                    ), //Ellipse 69
                    Positioned(
                      top: 275.0,
                      left: 57.0,
                      child: ErrorBoundary(
                        child: SvgPicture.asset(
                          "assets/images/ellipse_69.svg",
                          height: 3.0,
                          width: 3.0,
                        ),
                      ),
                    ), //Ellipse 70
                    Positioned(
                      top: 292.0,
                      left: 57.0,
                      child: ErrorBoundary(
                        child: SvgPicture.asset(
                          "assets/images/ellipse_70.svg",
                          height: 3.0,
                          width: 3.0,
                        ),
                      ),
                    ), //Ellipse 71
                    Positioned(
                      top: 310.0,
                      left: 57.0,
                      child: ErrorBoundary(
                        child: SvgPicture.asset(
                          "assets/images/ellipse_71.svg",
                          height: 3.0,
                          width: 3.0,
                        ),
                      ),
                    ), //Football tournament
                    Positioned(
                      top: 272.0,
                      left: 65.0,
                      child: ErrorBoundary(
                        child: SizedBox(
                          width: 119.0 + 10,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Football tournament ",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.0,

                                color: Color.fromRGBO(53, 64, 82, 0.9),
                                decoration: TextDecoration.none,
                              ),

                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ), //Support fot the less privileged
                    Positioned(
                      left: 64.0,
                      top: 289.0,
                      child: ErrorBoundary(
                        child: SizedBox(
                          width: 178.0 + 2,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Support fot the less privileged",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.0,

                                color: Color.fromRGBO(53, 64, 82, 0.9),
                                decoration: TextDecoration.none,
                              ),

                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ), //Anita baker reunite with love basket
                    Positioned(
                      top: 306.0,
                      left: 63.0,
                      child: ErrorBoundary(
                        child: SizedBox(
                          width: 211.0 + 2,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Anita baker reunite with love basket",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.0,

                                color: Color.fromRGBO(53, 64, 82, 0.9),
                                decoration: TextDecoration.none,
                              ),

                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ), //Most Recent Liked
                    Positioned(
                      left: 61.0,
                      top: 253.0,
                      child: ErrorBoundary(
                        child: SizedBox(
                          width: 91.0 + 2,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Most Recent Liked",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(142, 150, 163, 0.9),
                                fontSize: 9.0,

                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ), //Vector 2
                    Positioned(
                      top: 422.0,
                      left: 47.5,
                      child: ErrorBoundary(
                        child: SvgPicture.asset(
                          "assets/images/vector_2.svg",
                          width: 336.5,
                        ),
                      ),
                    ), //Rectangle 182
                     //Enter title or tag
                    Positioned(
                      top: 200.0,
                      left: 50.0,
                      child: ErrorBoundary(
                        child: SizedBox(
                          width: 300,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child:
                            // Email / Phone
                            TextField(
                              controller: campaignController,
                              decoration: InputDecoration(
                                labelText: "Enter Campaign Tag or Title",
                                labelStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ), //vuesax/linear/search-normal
                    Positioned(
                      left: 63.0,
                      top: 215.0,
                      child: ErrorBoundary(
                        child: ErrorBoundary(
                          child: Container(decoration: BoxDecoration()),
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
    );
  }
}
