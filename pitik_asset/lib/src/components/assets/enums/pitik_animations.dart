import 'package:pitik_asset/src/assets/assets.gen.dart';
import 'package:pitik_asset/src/components/assets/models/pitik_asset_model.dart';

enum PitikAnimations {
  bannerLazyLoad,
  cardHeight450Lazy,
  cardLazy,
  checkOrange,
  coopLazyLoading,
  informationOrangeIcon,
  loading;

  PitikAssetData get data => switch (this) {
        bannerLazyLoad => PitikAssetData(
            path: Assets.animations.bannerLazyLoad.path,
          ),
        cardHeight450Lazy => PitikAssetData(
            path: Assets.animations.cardHeight450Lazy.path,
          ),
        cardLazy => PitikAssetData(
            path: Assets.animations.cardLazy.path,
          ),
        checkOrange => PitikAssetData(
            path: Assets.animations.checkOrange.path,
          ),
        coopLazyLoading => PitikAssetData(
            path: Assets.animations.coopLazyLoading.path,
          ),
        informationOrangeIcon => PitikAssetData(
            path: Assets.animations.informationOrangeIcon.path,
          ),
        loading => PitikAssetData(
            path: Assets.animations.loading.path,
          ),
      };
}
