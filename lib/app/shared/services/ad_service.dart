import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

abstract class IAdService {
  Future<void> init();

  Future<BannerAd> loadBanner({
    required String androidAdId,
    required String iosAdId,
    AdSize size,
    BannerAdListener? listener,
  });

  Future<void> loadInterstitial({
    required String androidAdId,
    required String iosAdId,
  });

  Future<void> showInterstitial({VoidCallback? onDismissed});
}

@Singleton(as: IAdService)
class AdService implements IAdService {
  InterstitialAd? _interstitialAd;
  late String _androidInterstitialId;
  late String _iosInterstitialId;

  @override
  Future<BannerAd> loadBanner({
    required String androidAdId,
    required String iosAdId,
    AdSize size = AdSize.banner,
    BannerAdListener? listener,
  }) async {
    final adUnitId = Platform.isIOS ? iosAdId : androidAdId;
    final banner = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: listener ?? const BannerAdListener(),
    );
    await banner.load();
    return banner;
  }

  @override
  Future<void> loadInterstitial({
    required String androidAdId,
    required String iosAdId,
  }) async {
    _androidInterstitialId = androidAdId;
    _iosInterstitialId = iosAdId;
    final adUnitId = Platform.isIOS ? iosAdId : androidAdId;
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  @override
  Future<void> showInterstitial({VoidCallback? onDismissed}) async {
    if (_interstitialAd == null) {
      onDismissed?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        onDismissed?.call();
        loadInterstitial(
          androidAdId: _androidInterstitialId,
          iosAdId: _iosInterstitialId,
        );
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        onDismissed?.call();
        loadInterstitial(
          androidAdId: _androidInterstitialId,
          iosAdId: _iosInterstitialId,
        );
      },
    );

    await _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Future<void> init() async {
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        maxAdContentRating: MaxAdContentRating.g,
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
        tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
      ),
    );

    await MobileAds.instance.initialize();
  }
}
