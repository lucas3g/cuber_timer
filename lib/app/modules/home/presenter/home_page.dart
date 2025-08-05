// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:async';
import 'dart:io';

import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/core/data/clients/local_database/schemas/record.dart';
import 'package:cuber_timer/app/core/domain/entities/app_global.dart';
import 'package:cuber_timer/app/core/domain/entities/named_routes.dart';
import 'package:cuber_timer/app/core/domain/entities/subscription_plan.dart';
import 'package:cuber_timer/app/di/dependency_injection.dart';
import 'package:cuber_timer/app/modules/config/presenter/services/purchase_service.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_controller.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_states.dart';
import 'package:cuber_timer/app/modules/home/presenter/widgets/card_record_widget.dart';
import 'package:cuber_timer/app/shared/components/my_circular_progress_widget.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:cuber_timer/app/shared/components/my_snackbar.dart';
import 'package:cuber_timer/app/shared/components/no_data_widget.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:cuber_timer/app/shared/utils/cube_types_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../shared/services/ad_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final recordController = getIt<RecordController>();
  final PurchaseService purchaseService = getIt<PurchaseService>();
  final IAdService adService = getIt<IAdService>();

  int _currentTabIndex = 0;

  String selectedGroup = '3x3';

  late BannerAd myBanner;
  late BannerAd myBottmBanner;
  bool isTopAdLoaded = false;
  bool isBottomAdLoaded = false;

  late Map<String, List<RecordEntity>> sortedGroupedRecords;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    if (!Platform.isWindows) {
      _loadAds();
    }

    getFiveRecordsByGroup();

    autorun((_) async {
      final state = recordController.state;

      if (state is ErrorRecordState) {
        MySnackBar(
          title: translate('home_page.error_title'),
          message: state.message,
          type: TypeSnack.error,
        );
      }

      if (state is SuccessGetListRecordState) {
        if (state.records.isNotEmpty) {
          _updateTabController(state.records);
        }
      }

      if (state is SuccessDeleteRecordState) {
        if (state.groupDelete.isNotEmpty) {
          removeTab(state.groupDelete);
        } else {
          // Se não houver grupo para remover, atualiza a lista
          _updateTabController(state.records);
        }
      }
    });
  }

  void _updateTabController(List<RecordEntity> records) {
    // Processar e agrupar records
    final groupedRecords = <String, List<RecordEntity>>{};

    for (var record in records) {
      groupedRecords.putIfAbsent(record.group, () => []).add(record);
    }

    final sortedGroupKeys = groupedRecords.keys.toList()
      ..sort((a, b) {
        final indexA = CubeTypesList.types.indexOf(a);
        final indexB = CubeTypesList.types.indexOf(b);
        return indexA.compareTo(indexB);
      });

    sortedGroupedRecords = {
      for (var key in sortedGroupKeys) key: groupedRecords[key]!,
    };

    final newTabCount = sortedGroupedRecords.length;

    // Atualiza o TabController independente da quantidade de tabs
    _recreateTabController(newTabCount);
  }

  void _recreateTabController(int newLength) {
    // Salvar o índice atual antes de dispor o controller
    final currentIndex = _tabController?.index ?? 0;

    // Remover listener e dispor controller anterior
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();

    if (newLength > 0) {
      // Garantir que o índice seja válido para o novo length
      _currentTabIndex = currentIndex.clamp(0, newLength - 1);

      // Criar novo controller
      _tabController = TabController(
        length: newLength,
        vsync: this,
        initialIndex: _currentTabIndex,
      );

      // Adicionar listener
      _tabController?.addListener(_onTabChanged);

      // Atualizar o grupo selecionado
      if (sortedGroupedRecords.isNotEmpty) {
        selectedGroup = sortedGroupedRecords.keys.elementAt(_currentTabIndex);
      }
    } else {
      _tabController = null;
    }

    // Forçar rebuild
    if (mounted) {
      setState(() {});
    }
  }

  void _onTabChanged() {
    if (_tabController == null) return;

    final newIndex = _tabController!.index;

    // Verificar se o índice é válido
    if (newIndex >= 0 && newIndex < sortedGroupedRecords.length) {
      setState(() {
        _currentTabIndex = newIndex;
        selectedGroup = sortedGroupedRecords.keys.elementAt(newIndex);
      });
    }
  }

  // Método para remover uma tab específica (exemplo)
  void removeTab(String groupToRemove) {
    if (sortedGroupedRecords.containsKey(groupToRemove)) {
      final removedIndex =
          sortedGroupedRecords.keys.toList().indexOf(groupToRemove);

      // Ajustar o índice atual se necessário
      if (_currentTabIndex >= removedIndex && _currentTabIndex > 0) {
        _currentTabIndex--;
      }

      // Remover o grupo
      sortedGroupedRecords.remove(groupToRemove);

      _updateTabController(
        sortedGroupedRecords.values.expand((e) => e).toList(),
      );

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();

    // Dispose outros recursos...
    myBanner.dispose();
    myBottmBanner.dispose();

    super.dispose();
  }

  Future<void> _loadAds() async {
    isTopAdLoaded = false;
    isBottomAdLoaded = false;
    setState(() {});

    myBanner = await adService.loadBanner(
      androidAdId: bannerTopID,
      iosAdId: bannerTopIdiOS,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isTopAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );

    myBottmBanner = await adService.loadBanner(
      androidAdId: bannerBottomID,
      iosAdId: bannerBottomIdiOS,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isBottomAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );

    await adService.loadInterstitial(
      androidAdId: intersticialID,
      iosAdId: intersticialIdiOS,
    );
  }

  Future<void> _showInterstitialAd() async {
    if (purchaseService.isPremium) {
      await Navigator.pushReplacementNamed(context, NamedRoutes.timer.route);
      await getFiveRecordsByGroup();
      if (!Platform.isWindows) {
        await _loadAds();
      }
      return;
    }

    await adService.showInterstitial(onDismissed: () async {
      await Navigator.pushReplacementNamed(context, NamedRoutes.timer.route);
      await getFiveRecordsByGroup();
      if (!Platform.isWindows) {
        await _loadAds();
      }
    });
  }

  Future<void> getFiveRecordsByGroup() async =>
      await recordController.getFiveRecordsByGroup();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: purchaseService,
      builder: (_, __) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Observer(builder: (context) {
                if (_tabController == null || sortedGroupedRecords.isEmpty) {
                  return NoDataWidget(
                    text: translate('home_page.list_empty'),
                  );
                }

                final state = recordController.state;

                if (state is! SuccessGetListRecordState &&
                    state is! SuccessDeleteRecordState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const MyCircularProgressWidget(),
                      Text(
                        translate('home_page.text_loading'),
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  );
                }

                final records = state.records;

                if (records.isEmpty) {
                  return NoDataWidget(
                    text: translate('home_page.list_empty'),
                  );
                }

                final Widget? subscriptionButton = _buildSubscriptionButton();

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banners...
                      if (!Platform.isWindows &&
                          !purchaseService.isPremium) ...[
                        if (isTopAdLoaded)
                          SizedBox(
                            height: myBanner.size.height.toDouble(),
                            width: myBanner.size.width.toDouble(),
                            child: AdWidget(ad: myBanner),
                          ),
                        const SizedBox(height: 10),
                      ],

                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                  color: context.myTheme.onSurface,
                                ),
                              ),
                            ),
                            child: Text(
                              translate('home_page.title_list'),
                              style: context.textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (subscriptionButton != null) subscriptionButton,
                        ],
                      ),

                      // TabBar e TabBarView
                      Expanded(
                        child: _buildTabSection(),
                      ),
                    ],
                  ),
                );
              }),

              // Botão Start e banner inferior
                _buildBottomSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSubscriptionButton() {
    final SubscriptionPlan plan = AppGlobal.instance.plan;

    if (plan == SubscriptionPlan.annual) {
      return null;
    }

    final bool isUpgrade =
        plan == SubscriptionPlan.weekly || plan == SubscriptionPlan.monthly;

    final String label = isUpgrade
        ? translate('home_page.button_upgrade')
        : translate('home_page.button_subscribe');

    return MyElevatedButtonWidget(
      onPressed: () => Navigator.pushNamed(context, NamedRoutes.config.route),
      label: Text(label),
      icon: isUpgrade ? Icons.upgrade : Icons.star,
    );
  }

  Widget _buildTabSection() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: context.myTheme.onSurface,
          tabAlignment: TabAlignment.start,
          indicatorColor: context.myTheme.primary,
          tabs: sortedGroupedRecords.keys
              .map(
                (group) => Tab(
                  child: Text(
                    group,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: sortedGroupedRecords.entries
                .map((entry) => _buildTabContent(entry))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(MapEntry<String, List<RecordEntity>> entry) {
    final groupItems = entry.value;

    return Column(
      children: [
        Expanded(
          child: SuperListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: groupItems.length,
            itemBuilder: (context, index) {
              final record = groupItems[index];

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

              if (index == 4) {
                return Column(
                  children: [
                    CardRecordWidget(
                      recordController: recordController,
                      index: index,
                      recordEntity: record,
                      colorText: color,
                      fontSize: fontSize,
                    ),
                    Visibility(
                      visible: groupItems.length == 5,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            NamedRoutes.allRecordsByGroup.route,
                            arguments: {'group': selectedGroup},
                          );
                          await getFiveRecordsByGroup();
                        },
                        child: Text(
                          translate('home_page.buttonMoreRecords'),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return CardRecordWidget(
                recordController: recordController,
                index: index,
                recordEntity: record,
                colorText: color,
                fontSize: fontSize,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
          ),
        ),

        // Seção de médias
        _buildAverageSection(),
      ],
    );
  }

  Widget _buildAverageSection() {
    return Column(
      children: [
        Divider(color: context.myTheme.onSurface),
        Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: context.myTheme.onSurface,
                ),
              ),
            ),
            child: Text(
              translate('home_page.title_avg'),
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAvgColumn(
              translate('home_page.best'),
              recordController.bestTime(selectedGroup),
              Colors.amber,
            ),
            _buildAvgColumn(
              translate('home_page.avg_5'),
              recordController.avgFive(selectedGroup),
              Colors.green,
            ),
            _buildAvgColumn(
              translate('home_page.avg_12'),
              recordController.avgTwelve(selectedGroup),
              Colors.blue,
            ),
          ],
        ),
        Divider(color: context.myTheme.onSurface),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Observer(builder: (context) {
      final state = recordController.state;

      if (state is! SuccessGetListRecordState &&
          state is! SuccessDeleteRecordState) {
        return const SizedBox();
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyElevatedButtonWidget(
            width: context.screenWidth * .4,
            label: Text(translate('home_page.button_start')),
            onPressed: _showInterstitialAd,
          ),
          const SizedBox(height: 15),
          if (!Platform.isWindows && !purchaseService.isPremium) ...[
            if (isBottomAdLoaded && state.records.isNotEmpty)
              SizedBox(
                height: myBottmBanner.size.height.toDouble(),
                width: myBottmBanner.size.width.toDouble(),
                child: AdWidget(ad: myBottmBanner),
              ),
          ],
        ],
      );
    });
  }

  Widget _buildAvgColumn(String label, int time, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: context.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          StopWatchTimer.getDisplayTime(time, hours: false),
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
