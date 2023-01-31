import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:w3portal/screen/task/widget/task-add-screen.dart';

import '../../api/api.dart';

class TaskScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> token;
  const TaskScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  List<dynamic> allTask = [];
  List<dynamic> task = [];
  String? sorts = "All";
  String? TaskCategory = "Choose Task Category";
  @override
  void initState() {
    super.initState();
    API().task(widget.token["token"]).then((value) {
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

    reload() {
      setState(() {
        task = [];
        allTask = [];
      });
      API().task(widget.token["token"]).then((value) {
        if (value.statusCode != 200) {
          return print("error");
        }
        setState(() {
          task = value.data;
          allTask = task;
        });
      });
    }

    sorting(String? sort) {
      var newList = [];
      if (sort == "All") {
        setState(() {
          task = allTask;
        });
      } else {
        for (var i = 0; i < allTask.length; i++) {
          if (sort == allTask[i]["board_column"]["column_name"]) {
            setState(() {
              newList.add(allTask[i]);
            });
          }
        }
        setState(() {
          task = newList;
        });
      }
      setState(() {
        sorts = sort;
      });
    }

    Future<void> _shoeAction(Map<String, dynamic> data) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Task  : ${data["heading"]}",
              style: GoogleFonts.ptSans(
                  color: Color.fromARGB(255, 27, 24, 73),
                  fontSize: width < 700 ? width / 30 : width / 45,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(("Complete"))),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(("Incomplete")))
                ],
              ),
            ),
          );
        },
      );
    }

    Future<void> _showFilter() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Sorting",
              style: GoogleFonts.ptSans(
                  color: Color.fromARGB(255, 27, 24, 73),
                  fontSize: width < 700 ? width / 30 : width / 45,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      onPressed: () {
                        sorting("All");

                        Navigator.pop(context);
                      },
                      child: Text(("All"))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      onPressed: () {
                        sorting("Completed");
                        Navigator.pop(context);
                      },
                      child: Text(("Completed"))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      onPressed: () {
                        sorting("Incomplete");

                        Navigator.pop(context);
                      },
                      child: Text(("Incompleted")))
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(elevation: 10),
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: height,
                child: TaskAddScreen(
                  onClick: reload,
                ),
              );
            },
          );
        },
        child: Text(
          "Add Task",
          style: GoogleFonts.ptSans(
              color: Colors.white,
              fontSize: width < 700 ? width / 24 : width / 45,
              fontWeight: FontWeight.w500,
              letterSpacing: 0),
        ),
      ),
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
                            "Tasks",
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
                      : ListView.builder(
                          itemCount: task.length,
                          itemBuilder: ((context, i) {
                            return Stack(
                              children: [
                                Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    color: Color.fromARGB(255, 27, 24, 73),
                                    child: Container(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight * 0.22,
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
                                          height: constraints.maxHeight * 0.22,
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: [
                                              Container(
                                                width:
                                                    constraints.maxWidth * 0.2,
                                                height: constraints.maxHeight *
                                                    0.22,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Center(
                                                        child: CircleAvatar(
                                                      maxRadius:
                                                          constraints.maxWidth *
                                                              0.07,
                                                      backgroundImage:
                                                          NetworkImage(task[i]
                                                                  ["users"][0]
                                                              ["image_url"]),
                                                    )),
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     _shoeAction(task[i]);
                                                    //   },
                                                    //   child: Container(
                                                    //     width: constraints
                                                    //             .maxWidth *
                                                    //         0.15,
                                                    //     height: constraints
                                                    //             .maxHeight *
                                                    //         0.03,
                                                    //     decoration:
                                                    //         BoxDecoration(
                                                    //       border: Border.all(
                                                    //         color:
                                                    //             Color.fromARGB(
                                                    //                 255,
                                                    //                 27,
                                                    //                 24,
                                                    //                 73),
                                                    //       ),
                                                    //     ),
                                                    //     child: Center(
                                                    //       child: Text(
                                                    //         "Action",
                                                    //         style: GoogleFonts.ptSans(
                                                    //             color: Color
                                                    //                 .fromARGB(
                                                    //                     255,
                                                    //                     27,
                                                    //                     24,
                                                    //                     73),
                                                    //             fontSize:
                                                    //                 width <
                                                    //                         700
                                                    //                     ? width /
                                                    //                         40
                                                    //                     : width /
                                                    //                         45,
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .w500,
                                                    //             letterSpacing:
                                                    //                 0),
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(
                                                            color:
                                                                Colors.grey))),
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
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.17,
                                                          child: Text(
                                                            " Assigned To :",
                                                            style: GoogleFonts.ptSans(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: width <
                                                                        700
                                                                    ? width / 38
                                                                    : width /
                                                                        45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.5,
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  task[i]["users"]
                                                                              [
                                                                              0]
                                                                          [
                                                                          "name"] ??
                                                                      "null",
                                                                  style: GoogleFonts.ptSans(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          27,
                                                                          24,
                                                                          73),
                                                                      fontSize: width < 700
                                                                          ? width /
                                                                              38
                                                                          : width /
                                                                              45,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.17,
                                                          child: Text(
                                                            " Assigned By :",
                                                            style: GoogleFonts.ptSans(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: width <
                                                                        700
                                                                    ? width / 38
                                                                    : width /
                                                                        45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.5,
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  task[i]["created_by"] ??
                                                                      "null",
                                                                  style: GoogleFonts.ptSans(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          27,
                                                                          24,
                                                                          73),
                                                                      fontSize: width < 700
                                                                          ? width /
                                                                              38
                                                                          : width /
                                                                              45,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.17,
                                                          child: Text(
                                                            " Project:",
                                                            style: GoogleFonts.ptSans(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: width <
                                                                        700
                                                                    ? width / 38
                                                                    : width /
                                                                        45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.5,
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  task[i]["project_name"] ??
                                                                      "--",
                                                                  style: GoogleFonts.ptSans(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          27,
                                                                          24,
                                                                          73),
                                                                      fontSize: width < 700
                                                                          ? width /
                                                                              38
                                                                          : width /
                                                                              45,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.17,
                                                          child: Text(
                                                            " Task :",
                                                            style: GoogleFonts.ptSans(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: width <
                                                                        700
                                                                    ? width / 38
                                                                    : width /
                                                                        45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.5,
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  task[i]["heading"] ??
                                                                      "--",
                                                                  style: GoogleFonts.ptSans(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          27,
                                                                          24,
                                                                          73),
                                                                      fontSize: width < 700
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
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.17,
                                                          child: Text(
                                                            " Date :",
                                                            style: GoogleFonts.ptSans(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: width <
                                                                        700
                                                                    ? width / 38
                                                                    : width /
                                                                        45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.5,
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  task[i]["create_on"]
                                                                          .isEmpty
                                                                      ? "--"
                                                                      : task[i][
                                                                          "create_on"],
                                                                  style: GoogleFonts
                                                                      .ptSans(
                                                                          color: Color
                                                                              .fromARGB(
                                                                            255,
                                                                            27,
                                                                            24,
                                                                            73,
                                                                          ),
                                                                          fontSize: width < 700
                                                                              ? width /
                                                                                  38
                                                                              : width /
                                                                                  45,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          letterSpacing:
                                                                              0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.17,
                                                          child: Text(
                                                            " Due Date: ",
                                                            style: GoogleFonts.ptSans(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: width <
                                                                        700
                                                                    ? width / 38
                                                                    : width /
                                                                        45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.5,
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  task[i]["due_on"]
                                                                          .isEmpty
                                                                      ? "--"
                                                                      : task[i]["due_on"] ==
                                                                              "--"
                                                                          ? "--"
                                                                          : DateFormat("dd-MM-yyyy").parse(task[i]["due_on"]).year == DateTime.now().year && DateFormat("dd-MM-yyyy").parse(task[i]["due_on"]).month == DateTime.now().month && DateFormat("dd-MM-yyyy").parse(task[i]["due_on"]).day == DateTime.now().day
                                                                              ? "Today"
                                                                              : DateFormat("dd-MM-yyyy").parse(task[i]["due_on"]).isBefore(DateTime.now().toUtc())
                                                                                  ? task[i]["due_on"] + " (over due)"
                                                                                  : task[i]["due_on"],
                                                                  style: GoogleFonts.ptSans(
                                                                      color: task[i]["due_on"].isEmpty
                                                                          ? Color.fromARGB(255, 27, 24, 73)
                                                                          : task[i]["due_on"] == "--"
                                                                              ? Color.fromARGB(255, 27, 24, 73)
                                                                              : DateFormat("dd-MM-yyyy").parse(task[i]["due_on"]).year == DateTime.now().year && DateFormat("dd-MM-yyyy").parse(task[i]["due_on"]).month == DateTime.now().month && DateFormat("dd-MM-yyyy").parse(task[i]["due_on"]).day == DateTime.now().day
                                                                                  ? Color.fromARGB(255, 27, 24, 73)
                                                                                  : DateFormat("dd-MM-yyyy").parse(task[i]["due_on"]).isBefore(DateTime.now().toUtc())
                                                                                      ? Color.fromARGB(255, 238, 7, 7)
                                                                                      : Color.fromARGB(255, 5, 163, 21),
                                                                      fontSize: width < 700 ? width / 38 : width / 45,
                                                                      fontWeight: FontWeight.w600,
                                                                      letterSpacing: 0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.17,
                                                          child: Text(
                                                            " Status :",
                                                            style: GoogleFonts.ptSans(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: width <
                                                                        700
                                                                    ? width / 38
                                                                    : width /
                                                                        45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.5,
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  task[i]["board_column"]
                                                                          [
                                                                          "column_name"] ??
                                                                      "null",
                                                                  style: GoogleFonts.ptSans(
                                                                      color: task[i]["board_column"]["column_name"] ==
                                                                              "Completed"
                                                                          ? Color.fromARGB(
                                                                              255,
                                                                              21,
                                                                              132,
                                                                              34)
                                                                          : Color.fromARGB(
                                                                              255,
                                                                              232,
                                                                              11,
                                                                              11),
                                                                      fontSize: width <
                                                                              700
                                                                          ? width /
                                                                              38
                                                                          : width /
                                                                              45,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      letterSpacing:
                                                                          0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }))
                  // : ListView(
                  //     children: [
                  //       for (var i = 0; i < task.length; i++)
                  //         Stack(
                  //           children: [
                  //             Card(
                  //                 elevation: 10,
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(5),
                  //                 ),
                  //                 color: Color.fromARGB(255, 27, 24, 73),
                  //                 child: Container(
                  //                   width: constraints.maxWidth,
                  //                   height: constraints.maxHeight * 0.22,
                  //                 )),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.end,
                  //               children: [
                  //                 Card(
                  //                   elevation: 10,
                  //                   shape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(5),
                  //                   ),
                  //                   child: Container(
                  //                       width: constraints.maxWidth * 0.97,
                  //                       height: constraints.maxHeight * 0.22,
                  //                       alignment: Alignment.center,
                  //                       child: Row(
                  //                         children: [
                  //                           Container(
                  //                             width:
                  //                                 constraints.maxWidth * 0.2,
                  //                             height: constraints.maxHeight *
                  //                                 0.22,
                  //                             child: Column(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment
                  //                                       .spaceEvenly,
                  //                               children: [
                  //                                 Center(
                  //                                     child: CircleAvatar(
                  //                                   maxRadius:
                  //                                       constraints.maxWidth *
                  //                                           0.07,
                  //                                   backgroundImage:
                  //                                       NetworkImage(task[i]
                  //                                               ["users"][0]
                  //                                           ["image_url"]),
                  //                                 )),
                  //                                 Container(
                  //                                   width:
                  //                                       constraints.maxWidth *
                  //                                           0.15,
                  //                                   height: constraints
                  //                                           .maxHeight *
                  //                                       0.03,
                  //                                   child: ElevatedButton(
                  //                                     style: ElevatedButton.styleFrom(
                  //                                         elevation: 10,
                  //                                         backgroundColor:
                  //                                             Colors.white,
                  //                                         minimumSize: Size(
                  //                                             constraints
                  //                                                     .maxWidth *
                  //                                                 0.1,
                  //                                             constraints
                  //                                                     .maxHeight *
                  //                                                 0.05)),
                  //                                     onPressed: () {
                  //                                       _shoeAction(task[i]);
                  //                                     },
                  //                                     child: Text(
                  //                                       "Action",
                  //                                       style: GoogleFonts
                  //                                           .ptSans(
                  //                                               color: Color
                  //                                                   .fromARGB(
                  //                                                       255,
                  //                                                       27,
                  //                                                       24,
                  //                                                       73),
                  //                                               fontSize: width <
                  //                                                       700
                  //                                                   ? width /
                  //                                                       40
                  //                                                   : width /
                  //                                                       45,
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .w500,
                  //                                               letterSpacing:
                  //                                                   0),
                  //                                     ),
                  //                                   ),
                  //                                 )
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           Container(
                  //                             decoration: BoxDecoration(
                  //                                 border: Border(
                  //                                     left: BorderSide(
                  //                                         color:
                  //                                             Colors.grey))),
                  //                             width:
                  //                                 constraints.maxWidth * 0.77,
                  //                             padding: EdgeInsets.only(
                  //                                 left: constraints.maxWidth *
                  //                                     0.05),
                  //                             child: Column(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment
                  //                                       .spaceEvenly,
                  //                               children: [
                  //                                 Row(
                  //                                   children: [
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.17,
                  //                                       child: Text(
                  //                                         " Assigned To :",
                  //                                         style: GoogleFonts.ptSans(
                  //                                             color:
                  //                                                 Colors.grey,
                  //                                             fontSize: width <
                  //                                                     700
                  //                                                 ? width / 38
                  //                                                 : width /
                  //                                                     45,
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                             letterSpacing:
                  //                                                 0),
                  //                                       ),
                  //                                     ),
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.5,
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Flexible(
                  //                                             child: Text(
                  //                                               task[i]["users"]
                  //                                                           [
                  //                                                           0]
                  //                                                       [
                  //                                                       "name"] ??
                  //                                                   "null",
                  //                                               style: GoogleFonts.ptSans(
                  //                                                   color: Color.fromARGB(
                  //                                                       255,
                  //                                                       27,
                  //                                                       24,
                  //                                                       73),
                  //                                                   fontSize: width < 700
                  //                                                       ? width /
                  //                                                           38
                  //                                                       : width /
                  //                                                           45,
                  //                                                   fontWeight:
                  //                                                       FontWeight
                  //                                                           .w500,
                  //                                                   letterSpacing:
                  //                                                       0),
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.17,
                  //                                       child: Text(
                  //                                         " Assigned By :",
                  //                                         style: GoogleFonts.ptSans(
                  //                                             color:
                  //                                                 Colors.grey,
                  //                                             fontSize: width <
                  //                                                     700
                  //                                                 ? width / 38
                  //                                                 : width /
                  //                                                     45,
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                             letterSpacing:
                  //                                                 0),
                  //                                       ),
                  //                                     ),
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.5,
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Flexible(
                  //                                             child: Text(
                  //                                               task[i]["created_by"] ??
                  //                                                   "null",
                  //                                               style: GoogleFonts.ptSans(
                  //                                                   color: Color.fromARGB(
                  //                                                       255,
                  //                                                       27,
                  //                                                       24,
                  //                                                       73),
                  //                                                   fontSize: width < 700
                  //                                                       ? width /
                  //                                                           38
                  //                                                       : width /
                  //                                                           45,
                  //                                                   fontWeight:
                  //                                                       FontWeight
                  //                                                           .w500,
                  //                                                   letterSpacing:
                  //                                                       0),
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.17,
                  //                                       child: Text(
                  //                                         " Project:",
                  //                                         style: GoogleFonts.ptSans(
                  //                                             color:
                  //                                                 Colors.grey,
                  //                                             fontSize: width <
                  //                                                     700
                  //                                                 ? width / 38
                  //                                                 : width /
                  //                                                     45,
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                             letterSpacing:
                  //                                                 0),
                  //                                       ),
                  //                                     ),
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.5,
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Flexible(
                  //                                             child: Text(
                  //                                               task[i]["project_name"] ??
                  //                                                   "--",
                  //                                               style: GoogleFonts.ptSans(
                  //                                                   color: Color.fromARGB(
                  //                                                       255,
                  //                                                       27,
                  //                                                       24,
                  //                                                       73),
                  //                                                   fontSize: width < 700
                  //                                                       ? width /
                  //                                                           38
                  //                                                       : width /
                  //                                                           45,
                  //                                                   fontWeight:
                  //                                                       FontWeight
                  //                                                           .w500,
                  //                                                   letterSpacing:
                  //                                                       0),
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.17,
                  //                                       child: Text(
                  //                                         " Task :",
                  //                                         style: GoogleFonts.ptSans(
                  //                                             color:
                  //                                                 Colors.grey,
                  //                                             fontSize: width <
                  //                                                     700
                  //                                                 ? width / 38
                  //                                                 : width /
                  //                                                     45,
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                             letterSpacing:
                  //                                                 0),
                  //                                       ),
                  //                                     ),
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.5,
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Flexible(
                  //                                             child: Text(
                  //                                               task[i]["heading"] ??
                  //                                                   "--",
                  //                                               style: GoogleFonts.ptSans(
                  //                                                   color: Color.fromARGB(
                  //                                                       255,
                  //                                                       27,
                  //                                                       24,
                  //                                                       73),
                  //                                                   fontSize: width < 700
                  //                                                       ? width /
                  //                                                           38
                  //                                                       : width /
                  //                                                           45,
                  //                                                   fontWeight:
                  //                                                       FontWeight
                  //                                                           .w500,
                  //                                                   letterSpacing:
                  //                                                       0),
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.17,
                  //                                       child: Text(
                  //                                         " Date :",
                  //                                         style: GoogleFonts.ptSans(
                  //                                             color:
                  //                                                 Colors.grey,
                  //                                             fontSize: width <
                  //                                                     700
                  //                                                 ? width / 38
                  //                                                 : width /
                  //                                                     45,
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                             letterSpacing:
                  //                                                 0),
                  //                                       ),
                  //                                     ),
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.5,
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Flexible(
                  //                                             child: Text(
                  //                                               task[i]["users"]
                  //                                                           [
                  //                                                           0]
                  //                                                       [
                  //                                                       "name"] ??
                  //                                                   "null",
                  //                                               style: GoogleFonts
                  //                                                   .ptSans(
                  //                                                       color: Color
                  //                                                           .fromARGB(
                  //                                                         255,
                  //                                                         27,
                  //                                                         24,
                  //                                                         73,
                  //                                                       ),
                  //                                                       fontSize: width < 700
                  //                                                           ? width /
                  //                                                               38
                  //                                                           : width /
                  //                                                               45,
                  //                                                       fontWeight: FontWeight
                  //                                                           .w500,
                  //                                                       letterSpacing:
                  //                                                           0),
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.17,
                  //                                       child: Text(
                  //                                         " Due Date:",
                  //                                         style: GoogleFonts.ptSans(
                  //                                             color:
                  //                                                 Colors.grey,
                  //                                             fontSize: width <
                  //                                                     700
                  //                                                 ? width / 38
                  //                                                 : width /
                  //                                                     45,
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                             letterSpacing:
                  //                                                 0),
                  //                                       ),
                  //                                     ),
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.5,
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Flexible(
                  //                                             child: Text(
                  //                                               task[i]["due_on"] ??
                  //                                                   "no due date",
                  //                                               style: GoogleFonts.ptSans(
                  //                                                   color: Color.fromARGB(
                  //                                                       255,
                  //                                                       27,
                  //                                                       24,
                  //                                                       73),
                  //                                                   fontSize: width < 700
                  //                                                       ? width /
                  //                                                           38
                  //                                                       : width /
                  //                                                           45,
                  //                                                   fontWeight:
                  //                                                       FontWeight
                  //                                                           .w500,
                  //                                                   letterSpacing:
                  //                                                       0),
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.17,
                  //                                       child: Text(
                  //                                         " Status :",
                  //                                         style: GoogleFonts.ptSans(
                  //                                             color:
                  //                                                 Colors.grey,
                  //                                             fontSize: width <
                  //                                                     700
                  //                                                 ? width / 38
                  //                                                 : width /
                  //                                                     45,
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                             letterSpacing:
                  //                                                 0),
                  //                                       ),
                  //                                     ),
                  //                                     Container(
                  //                                       width: constraints
                  //                                               .maxWidth *
                  //                                           0.5,
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Flexible(
                  //                                             child: Text(
                  //                                               task[i]["board_column"]
                  //                                                       [
                  //                                                       "column_name"] ??
                  //                                                   "null",
                  //                                               style: GoogleFonts.ptSans(
                  //                                                   color: task[i]["board_column"]["column_name"] ==
                  //                                                           "Completed"
                  //                                                       ? Color.fromARGB(
                  //                                                           255,
                  //                                                           21,
                  //                                                           132,
                  //                                                           34)
                  //                                                       : Color.fromARGB(
                  //                                                           255,
                  //                                                           232,
                  //                                                           11,
                  //                                                           11),
                  //                                                   fontSize: width <
                  //                                                           700
                  //                                                       ? width /
                  //                                                           38
                  //                                                       : width /
                  //                                                           45,
                  //                                                   fontWeight:
                  //                                                       FontWeight
                  //                                                           .w500,
                  //                                                   letterSpacing:
                  //                                                       0),
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       )),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //     ],
                  //   ),
                  ),
            ]);
          }),
        ),
      ),
    );
  }
}
