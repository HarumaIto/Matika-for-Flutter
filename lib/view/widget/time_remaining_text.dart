import 'package:flutter/material.dart';

/// TimeRemainingTextで使用する
enum RemainingType {
  /// 残り時間が残っている場合
  remaining,

  /// 残り時間が0の場合
  /// 入店可能である場合
  possible,

  /// 入店不可能な場合
  impossible,
}

/// 予約ページの文字色変化のあるTextを簡単に扱うためのクラス
/// RichTextをオリジナルで使いやすくするためにカプセル化した
class TimeRemainingText extends StatelessWidget {
  /// テキストのタイプを選択するため
  RemainingType remainingType;

  /// 残り時間や営業の有無を状態として保持する
  String stateText;

  /// 通常のTextColor
  Color normalColor;

  /// 通常のTextSize
  /// デフォルトは 14
  double normalTextSize;

  /// 基本的には normalTextSize + 8 とする
  double? accentTextSize;

  // RichTextのchildrenに配置するTextSpanのリスト
  List<InlineSpan> inlineSpans = [];

  TimeRemainingText({
    super.key,
    required this.remainingType,
    required this.stateText,
    this.normalColor = Colors.black,
    this.normalTextSize = 14,
    this.accentTextSize,
  }) {
    // 初期値がなければ normalSize に +8 する
    accentTextSize ??= normalTextSize + 8;

    if (remainingType == RemainingType.remaining) {
      inlineSpans.addAll([
        TextSpan(text: '残り', style: TextStyle(color: normalColor, fontSize: normalTextSize)),
        TextSpan(text: stateText, style: TextStyle(color: Colors.blue, fontSize: accentTextSize)),
        TextSpan(text: 'です', style: TextStyle(color: normalColor, fontSize: normalTextSize)),
      ]);
    } else if (remainingType == RemainingType.possible) {
      inlineSpans.addAll([
        TextSpan(text: 'いつでも', style: TextStyle(color: normalColor, fontSize: normalTextSize)),
        TextSpan(text: stateText, style: TextStyle(color: Colors.blue, fontSize: accentTextSize)),
        TextSpan(text: 'です', style: TextStyle(color: normalColor, fontSize: normalTextSize)),
      ]);
    } else {
      inlineSpans.addAll([
        TextSpan(text: 'ただいま', style: TextStyle(color: normalColor, fontSize: normalTextSize)),
        TextSpan(text: stateText, style: TextStyle(color: Colors.red, fontSize: accentTextSize)),
        TextSpan(text: 'です', style: TextStyle(color: normalColor, fontSize: normalTextSize)),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: inlineSpans,
      ),
    );
  }
}