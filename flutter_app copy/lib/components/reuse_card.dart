import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({
    this.cardChild,
    this.onPressed,
    this.setState,
  });
  final Widget cardChild;
  final Function onPressed;
  final Function setState;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.only(top: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.white,
        ),
      ),
    );
  }
}
