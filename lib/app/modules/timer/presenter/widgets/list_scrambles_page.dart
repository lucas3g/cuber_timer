import 'dart:io';

import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/di/dependency_injection.dart';
import 'package:cuber_timer/app/modules/config/presenter/controller/config_controller.dart';
import 'package:cuber_timer/app/modules/timer/presenter/widgets/card_scramble_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

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
  final ConfigController configController = getIt<ConfigController>();

  late BannerAd myBanner;
  bool isAdLoaded = false;

  initBannerAd() async {
    myBanner = BannerAd(
      adUnitId: bannerdIdListScrambles,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    await myBanner.load();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!Platform.isWindows) {
        await initBannerAd();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate.timerPage.titleAppbarScramblesList),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          if (!Platform.isWindows && !configController.isAdRemoved) ...[
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
            context.translate.timerPage.textDescriptionScrambleSelected,
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
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final scramble = widget.scrambles[index];

                return CardScrambleWidget(scramble: scramble);
              },
            ),
          ),
        ],
      ),
    );
  }
}
