import 'package:flutter/material.dart';

class CenterText extends StatelessWidget {
  final String text;

  const CenterText({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16.0,
            color: Color(0xFF1DE9B6),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
