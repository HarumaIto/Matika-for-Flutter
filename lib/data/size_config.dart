import 'package:flutter/cupertino.dart';

/// すべての画面サイズに対応できるように
/// 比率でサイズを指定できるようにする
class SizeConfig {
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  // 初期化処理
  void init(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;

    double safeAreaHorizontal =
        mediaQueryData.padding.left + mediaQueryData.padding.right;
    double safeAreaVertical =
        mediaQueryData.padding.top + mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth! - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight! - safeAreaVertical) / 100;
  }
}