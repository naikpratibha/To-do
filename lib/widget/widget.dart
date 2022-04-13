import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String desc;
  TaskCard({this.title, this.desc});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? 'Unnamed',
            style: TextStyle(
              color: Color(0xff211551),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            desc ?? 'No description added.',
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xff868290),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class ToDo extends StatelessWidget {
  final String text;
  final bool isDone;

  ToDo({this.text, this.isDone});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 20.0,
            width: 20.0,
            margin: EdgeInsets.only(right: 12.0),
            child: Icon(
              FontAwesomeIcons.checkCircle,
              color: isDone ? Color(0xff231591) : Colors.grey,
            ),
          ),
          Flexible(
            child: Text(
              text ?? 'Unnamed todo',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: isDone ? Color(0xff231551) : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
