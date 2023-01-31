import 'package:flutter/material.dart';

class MultiSelectParticipant extends StatefulWidget {
  final dynamic participant;
  final Function onClick;
  final List<Map<String, dynamic>> selectedList;

  MultiSelectParticipant(
      {Key? key,
      this.participant,
      required this.onClick,
      required this.selectedList})
      : super(key: key);

  @override
  _MultiSelectParticipantState createState() => _MultiSelectParticipantState();
}

class _MultiSelectParticipantState extends State<MultiSelectParticipant> {
  List selectedParticipant = [];
  List<Map<String, dynamic>> participants = [];

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      participants = widget.selectedList;
    });
    if (widget.selectedList.isNotEmpty) {
      widget.selectedList
          .map((e) => selectedParticipant.add(e["name"]))
          .toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    _itemChange(String item, bool isSelected) {
      setState(() {
        if (isSelected) {
          selectedParticipant.add(item);
        } else {
          selectedParticipant.remove(item);
        }
      });
    }

    _itemChange2(Map<String, dynamic> data, bool isChecked) {
      if (isChecked) {
        participants.add(data);
      } else {
        participants.removeWhere((element) => element["name"] == data["name"]);
      }
    }

    return Container(
        width: width,
        // height: height * 0.8,
        child: AlertDialog(
          actions: [
            ElevatedButton(
                onPressed: () {
                  widget.onClick(participants);
                  Navigator.pop(context);
                },
                child: Text("OK")),
          ],
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                for (var i = 0; i < widget.participant.length; i++)
                  Container(
                    width: width,
                    height: height * 0.06,
                    color: Colors.grey,
                    margin: EdgeInsets.only(bottom: 2),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectedParticipant
                              .contains(widget.participant[i]["name"]),
                          onChanged: (isChecked) {
                            _itemChange(
                                widget.participant[i]["name"], isChecked!);
                            _itemChange2(widget.participant[i], isChecked);
                          },
                        ),
                        Chip(
                          avatar: CircleAvatar(
                            child: Image.network(
                                widget.participant[i]["image_url"]),
                          ),
                          label: Text(
                            widget.participant[i]["name"],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          elevation: 1,
                          padding: EdgeInsets.all(8.0),
                        ),
                      ],
                    ),
                  ),
                Container(
                  width: width,
                  height: height * 0.07,
                  child: Row(),
                )
              ],
            ),
          ),
        ));
  }
}
