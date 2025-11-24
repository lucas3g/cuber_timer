import 'dart:io';

import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobx/mobx.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../core/constants/constants.dart';
import '../../../core/domain/entities/named_routes.dart';
import '../../../di/dependency_injection.dart';
import '../../../shared/services/ad_service.dart';
import '../../home/presenter/controller/record_controller.dart';
import '../../home/presenter/controller/record_states.dart';
import '../../home/presenter/widgets/card_record_widget.dart';
import '../../subscriptions/services/purchase_service.dart';

class AllRecordsByGroupPage extends StatefulWidget {
  const AllRecordsByGroupPage({super.key});

  @override
  State<AllRecordsByGroupPage> createState() => _AllRecordsByGroupPageState();
}

class _AllRecordsByGroupPageState extends State<AllRecordsByGroupPage> {
  final RecordController recordController = getIt<RecordController>();
  final PurchaseService purchaseService = getIt<PurchaseService>();
  final IAdService adService = getIt<IAdService>();

  late final String? groupArg;
  bool isAdLoaded = false;
  bool isAdLoadedBottom = false;
  late BannerAd myBanner;
  late BannerAd myBannerBottom;

  late final ReactionDisposer _autorunDisposer;

  Future<void> _getAllRecordsByGroup(String group) async {
    await recordController.getAllRecordsByGroup(group);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadTopBanner();
      await _loadBottomBanner();

      await _getAllRecordsByGroup(groupArg!);
    });

    _autorunDisposer = autorun((_) {
      final state = recordController.state;

      if (state is RecordDeletionRequiresPremiumState) {
        _showDeletePremiumDialog();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    groupArg =
        (ModalRoute.of(context)!.settings.arguments as Map)['group'] as String;
  }

  Future<void> _loadTopBanner() async {
    isAdLoaded = false;
    setState(() {});

    myBanner = await adService.loadBanner(
      androidAdId: bannerIDAllRecords,
      iosAdId: bannerIDAllRecordsIOS,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
  }

  Future<void> _loadBottomBanner() async {
    isAdLoadedBottom = false;
    setState(() {});

    myBannerBottom = await adService.loadBanner(
      androidAdId: bannerIDAllRecordsBottom,
      iosAdId: bannerIDAllRecordsBottomIOS,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isAdLoadedBottom = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
  }

  @override
  void dispose() {
    myBanner.dispose();
    myBannerBottom.dispose();
    _autorunDisposer();

    super.dispose();
  }

  void _showDeletePremiumDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone de destaque
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),

            // Título
            Text(
              translate('home_page.delete_premium_title'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Mensagem
            Text(
              translate('home_page.delete_premium_message'),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                height: 1.5,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),

            // Botões
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(
                        context,
                        NamedRoutes.subscriptions.route,
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      translate('home_page.delete_premium_button_upgrade'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    translate('home_page.delete_premium_button_later'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: purchaseService,
      builder: (_, __) => Scaffold(
        appBar: AppBar(
          title: Text(
            translate('timer_page.title_appbar_more_records'),
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
                  child: Text(translate('home_page.list_empty')),
                );
              }

              return Column(
                children: [
                  if (!Platform.isWindows && !purchaseService.isPremium) ...[
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
                        ? translate('timer_page.textGroupByModelLoading')
                        : '${translate('timer_page.textGroupByModel')}: $groupArg',
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
                  if (!Platform.isWindows && !purchaseService.isPremium) ...[
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
              child: Text(translate('home_page.list_empty')),
            );
          },
          ),
        ),
      ),
    );
  }
}
