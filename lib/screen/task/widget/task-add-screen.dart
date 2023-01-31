import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../api/api.dart';
import '../../../provider/provider.dart';
import 'multi-select-participant.dart';

class TaskAddScreen extends ConsumerStatefulWidget {
  final Function onClick;
  const TaskAddScreen({
    Key? key,
    required this.onClick,
  }) : super(key: key);

  @override
  ConsumerState createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends ConsumerState<TaskAddScreen> {
  String? TaskCategory = "Choose Task Category";
  String? Project = "Choose Project";
  bool isChecked = false;
  bool isLoading = false;
  DateTime startDate = DateTime.now();
  DateTime dueDate = DateTime.now();
  final TextEditingController _task = TextEditingController();
  final TextEditingController _description = TextEditingController();
  List<Map<String, dynamic>> participants = [];
  Map<String, dynamic> projectDetails = {};
  Map<String, dynamic> categoryDetails = {};

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Future<void> _showTeskCategory(data) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  for (var i = 0; i < data.length; i++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          TaskCategory = data[i]["category_name"];
                          categoryDetails = data[i];
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: width,
                        height: height * 0.05,
                        color: Color.fromARGB(255, 232, 231, 231),
                        margin: EdgeInsets.only(bottom: 2),
                        child: Center(
                          child: Text(
                            "${data[i]["category_name"]}",
                            style: GoogleFonts.ptSans(
                                color: Color.fromARGB(255, 27, 24, 73),
                                fontSize: width < 700 ? width / 30 : width / 45,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      );
    }

    _itemChange(
      List<Map<String, dynamic>> data,
    ) {
      setState(() {
        participants = data;
      });
    }

    Future<void> _showParticipant(data) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return MultiSelectParticipant(
            participant: data,
            onClick: _itemChange,
            selectedList: participants,
          );
        },
      );
    }

