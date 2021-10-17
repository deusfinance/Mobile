import '../../statics/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FilledGradientSelectionButton extends StatelessWidget {
  final bool? selected;
  final VoidCallback? onPressed;
  final String? label;
  final LinearGradient? gradient;
  late TextStyle? textStyle;

  FilledGradientSelectionButton(
      {this.selected,
      this.onPressed,
      this.label,
      this.gradient,
      this.textStyle}) {
    if (this.textStyle == null) {
      this.textStyle = MyStyles.whiteMediumTextStyle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: this.gradient,
            borderRadius: BorderRadius.circular(MyStyles.cardRadiusSize)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: this.onPressed,
            borderRadius: BorderRadius.circular(MyStyles.cardRadiusSize),
            splashColor: Colors.grey[500],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(this.label!, style: this.textStyle),
              ),
            ),
          ),
        ));
  }
}
