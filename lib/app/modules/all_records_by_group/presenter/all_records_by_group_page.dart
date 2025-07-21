import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../core/constants/constants.dart';
import '../../../di/dependency_injection.dart';
import '../../config/presenter/controller/config_controller.dart';
import '../../home/presenter/controller/record_controller.dart';
import '../../home/presenter/controller/record_states.dart';
import '../../home/presenter/widgets/card_record_widget.dart';

class AllRecordsByGroupPage extends StatefulWidget {
  const AllRecordsByGroupPage({super.key});

  @override
  State<AllRecordsByGroupPage> createState() => _AllRecordsByGroupPageState();
}

class _AllRecordsByGroupPageState extends State<AllRecordsByGroupPage> {
  final RecordController recordController = getIt<RecordController>();
  final ConfigController configController = getIt<ConfigController>();

  late final String? groupArg;
  bool isAdLoaded = false;
  bool isAdLoadedBottom = false;
  late BannerAd myBanner;
  late BannerAd myBannerBottom;

  Future<void> _getAllRecordsByGroup(String group) async {
    await recordController.getAllRecordsByGroup(group);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initBannerAd();
      await initBannerAdBottom();

      await _getAllRecordsByGroup(groupArg!);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    groupArg =
        (ModalRoute.of(context)!.settings.arguments as Map)['group'] as String;
  }

  Future<void> initBannerAd() async {
    isAdLoaded = false;
    setState(() {});

    myBanner = BannerAd(
      adUnitId: bannerIDAllRecords,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );

    await myBanner.load();
  }

  Future<void> initBannerAdBottom() async {
    isAdLoadedBottom = false;
    setState(() {});

    myBannerBottom = BannerAd(
      adUnitId: bannerIDAllRecordsBottom,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isAdLoadedBottom = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );

    await myBannerBottom.load();
  }

  @override
  void dispose() {
    myBanner.dispose();
    myBannerBottom.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate.timerPage.titleAppBarMoreRecords,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Observer(
          builder: (_) {
            final state = recordController.state;

            if (state is LoadingListRecordState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ErrorRecordState) {
              return Center(child: Text(state.message));
            }

            if (state is SuccessGetListRecordState) {
              final records = state.records;

              if (records.isEmpty) {
                return Center(
                  child: Text(context.translate.homePage.listEmpty),
                );
              }

              return Column(
                children: [
                  if (!Platform.isWindows && !configController.adsDisabled) ...[
                    if (isAdLoaded)
                      SizedBox(
                        height: myBanner.size.height.toDouble(),
                        width: myBanner.size.width.toDouble(),
                        child: AdWidget(ad: myBanner),
                      ),
                    const SizedBox(height: 10),
                  ],
                  Text(
                    groupArg == null
                        ? context.translate.timerPage.textGroupByModelLoading
                        : '${context.translate.timerPage.textGroupByModel}: $groupArg',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: SuperListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];

                        final color = [
                          Colors.amber,
                          Colors.green,
                          Colors.blue,
                          Colors.red,
                        ].elementAt(index.clamp(0, 3));

                        final fontSize = [
                          24.0,
                          22.0,
                          20.0,
                          18.0,
                        ].elementAt(index.clamp(0, 3));

                        return CardRecordWidget(
                          recordController: recordController,
                          index: index,
                          recordEntity: record,
                          colorText: color,
                          fontSize: fontSize,
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  if (!Platform.isWindows && !configController.adsDisabled) ...[
                    if (isAdLoadedBottom)
                      SizedBox(
                        height: myBannerBottom.size.height.toDouble(),
                        width: myBannerBottom.size.width.toDouble(),
                        child: AdWidget(ad: myBannerBottom),
                      ),
                  ],
                ],
              );
            }

            return Center(
              child: Text(context.translate.homePage.listEmpty),
            );
          },
        ),
      ),
    );
  }
}
