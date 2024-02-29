import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pitik_asset/pitik_asset.dart';
import 'package:pitik_asset/src/components/assets/enums/pitik_asset_type.dart';
import 'package:pitik_asset/src/components/assets/models/pitik_asset_model.dart';

class PitikAsset extends StatelessWidget {
  const PitikAsset._({
    required PitikAssetType type,
    required this.data,
    this.repeat = false,
    this.borderRadius,
    this.fit = BoxFit.contain,
    this.imageRepeat,
    this.shape,
    this.width,
    this.height,
    this.color,
    this.border,
  }) : _type = type;

  factory PitikAsset.icon({
    required PitikSvg svg,
    double? size,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) =>
      PitikAsset._(
        type: PitikAssetType.svg,
        data: svg.data,
        width: size,
        height: size,
        fit: fit,
        color: color,
      );

  factory PitikAsset.animation({
    required PitikAnimations animation,
    double? width,
    double? height,
    bool repeat = true,
    BoxFit fit = BoxFit.contain,
  }) =>
      PitikAsset._(
        type: PitikAssetType.animations,
        data: animation.data,
        repeat: repeat,
        width: width,
        height: height,
        fit: fit,
      );

  factory PitikAsset.images({
    required PitikImages image,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    BoxShape? shape,
    BoxFit fit = BoxFit.contain,
    Border? border,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) =>
      PitikAsset._(
        type: PitikAssetType.images,
        width: width,
        height: height,
        imageRepeat: repeat,
        border: border,
        borderRadius: borderRadius,
        shape: shape,
        fit: fit,
        data: image.data,
      );

  final PitikAssetType _type;
  final PitikAssetData data;
  final bool repeat;
  final ImageRepeat? imageRepeat;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final BoxShape? shape;
  final Border? border;

  @override
  Widget build(BuildContext context) => switch (_type) {
        PitikAssetType.svg => SvgPicture.asset(
            data.path,
            fit: fit,
            height: (height ?? 0) * 1.sp,
            width: (width ?? 0) * 1.sp,
            colorFilter: color != null
                ? ColorFilter.mode(
                    color!,
                    BlendMode.srcIn,
                  )
                : null,
            package: 'pitik_asset',
          ),
        PitikAssetType.images => ExtendedImage.asset(
            data.path,
            width: (width ?? 0) * 1.w,
            height: (height ?? 0) * 1.h,
            borderRadius: borderRadius,
            repeat: imageRepeat!,
            shape: shape,
            package: 'pitik_asset',
          ),
        PitikAssetType.animations => Lottie.asset(
            data.path,
            width: (width ?? 0) * 1.w,
            height: (height ?? 0) * 1.h,
            repeat: repeat,
            fit: fit,
            package: 'pitik_asset',
          ),
      };
}
