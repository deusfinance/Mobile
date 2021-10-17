import 'my_colors.dart';
import 'package:flutter/material.dart';

class MyStyles {
  static final ThemeData theme = ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: MyStyles.kFontFamily,
    backgroundColor: const Color(MyColors.Background),
    brightness: Brightness.dark,
    canvasColor: const Color(MyColors.Background),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // font sizes

  static const S6 = 11.0;
  static const S5 = 16.0;
  static const S4 = 18.0;
  static const S3 = 20.0;
  static const S2 = 24.0;
  static const S1 = 32.0;

  static const cardRadiusSize = 16.0;
  static const mainPadding = 8.0;

  static const String kFontFamily = "Monument";

  // decorations
  static final lightBlackBorderDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize / 2),
      color: MyColors.Main_BG_Black,
      border: Border.all(color: MyColors.Button_BG_Black, width: 1.0));
  static final darkWithBorderDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize),
      color: MyColors.Button_BG_Black,
      border: Border.all(color: MyColors.Black, width: 1.0));

  static final darkWithNoBorderDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize),
      color: MyColors.Button_BG_Black);

  static final blueToPurpleDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize),
      gradient: MyColors.blueToPurpleGradient);

  static final greenToBlueDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize / 2),
      gradient: MyColors.greenToBlueGradient);
  static final blueToGreenDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize / 2),
      gradient: MyColors.blueToGreenGradient);
  static final blueToGreenSwapScreenDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadiusSize / 2),
      gradient: MyColors.blueToGreenSwapScreenGradient);

  // text styles
  static final lightWhiteSmallTextStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: S6,
    color: MyColors.HalfWhite,
  );
  static final lightWhiteMediumTextStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: S4,
    color: MyColors.HalfWhite,
  );
  static final whiteSmallTextStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: S6,
    color: MyColors.White,
  );
  static final blackSmallTextStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: S6,
    color: MyColors.Black,
  );

  static final greenSmallTextStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: S6,
    color: MyColors.ToastGreen,
  );
  static final blackMediumTextStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: S4,
    color: MyColors.Black,
  );
  static final whiteMediumTextStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: S4,
    color: MyColors.White,
  );
  static final whiteBigTextStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: S2,
    color: MyColors.White,
  );

  static final selectedToggleButtonTextStyle = TextStyle(
      fontFamily: kFontFamily,
      fontWeight: FontWeight.w300,
      fontSize: S5,
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationColor: MyColors.White,
      shadows: [Shadow(color: MyColors.White, offset: const Offset(0, -5))]);

  static final unselectedToggleButtonTextStyle = TextStyle(
      fontFamily: kFontFamily,
      fontWeight: FontWeight.w300,
      fontSize: S5,
      color: Colors.transparent,
      shadows: [
        Shadow(color: MyColors.HalfWhite, offset: const Offset(0, -5))
      ]);

  static TextStyle gradientMediumTextStyle = TextStyle(
      fontFamily: kFontFamily,
      fontWeight: FontWeight.w300,
      fontSize: S4,
      foreground: Paint()
        ..shader = const LinearGradient(
          colors: <Color>[Color(0xff0779E4), Color(0xff1DD3BD)],
        ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)));

  static final whiteMediumUnderlinedTextStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    decoration: TextDecoration.underline,
    fontSize: S4,
    color: MyColors.White,
  );

  static final whiteSmallUnderlinedTextStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    decoration: TextDecoration.underline,
    fontSize: S6,
    color: MyColors.White,
  );

  static final bottomNavBarUnSelectedStyle = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: S5,
    color: MyColors.White,
  );
}

enum NavigationStyle { BluePurple, GreenBlue, BlueGreen }
