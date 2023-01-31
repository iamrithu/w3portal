import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../api/api.dart';

class AttendenceScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> token;
  const AttendenceScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  ConsumerState<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends ConsumerState<AttendenceScreen> {
  List<dynamic> allTask = [];
  List<dynamic> task = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    API()
        .attendence(widget.token["token"],
            DateFormat("dd-MM-yyyy").format(selectedDate).toString())
        .then((value) {
      print(value.toString());
      if (value.statusCode != 200) {
        return print("error");
      }
      setState(() {
        task = value.data;
        allTask = task;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Future<void> _showAction() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "sort",
              style: GoogleFonts.ptSans(
                  color: Color.fromARGB(255, 27, 24, 73),
                  fontSize: width < 700 ? width / 24 : width / 45,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        setState(() {
                          task = [];
                        });
                        allTask.map((e) {
                          task.add(e);
                        }).toList();
                        Navigator.pop(context);
                      },
                      child: Text(("All"))),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        setState(() {
                          task = [];
                        });
                        allTask.map((e) {
                          e["clock_in_time"] ?? task.add(e);
                        }).toList();
                        Navigator.pop(context);
                      },
                      child: Text(("Absend"))),
                ],
              ),
            ),
          );
        },
      );
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
                            "Attendence Details (${DateFormat("dd-MM-yyy").format(selectedDate)})",
                            style: GoogleFonts.ptSans(
                                color: Color.fromARGB(255, 27, 24, 73),
                                fontSize: width < 700 ? width / 30 : width / 45,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0),
                          ),
                        ),
                        Container(
                          width: width * 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  ).then((value) {
                                    setState(() {
                                      selectedDate = value!;
                                      task = [];
                                      allTask = [];
                                    });
                                    API()
                                        .attendence(
                                            widget.token["token"],
                                            DateFormat("dd-MM-yyyy")
                                                .format(selectedDate)
                                                .toString())
                                        .then((value) {
                                      print(value.toString());
                                      if (value.statusCode != 200) {
                                        return print("error");
                                      }
                                      setState(() {
                                        task = value.data;
                                        allTask = task;
                                      });
                                    });
                                  });
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
                                        Icons.calendar_month,
                                        size: width < 700
                                            ? width / 24
                                            : width / 45,
                                        color: Color.fromARGB(255, 27, 24, 73),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _showAction();
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
                                        Icons.sort,
                                        size: width < 700
                                            ? width / 24
                                            : width / 45,
                                        color: Color.fromARGB(255, 27, 24, 73),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  width: width,
                  height: constraints.maxHeight * 0.92,
                  child: task.isEmpty
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
                      : Column(
                          children: [
                            Container(
                              width: width,
                              height: height * 0.05,
                              color: Colors.blue[50],
                              child: Row(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    child: Center(
                                      child: Text(
                                        "User",
                                        style: GoogleFonts.ptSans(
                                            color:
                                                Color.fromARGB(255, 27, 24, 73),
                                            fontSize: width < 700
                                                ? width / 38
                                                : width / 45,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.35,
                                    child: Text(
                                      "Name",
                                      style: GoogleFonts.ptSans(
                                          color:
                                              Color.fromARGB(255, 27, 24, 73),
                                          fontSize: width < 700
                                              ? width / 38
                                              : width / 45,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.35,
                                    child: Text(
                                      "Details",
                                      style: GoogleFonts.ptSans(
                                          color:
                                              Color.fromARGB(255, 27, 24, 73),
                                          fontSize: width < 700
                                              ? width / 38
                                              : width / 45,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.15,
                                    child: Text(
                                      "Status",
                                      style: GoogleFonts.ptSans(
                                          color:
                                              Color.fromARGB(255, 27, 24, 73),
                                          fontSize: width < 700
                                              ? width / 38
                                              : width / 45,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: ListView.builder(
                                    itemCount: task.length,
                                    itemBuilder: ((context, i) {
                                      return Container(
                                        width: width,
                                        height: height * 0.07,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: width * 0.15,
                                              child: Center(
                                                  child: CircleAvatar(
                                                maxRadius:
                                                    constraints.maxWidth * 0.04,
                                                backgroundImage: NetworkImage(
                                                    task[i]["image_url"]),
                                              )),
                                            ),
                                            Container(
                                              width: width * 0.35,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      task[i]["name"] ?? "--",
                                                      style: GoogleFonts.ptSans(
                                                          color: Color.fromARGB(
                                                              255, 27, 24, 73),
                                                          fontSize: width < 700
                                                              ? width / 38
                                                              : width / 45,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          letterSpacing: 0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            task[i]["clock_in_time"] == null
                                                ? Container(
                                                    width: width * 0.3,
                                                    child: Text("--"))
                                                : Container(
                                                    width: width * 0.3,
                                                    height: height * 0.06,
                                                    padding: EdgeInsets.only(
                                                        right: 2),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Clock In:",
                                                              style: GoogleFonts.ptSans(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: width <
                                                                          700
                                                                      ? width /
                                                                          38
                                                                      : width /
                                                                          45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  letterSpacing:
                                                                      0),
                                                            ),
                                                            Text(
                                                              "${DateTime.parse(
                                                                task[i][
                                                                    "clock_in_time"],
                                                              ).add(DateTime.parse(task[i]["clock_in_time"]).timeZoneOffset).hour}:${DateTime.parse(
                                                                task[i][
                                                                    "clock_in_time"],
                                                              ).add(DateTime.parse(task[i]["clock_in_time"]).timeZoneOffset).minute}:${DateTime.parse(
                                                                task[i][
                                                                    "clock_in_time"],
                                                              ).add(DateTime.parse(task[i]["clock_in_time"]).timeZoneOffset).second} ${DateTime.parse(
                                                                    task[i][
                                                                        "clock_in_time"],
                                                                  ).add(DateTime.parse(task[i]["clock_in_time"]).timeZoneOffset).hour < 12 ? "am" : "pm"}",
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
                                                                          38
                                                                      : width /
                                                                          45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  letterSpacing:
                                                                      0),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Clock Out:",
                                                              style: GoogleFonts.ptSans(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: width <
                                                                          700
                                                                      ? width /
                                                                          40
                                                                      : width /
                                                                          45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  letterSpacing:
                                                                      0),
                                                            ),
                                                            Text(
                                                              task[i]["clock_out_time"] ==
                                                                      null
                                                                  ? "--"
                                                                  : "${DateTime.parse(
                                                                        task[i][
                                                                            "clock_out_time"],
                                                                      ).add(DateTime.parse(task[i]["clock_out_time"]).timeZoneOffset).hour > 12 ? "${DateTime.parse(
                                                                        task[i][
                                                                            "clock_out_time"],
                                                                      ).add(DateTime.parse(task[i]["clock_out_time"]).timeZoneOffset).hour - 12}" : "${DateTime.parse(
                                                                      task[i][
                                                                          "clock_out_time"],
                                                                    ).add(DateTime.parse(task[i]["clock_out_time"]).timeZoneOffset).hour}"}:${DateTime.parse(
                                                                      task[i][
                                                                          "clock_out_time"],
                                                                    ).add(DateTime.parse(task[i]["clock_out_time"]).timeZoneOffset).minute}:${DateTime.parse(
                                                                      task[i][
                                                                          "clock_out_time"],
                                                                    ).add(DateTime.parse(task[i]["clock_out_time"]).timeZoneOffset).second} ${DateTime.parse(
                                                                        task[i][
                                                                            "clock_out_time"],
                                                                      ).add(DateTime.parse(task[i]["clock_out_time"]).timeZoneOffset).hour < 12 ? "am" : "pm"}",
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
                                                                          .w800,
                                                                  letterSpacing:
                                                                      0),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                            Container(
                                              width: width * 0.15,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Chip(
                                                      backgroundColor:
                                                          task[i]["clock_in_time"] ==
                                                                  null
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  239,
                                                                  193,
                                                                  190)
                                                              : Color.fromARGB(
                                                                  255,
                                                                  182,
                                                                  222,
                                                                  183),
                                                      label: Text(
                                                        task[i]["clock_in_time"] ==
                                                                null
                                                            ? "Absent"
                                                            : "Present",
                                                        style: GoogleFonts.ptSans(
                                                            color:
                                                                task[i]["clock_in_time"] ==
                                                                        null
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green,
                                                            fontSize: width <
                                                                    700
                                                                ? width / 38
                                                                : width / 45,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            letterSpacing: 0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      // return Stack(
                                      //   children: [
                                      //     Card(
                                      //         elevation: 1,
                                      //         shape: RoundedRectangleBorder(
                                      //           borderRadius: BorderRadius.circular(5),
                                      //         ),
                                      //         color: Color.fromARGB(255, 27, 24, 73),
                                      //         child: Container(
                                      //           width: constraints.maxWidth,
                                      //           height: constraints.maxHeight * 0.22,
                                      //         )),
                                      //     Row(
                                      //       mainAxisAlignment: MainAxisAlignment.end,
                                      //       children: [
                                      //         Card(
                                      //           elevation: 1,
                                      //           shape: RoundedRectangleBorder(
                                      //             borderRadius: BorderRadius.circular(5),
                                      //           ),
                                      //           child: Container(
                                      //               width: constraints.maxWidth * 0.97,
                                      //               height: constraints.maxHeight * 0.22,
                                      //               alignment: Alignment.center,
                                      //               child: Row(
                                      //                 children: [
                                      //                   Card(
                                      //                     child: Container(
                                      //                       width: constraints.maxWidth *
                                      //                           0.15,
                                      //                       height:
                                      //                           constraints.maxHeight *
                                      //                               0.22,
                                      //                       child: Column(
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment
                                      //                                 .spaceEvenly,
                                      //                         children: [
                                      //                           Center(
                                      //                               child: CircleAvatar(
                                      //                             maxRadius: constraints
                                      //                                     .maxWidth *
                                      //                                 0.07,
                                      //                             backgroundImage:
                                      //                                 NetworkImage(task[i]
                                      //                                     ["image_url"]),
                                      //                           )),
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                   Container(
                                      //                     width:
                                      //                         constraints.maxWidth * 0.77,
                                      //                     padding: EdgeInsets.only(
                                      //                         left: constraints.maxWidth *
                                      //                             0.05),
                                      //                     child: Column(
                                      //                       mainAxisAlignment:
                                      //                           MainAxisAlignment
                                      //                               .spaceEvenly,
                                      //                       children: [
                                      //                         Row(
                                      //                           children: [
                                      //                             Container(
                                      //                               width: constraints
                                      //                                       .maxWidth *
                                      //                                   0.2,
                                      //                               child: Text(
                                      //                                 "Name:",
                                      //                                 style: GoogleFonts.ptSans(
                                      //                                     color:
                                      //                                         Colors.grey,
                                      //                                     fontSize: width <
                                      //                                             700
                                      //                                         ? width / 38
                                      //                                         : width /
                                      //                                             45,
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .w500,
                                      //                                     letterSpacing:
                                      //                                         0),
                                      //                               ),
                                      //                             ),
                                      //                             Container(
                                      //                               width: constraints
                                      //                                       .maxWidth *
                                      //                                   0.5,
                                      //                               child: Row(
                                      //                                 children: [
                                      //                                   Flexible(
                                      //                                     child: Text(
                                      //                                       task[i]["name"] ??
                                      //                                           "--",
                                      //                                       style: GoogleFonts.ptSans(
                                      //                                           color: Color.fromARGB(
                                      //                                               255,
                                      //                                               27,
                                      //                                               24,
                                      //                                               73),
                                      //                                           fontSize: width < 700
                                      //                                               ? width /
                                      //                                                   38
                                      //                                               : width /
                                      //                                                   45,
                                      //                                           fontWeight:
                                      //                                               FontWeight
                                      //                                                   .w800,
                                      //                                           letterSpacing:
                                      //                                               0),
                                      //                                     ),
                                      //                                   ),
                                      //                                 ],
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                         Row(
                                      //                           children: [
                                      //                             Container(
                                      //                               width: constraints
                                      //                                       .maxWidth *
                                      //                                   0.2,
                                      //                               child: Text(
                                      //                                 "Email:",
                                      //                                 style: GoogleFonts.ptSans(
                                      //                                     color:
                                      //                                         Colors.grey,
                                      //                                     fontSize: width <
                                      //                                             700
                                      //                                         ? width / 38
                                      //                                         : width /
                                      //                                             45,
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .w500,
                                      //                                     letterSpacing:
                                      //                                         0),
                                      //                               ),
                                      //                             ),
                                      //                             Container(
                                      //                               width: constraints
                                      //                                       .maxWidth *
                                      //                                   0.5,
                                      //                               child: Row(
                                      //                                 children: [
                                      //                                   Flexible(
                                      //                                     child: Text(
                                      //                                       task[i]
                                      //                                           ["name"],
                                      //                                       style: GoogleFonts.ptSans(
                                      //                                           color: Color.fromARGB(
                                      //                                               255,
                                      //                                               27,
                                      //                                               24,
                                      //                                               73),
                                      //                                           fontSize: width < 700
                                      //                                               ? width /
                                      //                                                   38
                                      //                                               : width /
                                      //                                                   45,
                                      //                                           fontWeight:
                                      //                                               FontWeight
                                      //                                                   .w800,
                                      //                                           letterSpacing:
                                      //                                               0),
                                      //                                     ),
                                      //                                   ),
                                      //                                 ],
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                         Row(
                                      //                           children: [
                                      //                             Container(
                                      //                               width: constraints
                                      //                                       .maxWidth *
                                      //                                   0.2,
                                      //                               child: Text(
                                      //                                 "Mobile:",
                                      //                                 style: GoogleFonts.ptSans(
                                      //                                     color:
                                      //                                         Colors.grey,
                                      //                                     fontSize: width <
                                      //                                             700
                                      //                                         ? width / 38
                                      //                                         : width /
                                      //                                             45,
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .w500,
                                      //                                     letterSpacing:
                                      //                                         0),
                                      //                               ),
                                      //                             ),
                                      //                             Container(
                                      //                               width: constraints
                                      //                                       .maxWidth *
                                      //                                   0.5,
                                      //                               child: Row(
                                      //                                 children: [
                                      //                                   Flexible(
                                      //                                     child: Text(
                                      //                                       task[i]["mobile"] ??
                                      //                                           "--",
                                      //                                       style: GoogleFonts.ptSans(
                                      //                                           color: Color.fromARGB(
                                      //                                               255,
                                      //                                               27,
                                      //                                               24,
                                      //                                               73),
                                      //                                           fontSize: width < 700
                                      //                                               ? width /
                                      //                                                   38
                                      //                                               : width /
                                      //                                                   45,
                                      //                                           fontWeight:
                                      //                                               FontWeight
                                      //                                                   .w800,
                                      //                                           letterSpacing:
                                      //                                               0),
                                      //                                     ),
                                      //                                   ),
                                      //                                 ],
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                         Row(
                                      //                           children: [
                                      //                             Container(
                                      //                               width: constraints
                                      //                                       .maxWidth *
                                      //                                   0.2,
                                      //                               child: Text(
                                      //                                 "Status:",
                                      //                                 style: GoogleFonts.ptSans(
                                      //                                     color:
                                      //                                         Colors.grey,
                                      //                                     fontSize: width <
                                      //                                             700
                                      //                                         ? width / 38
                                      //                                         : width /
                                      //                                             45,
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .w500,
                                      //                                     letterSpacing:
                                      //                                         0),
                                      //                               ),
                                      //                             ),
                                      //                             Container(
                                      //                               width: constraints
                                      //                                       .maxWidth *
                                      //                                   0.5,
                                      //                               child: Row(
                                      //                                 children: [
                                      //                                   Flexible(
                                      //                                     child: Text(
                                      //                                       task[i]["clock_in_time"] ==
                                      //                                               null
                                      //                                           ? "Absend"
                                      //                                           : "Presend",
                                      //                                       style: GoogleFonts.ptSans(
                                      //                                           color: task[i]["clock_in_time"] ==
                                      //                                                   null
                                      //                                               ? Colors
                                      //                                                   .red
                                      //                                               : Colors
                                      //                                                   .green,
                                      //                                           fontSize: width <
                                      //                                                   700
                                      //                                               ? width /
                                      //                                                   38
                                      //                                               : width /
                                      //                                                   45,
                                      //                                           fontWeight:
                                      //                                               FontWeight
                                      //                                                   .w800,
                                      //                                           letterSpacing:
                                      //                                               0),
                                      //                                     ),
                                      //                                   ),
                                      //                                 ],
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                         if (task[i]
                                      //                                 ["clock_in_time"] !=
                                      //                             null)
                                      //                           Row(
                                      //                             children: [
                                      //                               Container(
                                      //                                 width: constraints
                                      //                                         .maxWidth *
                                      //                                     0.2,
                                      //                                 child: Text(
                                      //                                   "Clock In:",
                                      //                                   style: GoogleFonts.ptSans(
                                      //                                       color: Colors
                                      //                                           .grey,
                                      //                                       fontSize: width <
                                      //                                               700
                                      //                                           ? width /
                                      //                                               38
                                      //                                           : width /
                                      //                                               45,
                                      //                                       fontWeight:
                                      //                                           FontWeight
                                      //                                               .w500,
                                      //                                       letterSpacing:
                                      //                                           0),
                                      //                                 ),
                                      //                               ),
                                      //                               Container(
                                      //                                 width: constraints
                                      //                                         .maxWidth *
                                      //                                     0.5,
                                      //                                 child: Row(
                                      //                                   children: [
                                      //                                     Flexible(
                                      //                                       child: Text(
                                      //                                         "${DateTime.parse(
                                      //                                           task[i][
                                      //                                               "clock_in_time"],
                                      //                                         ).add(DateTime.parse(task[i]["clock_in_time"]).timeZoneOffset).hour}:${DateTime.parse(
                                      //                                           task[i][
                                      //                                               "clock_in_time"],
                                      //                                         ).add(DateTime.parse(task[i]["clock_in_time"]).timeZoneOffset).minute}:${DateTime.parse(
                                      //                                           task[i][
                                      //                                               "clock_in_time"],
                                      //                                         ).add(DateTime.parse(task[i]["clock_in_time"]).timeZoneOffset).second} ${DateTime.parse(
                                      //                                               task[i]
                                      //                                                   [
                                      //                                                   "clock_in_time"],
                                      //                                             ).add(DateTime.parse(task[i]["clock_in_time"]).timeZoneOffset).hour < 12 ? "am" : "pm"}",
                                      //                                         style: GoogleFonts.ptSans(
                                      //                                             color: Color.fromARGB(
                                      //                                                 255,
                                      //                                                 27,
                                      //                                                 24,
                                      //                                                 73),
                                      //                                             fontSize: width < 700
                                      //                                                 ? width /
                                      //                                                     38
                                      //                                                 : width /
                                      //                                                     45,
                                      //                                             fontWeight:
                                      //                                                 FontWeight
                                      //                                                     .w800,
                                      //                                             letterSpacing:
                                      //                                                 0),
                                      //                                       ),
                                      //                                     ),
                                      //                                   ],
                                      //                                 ),
                                      //                               ),
                                      //                             ],
                                      //                           ),
                                      //                       ],
                                      //                     ),
                                      //                   ),
                                      //                 ],
                                      //               )),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // );
                                    })),
                              ),
                            ),
                          ],
                        )),
            ]);
          }),
        ),
      ),
    );
  }
}
