/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

  /// File path: assets/animations/audio_playing.json
  String get audioPlaying => 'assets/animations/audio_playing.json';

  /// List of all assets
  List<String> get values => [audioPlaying];
}

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/PlusJakartaSans-Bold.ttf
  String get plusJakartaSansBold => 'assets/fonts/PlusJakartaSans-Bold.ttf';

  /// File path: assets/fonts/PlusJakartaSans-BoldItalic.ttf
  String get plusJakartaSansBoldItalic =>
      'assets/fonts/PlusJakartaSans-BoldItalic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-ExtraBold.ttf
  String get plusJakartaSansExtraBold =>
      'assets/fonts/PlusJakartaSans-ExtraBold.ttf';

  /// File path: assets/fonts/PlusJakartaSans-ExtraBoldItalic.ttf
  String get plusJakartaSansExtraBoldItalic =>
      'assets/fonts/PlusJakartaSans-ExtraBoldItalic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-ExtraLight.ttf
  String get plusJakartaSansExtraLight =>
      'assets/fonts/PlusJakartaSans-ExtraLight.ttf';

  /// File path: assets/fonts/PlusJakartaSans-ExtraLightItalic.ttf
  String get plusJakartaSansExtraLightItalic =>
      'assets/fonts/PlusJakartaSans-ExtraLightItalic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-Italic.ttf
  String get plusJakartaSansItalic => 'assets/fonts/PlusJakartaSans-Italic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-Light.ttf
  String get plusJakartaSansLight => 'assets/fonts/PlusJakartaSans-Light.ttf';

  /// File path: assets/fonts/PlusJakartaSans-LightItalic.ttf
  String get plusJakartaSansLightItalic =>
      'assets/fonts/PlusJakartaSans-LightItalic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-Medium.ttf
  String get plusJakartaSansMedium => 'assets/fonts/PlusJakartaSans-Medium.ttf';

  /// File path: assets/fonts/PlusJakartaSans-MediumItalic.ttf
  String get plusJakartaSansMediumItalic =>
      'assets/fonts/PlusJakartaSans-MediumItalic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-Regular.ttf
  String get plusJakartaSansRegular =>
      'assets/fonts/PlusJakartaSans-Regular.ttf';

  /// File path: assets/fonts/PlusJakartaSans-SemiBold.ttf
  String get plusJakartaSansSemiBold =>
      'assets/fonts/PlusJakartaSans-SemiBold.ttf';

  /// File path: assets/fonts/PlusJakartaSans-SemiBoldItalic.ttf
  String get plusJakartaSansSemiBoldItalic =>
      'assets/fonts/PlusJakartaSans-SemiBoldItalic.ttf';

  /// List of all assets
  List<String> get values => [
        plusJakartaSansBold,
        plusJakartaSansBoldItalic,
        plusJakartaSansExtraBold,
        plusJakartaSansExtraBoldItalic,
        plusJakartaSansExtraLight,
        plusJakartaSansExtraLightItalic,
        plusJakartaSansItalic,
        plusJakartaSansLight,
        plusJakartaSansLightItalic,
        plusJakartaSansMedium,
        plusJakartaSansMediumItalic,
        plusJakartaSansRegular,
        plusJakartaSansSemiBold,
        plusJakartaSansSemiBoldItalic
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [logo];
}

class Assets {
  Assets._();

  static const $AssetsAnimationsGen animations = $AssetsAnimationsGen();
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
