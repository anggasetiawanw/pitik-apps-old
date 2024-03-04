import 'package:pitik_asset/src/assets/assets.gen.dart';
import 'package:pitik_asset/src/components/assets/models/pitik_asset_model.dart';

enum PitikImages {
  alertRed,
  eyeOffIcon,
  eyeOnIcon,
  headerBg,
  issueNotFound,
  onboarding1,
  onboarding2,
  onboarding3,
  pitikConnect,
  pitikLauncher,
  pitikWatermark,
  triangleIcon;

  PitikAssetData get data => switch (this) {
        alertRed => PitikAssetData(
            path: Assets.images.alertRed.path,
          ),
        eyeOffIcon => PitikAssetData(
            path: Assets.images.eyeOffIcon.path,
          ),
        eyeOnIcon => PitikAssetData(
            path: Assets.images.eyeOnIcon.path,
          ),
        headerBg => PitikAssetData(
            path: Assets.images.headerBg.path,
          ),
        issueNotFound => PitikAssetData(
            path: Assets.images.issueNotFound.path,
          ),
        onboarding1 => PitikAssetData(
            path: Assets.images.onboarding1.path,
          ),
        onboarding2 => PitikAssetData(
            path: Assets.images.onboarding2.path,
          ),
        onboarding3 => PitikAssetData(
            path: Assets.images.onboarding3.path,
          ),
        pitikConnect => PitikAssetData(
            path: Assets.images.pitikConnect.path,
          ),
        pitikLauncher => PitikAssetData(
            path: Assets.images.pitikLauncher.path,
          ),
        pitikWatermark => PitikAssetData(
            path: Assets.images.pitikWatermark.path,
          ),
        triangleIcon => PitikAssetData(
            path: Assets.images.triangleIcon.path,
          ),
      };
}
