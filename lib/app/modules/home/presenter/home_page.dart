// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:async';
import 'dart:io';

import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/core/data/clients/local_database/schemas/record.dart';
import 'package:cuber_timer/app/core/domain/entities/named_routes.dart';
import 'package:cuber_timer/app/di/dependency_injection.dart';
import 'package:cuber_timer/app/modules/config/presenter/controller/config_controller.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_controller.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_states.dart';
import 'package:cuber_timer/app/modules/home/presenter/widgets/card_record_widget.dart';
import 'package:cuber_timer/app/shared/components/my_circular_progress_widget.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:cuber_timer/app/shared/components/my_snackbar.dart';
import 'package:cuber_timer/app/shared/components/no_data_widget.dart';
import 'package:cuber_timer/app/shared/utils/cube_types_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final recordController = getIt<RecordController>();
  final configController = getIt<ConfigController>();

  int _currentTabIndex = 0;

  String selectedGroup = '3x3';

  late BannerAd myBanner;
  late BannerAd myBottmBanner;
  bool isTopAdLoaded = false;
  bool isBottomAdLoaded = false;

  InterstitialAd? _interstitialAd;

  late Map<String, List<RecordEntity>> sortedGroupedRecords;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    if (!Platform.isWindows) {
      initBannerAd();
      initBottomBannerAd();
      _createInterstitialAd();
    }

    getFiveRecordsByGroup();

    autorun((_) async {
      final state = recordController.state;

      if (state is ErrorRecordState) {
        MySnackBar(
          title: 'Opss...',
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

    // Verificar se houve mudança no número de tabs
    if (newTabCount > 0) {
      _recreateTabController(newTabCount);
    }
  }

  void _recreateTabController(int newLength) {
    // Salvar o índice atual antes de dispor o controller
    final currentIndex = _tabController?.index ?? 0;

    // Remover listener e dispor controller anterior
    _tabController?.removeListener(_onTabChanged);

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

      // Forçar rebuild
      if (mounted) {
        setState(() {});
      }
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
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();

    // Dispose outros recursos...
    myBanner.dispose();
    myBottmBanner.dispose();
    _interstitialAd?.dispose();

    super.dispose();
  }

  Future<void> initBannerAd() async {
    isTopAdLoaded = false;
    setState(() {});

    myBanner = BannerAd(
      adUnitId: bannerTopID,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isTopAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );

    await myBanner.load();
  }

  Future<void> initBottomBannerAd() async {
    isBottomAdLoaded = false;
    setState(() {});
    myBottmBanner = BannerAd(
      adUnitId: bannerBottomID,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isBottomAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );

    await myBottmBanner.load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: intersticialID,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
          setState(() {});
        },
        onAdFailedToLoad: (_) {
          _interstitialAd = null;
          _createInterstitialAd();
          setState(() {});
        },
      ),
    );
  }

  Future<void> _showInterstitialAd() async {
    if (_interstitialAd == null || configController.isAdRemoved) {
      await Navigator.pushReplacementNamed(context, NamedRoutes.timer.route);
      await getFiveRecordsByGroup();
      if (!Platform.isWindows) {
        initBannerAd();
        initBottomBannerAd();
      }
      _createInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) async {
        await Navigator.pushReplacementNamed(context, NamedRoutes.timer.route);

        await getFiveRecordsByGroup();
        if (!Platform.isWindows) {
          initBannerAd();
          initBottomBannerAd();
        }
        ad.dispose();

        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) async {
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;

    setState(() {});

    _createInterstitialAd();
  }

  Future<void> getFiveRecordsByGroup() async =>
      await recordController.getFiveRecordsByGroup();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Observer(builder: (context) {
                if (_tabController == null || sortedGroupedRecords.isEmpty) {
                  return NoDataWidget(
                    text: context.translate.homePage.listEmpty,
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
                        context.translate.homePage.textLoading,
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  );
                }

                final records = state.records;

                if (records.isEmpty) {
                  return NoDataWidget(
                    text: context.translate.homePage.listEmpty,
                  );
                }

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banners...
                      if (!Platform.isWindows &&
                          !configController.isAdRemoved) ...[
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
                              context.translate.homePage.titleList,
                              style: context.textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pushNamed(
                                context, NamedRoutes.config.route),
                            icon: const Icon(Icons.settings),
                          ),
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
                          context.translate.homePage.buttonMoreRecords,
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
              context.translate.homePage.titleAvg,
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
              context.translate.homePage.best,
              recordController.bestTime(selectedGroup),
              Colors.amber,
            ),
            _buildAvgColumn(
              context.translate.homePage.avg5,
              recordController.avgFive(selectedGroup),
              Colors.green,
            ),
            _buildAvgColumn(
              context.translate.homePage.avg12,
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
            label: Text(context.translate.homePage.buttonStart),
            onPressed: _showInterstitialAd,
          ),
          const SizedBox(height: 15),
          if (!Platform.isWindows && !configController.isAdRemoved) ...[
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
