import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../../shared/services/ad_service.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../../core/constants/constants.dart';
import '../../../../di/dependency_injection.dart';
import '../../../config/presenter/services/purchase_service.dart';
import 'card_scramble_widget.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';

class ListScramblesPage extends StatefulWidget {
  final PageController pageController;
  final List<String> scrambles;

  const ListScramblesPage({
    super.key,
    required this.scrambles,
    required this.pageController,
  });

  @override
  State<ListScramblesPage> createState() => _ListScramblesPageState();
}

class _ListScramblesPageState extends State<ListScramblesPage> {
  final PurchaseService purchaseService = getIt<PurchaseService>();
  final IAdService adService = getIt<IAdService>();

  late BannerAd myBanner;
  bool isAdLoaded = false;

  Future<void> _loadBanner() async {
    myBanner = await adService.loadBanner(
      androidAdId: bannerdIdListScrambles,
      iosAdId: bannerdIdListScramblesIOS,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!Platform.isWindows) {
        await _loadBanner();
      }
    });
  }

  @override
  void dispose() {
    myBanner.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: purchaseService,
      builder: (_, __) => Scaffold(
        appBar: AppBar(
          title: Text(translate('timer_page.titleAppbarScramblesList')),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            if (!Platform.isWindows && !purchaseService.isPremium) ...[
              isAdLoaded
                  ? Column(
                      children: [
                        SizedBox(
                          height: myBanner.size.height.toDouble(),
                          width: myBanner.size.width.toDouble(),
                          child: AdWidget(ad: myBanner),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox(height: 10),
            ],
            Text(
              translate('timer_page.textDescriptionScrambleSelected'),
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: SuperListView.separated(
                physics: const BouncingScrollPhysics(),
                cacheExtent: 2000,
                padding: const EdgeInsets.all(10),
                controller: widget.pageController,
                itemCount: widget.scrambles.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final scramble = widget.scrambles[index];

                  return CardScrambleWidget(scramble: scramble);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
