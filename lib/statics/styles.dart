import 'package:deus/statics/my_colors.dart';
import 'package:flutter/cupertino.dart';

class MyStyles {
//  font sizes
  static const S6 = 13.0;
  static const S5 = 16.0;
  static const S4 = 18.0;
  static const S3 = 20.0;
  static const S2 = 24.0;
  static const S1 = 32.0;

  static const cardRadiusSize = 12.0;
  static const mainPadding = 8.0;

//  decorations
  static var lightBlackBorderDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize),
      color: Color(MyColors.Button_BG_Black),
      border: Border.all(color: Color(MyColors.HalfBlack), width: 1.0));
  static var darkWithBorderDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize),
      color: Color(MyColors.Button_BG_Black),
      border: Border.all(color: Color(MyColors.Black), width: 1.0));

  static var darkWithNoBorderDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize),
      color: Color(MyColors.Button_BG_Black));

  static var blueToPurpleDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize),
      gradient: MyColors.blueToPurpleGradient);

  static var greenToBlueDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize),
      gradient: MyColors.greenToBlueGradient);

//  text styles
  static const lightWhiteSmallTextStyle = TextStyle(
    fontFamily: "Monument",
    fontWeight: FontWeight.w300,
    fontSize: S6,
    color: Color(MyColors.HalfWhite),
  );
  static const lightWhiteMediumTextStyle = TextStyle(
    fontFamily: "Monument",
    fontWeight: FontWeight.w300,
    fontSize: S4,
    color: Color(MyColors.HalfWhite),
  );
  static const whiteSmallTextStyle = TextStyle(
    fontFamily: "Monument",
    fontWeight: FontWeight.w300,
    fontSize: S6,
    color: Color(MyColors.White),
  );
  static const blackSmallTextStyle = TextStyle(
    fontFamily: "Monument",
    fontWeight: FontWeight.w300,
    fontSize: S6,
    color: Color(MyColors.Black),
  );
  static const blackMediumTextStyle = TextStyle(
    fontFamily: "Monument",
    fontWeight: FontWeight.w300,
    fontSize: S4,
    color: Color(MyColors.Black),
  );
  static const whiteMediumTextStyle = TextStyle(
    fontFamily: "Monument",
    fontWeight: FontWeight.w300,
    fontSize: S4,
    color: Color(MyColors.White),
  );
  static const whiteMediumUnderlinedTextStyle = TextStyle(
    fontFamily: "Monument",
    fontWeight: FontWeight.w300,
    decoration: TextDecoration.underline,
    fontSize: S4,
    color: Color(MyColors.White),
  );

  static const bottomNavBarUnSelectedStyle = TextStyle(
    fontFamily: "Monument",
    fontWeight: FontWeight.w300,
    fontSize: S5,
    color: Color(MyColors.White),
  );
}
