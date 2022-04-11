import 'package:cls_rh/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardLeave extends StatefulWidget {
  String file, leave_start_date, status, leave_end_date, type;
  int leave_days;
  CardLeave(
      {Key? key,
      required this.status,
      required this.leave_start_date,
      required this.leave_end_date,
      required this.leave_days,
      this.file = "",
      this.type = ""})
      : super(key: key);

  @override
  State<CardLeave> createState() => _CardLeaveState();
}

Color getColor(status) {
  switch (status) {
    case "in progress":
      return in_progress;
      break;
    case "declined":
      return declined;
      break;
    case "accepted":
      return accepted;
      break;
    default:
      return Color.fromARGB(255, 0, 0, 0);
  }
}

class _CardLeaveState extends State<CardLeave> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromARGB(255, 219, 221, 245),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        shadowColor: Colors.white,
        elevation: 1,
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTile(
                    leading: const Icon(Icons.arrow_drop_down_circle),
                    title: Text(widget.status,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 180, 138, 103))),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Start Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.leave_start_date))}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 73, 73, 73)),
                        ),
                        Text(
                          "End Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.leave_end_date))}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 73, 73, 73)),
                        ),
                        Text(
                          "Days: ${widget.leave_days}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 73, 73, 73)),
                        ),
                        Text(
                          "Type : ${widget.type}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 73, 73, 73)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
