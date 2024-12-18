// Flutter imports:
import 'package:flutter/material.dart';

///Configuration of subtitles - colors/padding/font. Used in
///BetterPlayerConfiguration.
class BetterPlayerSubtitlesConfiguration {
  ///Subtitle font style
  final TextStyle textStyle;

  ///Enable outline (border) of the text
  final bool outlineEnabled;

  ///Color of the outline stroke
  final Color outlineColor;

  ///Outline stroke size
  final double outlineSize;

  ///Left padding of the subtitle
  final double leftPadding;

  ///Right padding of the subtitle
  final double rightPadding;

  ///Bottom padding of the subtitle
  final double bottomPadding;

  ///Alignment of the subtitle
  final Alignment alignment;

  ///Background color of the subtitle
  final Color backgroundColor;

  const BetterPlayerSubtitlesConfiguration({
    required this.textStyle,
    this.outlineEnabled = true,
    this.outlineColor = Colors.black,
    this.outlineSize = 2.0,
    this.leftPadding = 8.0,
    this.rightPadding = 8.0,
    this.bottomPadding = 20.0,
    this.alignment = Alignment.center,
    this.backgroundColor = Colors.transparent,
  });
}
