import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyBomb extends StatelessWidget {
  bool revealed;
  bool flagged;
  // ignore: prefer_typing_uninitialized_variables
  final function;
  // ignore: prefer_typing_uninitialized_variables
  final functionFlag;

  MyBomb(
      {Key? key,
      required this.revealed,
      required this.flagged,
      this.function,
      this.functionFlag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: revealed
              ? Colors.green[800]
              : (flagged ? Colors.amber[400] : Colors.grey[400]),
        ),
      ),
      onLongPress: functionFlag,
    );
  }
}
