import 'dart:async';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:better_player_plus/src/subtitles/better_player_subtitle.dart';
import 'package:flutter/material.dart';

class BetterPlayerSubtitlesDrawer extends StatefulWidget {
  final List<BetterPlayerSubtitle> subtitles;
  final BetterPlayerController betterPlayerController;
  final BetterPlayerSubtitlesConfiguration? betterPlayerSubtitlesConfiguration;
  final Stream<bool> playerVisibilityStream;

  const BetterPlayerSubtitlesDrawer({
    Key? key,
    required this.subtitles,
    required this.betterPlayerController,
    this.betterPlayerSubtitlesConfiguration,
    required this.playerVisibilityStream,
  }) : super(key: key);

  @override
  _BetterPlayerSubtitlesDrawerState createState() =>
      _BetterPlayerSubtitlesDrawerState();
}

class _BetterPlayerSubtitlesDrawerState
    extends State<BetterPlayerSubtitlesDrawer> {
  final RegExp htmlRegExp =
      // ignore: unnecessary_raw_strings
      RegExp(r"<[^>]*>", multiLine: true);

  VideoPlayerValue? _latestValue;
  BetterPlayerSubtitlesConfiguration? _configuration;
  bool _playerVisible = false;

  ///Stream used to detect if play controls are visible or not
  late StreamSubscription _visibilityStreamSubscription;

  @override
  void initState() {
    _visibilityStreamSubscription =
        widget.playerVisibilityStream.listen((state) {
      setState(() {
        _playerVisible = state;
      });
    });

    if (widget.betterPlayerSubtitlesConfiguration != null) {
      _configuration = widget.betterPlayerSubtitlesConfiguration;
    } else {
      _configuration = setupDefaultConfiguration();
    }

    widget.betterPlayerController.videoPlayerController!
        .addListener(_updateState);

    super.initState();
  }

  @override
  void dispose() {
    widget.betterPlayerController.videoPlayerController!
        .removeListener(_updateState);
    _visibilityStreamSubscription.cancel();
    super.dispose();
  }

  ///Called when player state has changed, i.e. new player position, etc.
  void _updateState() {
    if (mounted) {
      setState(() {
        _latestValue =
            widget.betterPlayerController.videoPlayerController!.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final BetterPlayerSubtitle? subtitle = _getSubtitleAtCurrentPosition();
    widget.betterPlayerController.renderedSubtitle = subtitle;
    final List<String> subtitles = subtitle?.texts ?? [];
    final List<Widget> textWidgets =
        subtitles.map((text) => _buildSubtitleTextWidget(text)).toList();

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: _playerVisible
                ? _configuration!.bottomPadding + 30
                : _configuration!.bottomPadding,
            left: _configuration!.leftPadding,
            right: _configuration!.rightPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: textWidgets,
        ),
      ),
    );
  }

  BetterPlayerSubtitle? _getSubtitleAtCurrentPosition() {
    if (_latestValue == null) {
      return null;
    }

    final Duration position = _latestValue!.position;
    for (final BetterPlayerSubtitle subtitle
        in widget.betterPlayerController.subtitlesLines) {
      if (subtitle.start! <= position && subtitle.end! >= position) {
        return subtitle;
      }
    }
    return null;
  }

  Widget _buildSubtitleTextWidget(String subtitleText) {
    return Row(children: [
      Expanded(
        child: Align(
          alignment: _configuration!.alignment,
          child: _getTextWithStroke(subtitleText),
        ),
      ),
    ]);
  }

  Widget _getTextWithStroke(String subtitleText) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _configuration?.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildHtmlWidget(
        subtitleText,
        widget.betterPlayerSubtitlesConfiguration!.textStyle,
        widget.betterPlayerSubtitlesConfiguration!.fullScreenTextStyle,
      ),
    );
  }

  Widget _buildHtmlWidget(
      String text, TextStyle textStyle, TextStyle? fullScreenTextStyle) {
    if (widget.betterPlayerController.isFullScreen) {
      return Text(
        text.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D'),
        style: fullScreenTextStyle ?? textStyle,
        textAlign: TextAlign.center,
      );
      // return HtmlWidget(
      //   text.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D'),
      //   textStyle: fullScreenTextStyle ?? textStyle,
      // );
    }

    return Text(
      text.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D'),
      style: textStyle,
      textAlign: TextAlign.center,
    );

    // return HtmlWidget(
    //   text.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D'),
    //   textStyle: textStyle,
    // );
  }

  BetterPlayerSubtitlesConfiguration setupDefaultConfiguration() {
    return const BetterPlayerSubtitlesConfiguration(textStyle: TextStyle());
  }
}
