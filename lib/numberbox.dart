import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyNumberBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final child;
  bool revealed;
  // ignore: prefer_typing_uninitialized_variables
  final function;

  MyNumberBox({Key? key, this.child, required this.revealed, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: revealed ? Colors.grey[300] : Colors.grey[400],
          child: Center(
            child: Text(
              revealed ? (child == 0 ? '' : child.toString()) : '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: child == 1
                    ? Colors.pink
                    : (child == 2 ? Colors.black : Colors.blue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