    Future<void> _showProject(data) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  for (var i = 0; i < data.length; i++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          Project = data[i]["project_name"];
                          projectDetails = data[i];
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: width,
                        height: height * 0.05,
                        color: Color.fromARGB(255, 232, 231, 231),
                        margin: EdgeInsets.only(bottom: 2),
                        child: Center(
                          child: Text(
                            "${data[i]["project_name"]}",
                            style: GoogleFonts.ptSans(
                                color: Color.fromARGB(255, 27, 24, 73),
                                fontSize: width < 700 ? width / 30 : width / 45,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      );
    }

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color.fromARGB(255, 27, 24, 73);
      }
      return Color.fromARGB(255, 27, 24, 73);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.05),
          child: Stack(
            children: [
              Container(
                width: width,
                height: height,
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        " Add Task",
                        style: GoogleFonts.ptSans(
                            color: Color.fromARGB(255, 27, 24, 73),
                            fontSize: width < 700 ? width / 20 : width / 45,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0),
                      ),
                      Container(
                        width: width,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 4),
                                  child: Text(
                                    "Project",
                                    style: GoogleFonts.ptSans(
                                        color: Colors.black,
                                        fontSize: width < 700
                                            ? width / 30
                                            : width / 45,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: (() {
                                setState(() {
                                  isLoading = true;
                                });
                                API()
                                    .project(ref.watch(tokenProvider))
                                    .then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  _showProject(value.data);
                                });
                              }),
                              child: Container(
                                width: width * 0.9,
                                height: height * 0.065,
                                padding: EdgeInsets.only(left: 4),
                                margin: EdgeInsets.only(bottom: 4),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(
                                  "$Project",
                                  style: GoogleFonts.ptSans(
                                      color: Project == "Choose Project"
                                          ? Colors.grey
                                          : Color.fromARGB(255, 27, 24, 73),
                                      fontSize:
                                          width < 700 ? width / 30 : width / 45,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 4),
                                  child: Text(
                                    "Task Category",
                                    style: GoogleFonts.ptSans(
                                        color: Colors.black,
                                        fontSize: width < 700
                                            ? width / 30
                                            : width / 45,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: (() {
                                setState(() {
                                  isLoading = true;
                                });
                                API()
                                    .taskCategory(ref.watch(tokenProvider))
                                    .then((value) {
                                  _showTeskCategory(value.data);
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              }),
                              child: Container(
                                width: width * 0.9,
                                height: height * 0.065,
                                margin: EdgeInsets.only(bottom: 4),
                                padding: EdgeInsets.only(left: 4),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(
                                  "$TaskCategory",
                                  style: GoogleFonts.ptSans(
                                      color:
                                          TaskCategory == "Choose Task Category"
                                              ? Colors.grey
                                              : Color.fromARGB(255, 27, 24, 73),
                                      fontSize:
                                          width < 700 ? width / 30 : width / 45,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, left: 8.0, bottom: 4),
                                  child: Text(
                                    "Title",
                                    style: GoogleFonts.ptSans(
                                        color: Colors.black,
                                        fontSize: width < 700
                                            ? width / 30
                                            : width / 45,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: width * 0.9,
                              height: height * 0.065,
                              child: TextFormField(
                                controller: _task,
                                enableInteractiveSelection: true,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "Enter Title",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: OutlineInputBorder(),
                                  label: Text(
                                    "Title",
                                    style: GoogleFonts.ptSans(
                                        color: Colors.grey,
                                        fontSize: width < 700
                                            ? width / 30
                                            : width / 45,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 4, bottom: 4),
                                  child: Text(
                                    "Participants",
                                    style: GoogleFonts.ptSans(
                                        color: Colors.black,
                                        fontSize: width < 700
                                            ? width / 30
                                            : width / 45,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    color: Colors.blue[50],
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          API()
                                              .employees(
                                                  ref.watch(tokenProvider))
                                              .then((value) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            _showParticipant(value.data);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.blue,
                                        )),
                                  ),
                                )
                              ],
                            ),
                            if (participants.length > 0)
                              Wrap(
                                children: participants
                                    .map(
                                      (e) => Chip(
                                        avatar: CircleAvatar(
                                          child: Image.network(e["image_url"]),
                                        ),
                                        onDeleted: () {
                                          participants.removeWhere((element) =>
                                              element["name"] == e["name"]);

                                          setState(() {
                                            participants = participants;
                                          });
                                        },
                                        label: Text(
                                          e["name"],
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        elevation: 1,
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                    )
                                    .toList(),
                              ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 4),
                                  child: Text(
                                    "Start Date",
                                    style: GoogleFonts.ptSans(
                                        color: Colors.black,
                                        fontSize: width < 700
                                            ? width / 30
                                            : width / 45,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: (() {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                ).then((value) {
                                  setState(() {
                                    startDate = value!;
                                  });
                                });
                              }),
                              child: Container(
                                width: width * 0.9,
                                height: height * 0.065,
                                padding: EdgeInsets.only(left: 4),
                                margin: EdgeInsets.only(bottom: 4),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(
                                  "${DateFormat("dd-MM-yyyy").format(startDate)}",
                                  style: GoogleFonts.ptSans(
                                      color: Color.fromARGB(255, 27, 24, 73),
                                      fontSize:
                                          width < 700 ? width / 30 : width / 45,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                                Text(
                                  "Without Due Date ",
                                  style: GoogleFonts.ptSans(
                                      color: Color.fromARGB(255, 27, 24, 73),
                                      fontSize:
                                          width < 700 ? width / 30 : width / 45,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0),
                                ),
                              ],
                            ),
                            if (!isChecked)
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 4),
                                    child: Text(
                                      "Due Date",
                                      style: GoogleFonts.ptSans(
                                          color: Colors.black,
                                          fontSize: width < 700
                                              ? width / 30
                                              : width / 45,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0),
                                    ),
                                  ),
                                ],
                              ),
                            if (!isChecked)
                              InkWell(
                                onTap: (() {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  ).then((value) {
                                    setState(() {
                                      dueDate = value!;
                                    });
                                  });
                                }),
                                child: Container(
                                  width: width * 0.9,
                                  height: height * 0.065,
                                  padding: EdgeInsets.only(left: 4),
                                  margin: EdgeInsets.only(bottom: 4),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    "${DateFormat("dd-MM-yyyy").format(dueDate)}",
                                    style: GoogleFonts.ptSans(
                                        color: Color.fromARGB(255, 27, 24, 73),
                                        fontSize: width < 700
                                            ? width / 30
                                            : width / 45,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0),
                                  ),
                                ),
                              ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, left: 8.0, bottom: 4),
                                  child: Text(
                                    "Description",
                                    style: GoogleFonts.ptSans(
                                        color: Colors.black,
                                        fontSize: width < 700
                                            ? width / 30
                                            : width / 45,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: width * 0.9,
                              height: height * 0.065,
                              child: TextFormField(
                                controller: _description,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  label: Text(
                                    "Description",
                                    style: GoogleFonts.ptSans(
                                        color: Colors.grey,
                                        fontSize: width < 700
                                            ? width / 30
                                            : width / 45,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(width * 0.05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        minimumSize:
                                            Size(width * 0.41, height * 0.06),
                                        backgroundColor: Colors.red[50]),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: GoogleFonts.ptSans(
                                          color: Colors.red,
                                          fontSize: width < 700
                                              ? width / 30
                                              : width / 45,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        minimumSize:
                                            Size(width * 0.41, height * 0.06),
                                        backgroundColor: Colors.green[50]),
                                    onPressed: () {
                                      List<int> userList = [];
                                      participants
                                          .map((e) => userList.add(e["id"]))
                                          .toList();

                                      Map<String, dynamic> formData = {
                                        "heading": _task.text,
                                        "description": _description.text,
                                        "start_date": DateFormat("dd-MM-yyyy")
                                            .format(startDate)
                                            .toString(),
                                        "due_date": DateFormat("dd-MM-yyyy")
                                            .format(dueDate)
                                            .toString(),
                                        "without_duedate": isChecked ? 1 : "",
                                        "project_id": projectDetails["id"],
                                        "category_id": categoryDetails["id"],
                                        "user_id[]": userList
                                      };
                                      API()
                                          .addTask(ref.watch(tokenProvider),
                                              formData)
                                          .then((value) {
                                        widget.onClick();
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text(
                                      "Add",
                                      style: GoogleFonts.ptSans(
                                          color: Colors.green,
                                          fontSize: width < 700
                                              ? width / 30
                                              : width / 45,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0),
                                    ),
                                  )
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
              Visibility(
                visible: isLoading,
                child: Container(
                  color: Color.fromARGB(120, 250, 250, 250),
                  width: width,
                  height: height,
                  child: Center(
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
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
