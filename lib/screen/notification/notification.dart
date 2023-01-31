import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../api/api.dart';
import '../../router/route-const.dart';
import '../home-screen/widget/custom-container.dart';

class NotificationScreen extends StatefulWidget {
  final Map<String, dynamic> token;
  const NotificationScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notification = [];
  @override
  void initState() {
    API().notification(widget.token["token"]).then((value) {
      if (value.statusCode != 200) {
        return print("error");
      }
      setState(() {
        notification = value.data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    String timeVatiation(value) {
      var currentDateTime = DateTime.now();
      var duration = (currentDateTime.difference(DateTime.parse(value)));
      int days = duration.inDays % 365.abs();
      int hours = duration.inHours % 24.abs();
      int mint = duration.inMinutes % 60.abs();

      String dateString;
      if (days == 0) {
        dateString = '$hours hrs $mint mins';
      } else {
        dateString = '$days days ${hours == 0 ? '' : '${hours}hrs'}  ago';
      }

      return dateString;
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(children: [
              Container(
                width: width,
                height: constraints.maxHeight * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            height: constraints.maxHeight * 0.05,
                            width: constraints.maxHeight * 0.05,
                            margin: EdgeInsets.only(left: 4),
                            alignment: Alignment.center,
                            child: Card(
                              elevation: 1,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back,
                                  size: width < 700 ? width / 24 : width / 45,
                                  color: Color.fromARGB(255, 27, 24, 73),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.55,
                          child: Text(
                            "Notifications",
                            style: GoogleFonts.ptSans(
                                color: Color.fromARGB(255, 27, 24, 73),
                                fontSize: width < 700 ? width / 30 : width / 45,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: constraints.maxHeight * 0.92,
                child: notification.isEmpty
                    ? Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 10,
                          child: Container(
                            width: width * 0.1,
                            height: width * 0.1,
                            alignment: Alignment.center,
                            child: LoadingAnimationWidget.twoRotatingArc(
                                color: Color.fromARGB(255, 27, 24, 73),
                                size: width * 0.07),
                          ),
                        ),
                      )
                    : ListView(
                        children: [
                          for (var i = 0; i < notification.length; i++)
                            Stack(
                              children: [
                                Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    color: Color.fromARGB(255, 27, 24, 73),
                                    child: Container(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight * 0.09,
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Container(
                                          width: constraints.maxWidth * 0.97,
                                          height: constraints.maxHeight * 0.09,
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: [
                                              Container(
                                                width:
                                                    constraints.maxWidth * 0.2,
                                                child: Center(
                                                    child: CircleAvatar(
                                                  maxRadius:
                                                      constraints.maxWidth *
                                                          0.04,
                                                  backgroundImage: NetworkImage(
                                                      notification[i]
                                                              ["image"] ??
                                                          ""),
                                                )),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    27,
                                                                    24,
                                                                    73)))),
                                                width:
                                                    constraints.maxWidth * 0.77,
                                                padding: EdgeInsets.only(
                                                    left: constraints.maxWidth *
                                                        0.05),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              notification[i][
                                                                      "text"] ??
                                                                  "its null",
                                                              style: GoogleFonts.ptSans(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          27,
                                                                          24,
                                                                          73),
                                                                  fontSize: width <
                                                                          700
                                                                      ? width /
                                                                          32
                                                                      : width /
                                                                          45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  letterSpacing:
                                                                      0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            notification[i][
                                                                    "typecase"] ??
                                                                "not working",
                                                            style: GoogleFonts.ptSans(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: width <
                                                                        700
                                                                    ? width / 35
                                                                    : width /
                                                                        45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                letterSpacing:
                                                                    0),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "${DateFormat("d-MMM-yyyy").format(DateTime.parse(notification[i]["updated_at"]))}",
                                                              style: GoogleFonts.ptSans(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: width <
                                                                          700
                                                                      ? width /
                                                                          38
                                                                      : width /
                                                                          45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  letterSpacing:
                                                                      0),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.1),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .blue[50],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Text(
                                                                timeVatiation(
                                                                    notification[
                                                                            i][
                                                                        "updated_at"]),
                                                                style: GoogleFonts.ptSans(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            27,
                                                                            24,
                                                                            73),
                                                                    fontSize: width <
                                                                            700
                                                                        ? width /
                                                                            40
                                                                        : width /
                                                                            45,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    letterSpacing:
                                                                        0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
              ),
            ]);
          }),
        ),
      ),
    );
  }
}
