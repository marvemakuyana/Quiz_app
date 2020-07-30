import 'package:flutter/material.dart';

import './quiz.dart';

class AnswerWidget extends StatefulWidget {

  final List<Results> results;
  final int index;
  final String answers;

  AnswerWidget(this.results, this.index, this.answers);
  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  Color c = Colors.black;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          if (widget.answers == widget.results[widget.index].correctAnswer) {
          c = Colors.green;
        } else {
          c = Colors.red;
        }
        });
      },
      title: Text(widget.answers,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: c,
          fontWeight: FontWeight.bold
        ),
     ),
    );
  }
}