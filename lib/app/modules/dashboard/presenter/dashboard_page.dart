import 'dart:io';

import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/di/dependency_injection.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/controller/dashboard_controller.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/widgets/group_progress_widget.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/widgets/insight_card_widget.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/widgets/recommendation_card_widget.dart';
import 'package:cuber_timer/app/shared/components/my_circular_progress_widget.dart';
import 'package:cuber_timer/app/shared/components/no_data_widget.dart';
import 'package:cuber_timer/app/shared/services/ad_service.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../modules/config/presenter/services/purchase_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController dashboardController = getIt<DashboardController>();
  final PurchaseService purchaseService = getIt<PurchaseService>();
  final IAdService adService = getIt<IAdService>();

  late BannerAd myBanner;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    if (!Platform.isWindows) {
      _loadAds();
    }

    dashboardController.loadAllRecords();
  }

  Future<void> _loadAds() async {
    isAdLoaded = false;
    setState(() {});

    myBanner = await adService.loadBanner(
      androidAdId: 'ca-app-pub-3940256099942544/6300978111', // Test ID
      iosAdId: 'ca-app-pub-3940256099942544/2934735716', // Test ID
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
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
        body: SafeArea(
          child: Observer(
            builder: (context) {
              if (dashboardController.isLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyCircularProgressWidget(),
                      SizedBox(height: 16),
                      Text('Loading dashboard...'),
                    ],
                  ),
                );
              }

              if (dashboardController.errorMessage != null) {
                return Center(
                  child: Text(
                    dashboardController.errorMessage!,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                );
              }

              if (dashboardController.totalSolves == 0) {
                return NoDataWidget(
                  text: translate('dashboard.no_data'),
                );
              }

              return RefreshIndicator(
                onRefresh: () => dashboardController.loadAllRecords(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner superior
                      if (!Platform.isWindows && !purchaseService.isPremium) ...[
                        if (isAdLoaded)
                          Center(
                            child: SizedBox(
                              height: myBanner.size.height.toDouble(),
                              width: myBanner.size.width.toDouble(),
                              child: AdWidget(ad: myBanner),
                            ),
                          ),
                        const SizedBox(height: 16),
                      ],

                      // Título
                      Text(
                        translate('dashboard.title'),
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        translate('dashboard.subtitle'),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.myTheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Cards de insights
                      _buildInsightsSection(),
                      const SizedBox(height: 24),

                      // Progresso por grupo
                      _buildGroupProgressSection(),
                      const SizedBox(height: 24),

                      // Recomendações
                      _buildRecommendationsSection(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate('dashboard.insights_title'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Observer(
          builder: (context) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InsightCardWidget(
                        title: translate('dashboard.total_solves'),
                        value: '${dashboardController.totalSolves}',
                        icon: Icons.timer,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InsightCardWidget(
                        title: translate('dashboard.best_time'),
                        value: dashboardController.bestTimeOverall > 0
                            ? StopWatchTimer.getDisplayTime(
                                dashboardController.bestTimeOverall,
                                hours: false,
                              )
                            : '-',
                        icon: Icons.emoji_events,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InsightCardWidget(
                        title: translate('dashboard.average_time'),
                        value: dashboardController.averageTime > 0
                            ? StopWatchTimer.getDisplayTime(
                                dashboardController.averageTime,
                                hours: false,
                              )
                            : '-',
                        icon: Icons.speed,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InsightCardWidget(
                        title: translate('dashboard.most_practiced'),
                        value: dashboardController.mostPracticedGroup.isNotEmpty
                            ? dashboardController.mostPracticedGroup
                            : '-',
                        icon: Icons.favorite,
                        color: Colors.red,
                        subtitle: dashboardController.mostPracticedGroup.isNotEmpty
                            ? '${dashboardController.solvesByGroup[dashboardController.mostPracticedGroup]} solves'
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildGroupProgressSection() {
    return Observer(
      builder: (context) {
        final solvesByGroup = dashboardController.solvesByGroup;
        final bestTimeByGroup = dashboardController.bestTimeByGroup;

        if (solvesByGroup.isEmpty) return const SizedBox.shrink();

        final maxSolves = solvesByGroup.values
            .reduce((a, b) => a > b ? a : b);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('dashboard.progress_by_group'),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...solvesByGroup.entries.map((entry) {
              return GroupProgressWidget(
                group: entry.key,
                solveCount: entry.value,
                bestTime: bestTimeByGroup[entry.key] ?? -1,
                maxSolves: maxSolves,
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildRecommendationsSection() {
    return Observer(
      builder: (context) {
        final recommendations = dashboardController.practiceRecommendations;

        if (recommendations.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('dashboard.recommendations_title'),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...recommendations.map((recommendation) {
              return RecommendationCardWidget(
                recommendation: recommendation,
              );
            }),
          ],
        );
      },
    );
  }
}
