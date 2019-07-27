import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RotatedBox(
        quarterTurns: 1,
        child: Divider(),
      );
}
