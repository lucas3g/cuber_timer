import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/di/dependency_injection.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/controller/dashboard_controller.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/widgets/distribution_boxplot_widget.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/widgets/group_progress_widget.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/widgets/heatmap_widget.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/widgets/insight_card_widget.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/widgets/performance_bar_chart_widget.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/widgets/recommendation_card_widget.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/widgets/time_series_chart_widget.dart';
import 'package:cuber_timer/app/shared/components/my_circular_progress_widget.dart';
import 'package:cuber_timer/app/shared/components/no_data_widget.dart';
import 'package:cuber_timer/app/shared/services/ad_service.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../subscriptions/services/purchase_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController dashboardController = getIt<DashboardController>();
  final PurchaseService purchaseService = getIt<PurchaseService>();
  final IAdService adService = getIt<IAdService>();

  @override
  void initState() {
    super.initState();

    dashboardController.loadAllRecords();
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
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const MyCircularProgressWidget(),
                      const SizedBox(height: 16),
                      Text(translate('dashboard.loading')),
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
                return NoDataWidget(text: translate('dashboard.no_data'));
              }

              return RefreshIndicator(
                onRefresh: () async => dashboardController.loadAllRecords(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          color: context.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Cards de insights (KPIs básicos)
                      _buildInsightsSection(),
                      const SizedBox(height: 10),

                      // Advanced Metrics KPIs
                      if (dashboardController.analytics.hasEnoughDataForAo5)
                        _buildAdvancedMetricsSection(),
                      if (dashboardController.analytics.hasEnoughDataForAo5)
                        const SizedBox(height: 10),

                      // Intelligent Insights
                      _buildIntelligentInsightsSection(),
                      const SizedBox(height: 10),

                      // Time Series Chart
                      if (dashboardController.analytics.timeSeriesData.length >=
                          5)
                        Observer(
                          builder: (context) => TimeSeriesChartWidget(
                            analytics: dashboardController.analytics,
                          ),
                        ),
                      if (dashboardController.analytics.timeSeriesData.length >=
                          5)
                        const SizedBox(height: 16),

                      // Performance Bar Chart
                      if (dashboardController.analytics.cubeMetrics.isNotEmpty)
                        Observer(
                          builder: (context) => PerformanceBarChartWidget(
                            analytics: dashboardController.analytics,
                          ),
                        ),
                      if (dashboardController.analytics.cubeMetrics.isNotEmpty)
                        const SizedBox(height: 16),

                      // Distribution Boxplot
                      if (dashboardController.analytics.cubeMetrics.isNotEmpty)
                        Observer(
                          builder: (context) => DistributionBoxplotWidget(
                            analytics: dashboardController.analytics,
                          ),
                        ),
                      if (dashboardController.analytics.cubeMetrics.isNotEmpty)
                        const SizedBox(height: 16),

                      // Heatmap
                      if (dashboardController.analytics.heatmapData.isNotEmpty)
                        Observer(
                          builder: (context) => HeatmapWidget(
                            analytics: dashboardController.analytics,
                          ),
                        ),
                      if (dashboardController.analytics.heatmapData.isNotEmpty)
                        const SizedBox(height: 24),

                      // Model Analysis
                      if (dashboardController.analytics.cubeMetrics.length > 1)
                        _buildModelAnalysisSection(),
                      if (dashboardController.analytics.cubeMetrics.length > 1)
                        const SizedBox(height: 10),

                      // Progresso por grupo (existente)
                      _buildGroupProgressSection(),
                      const SizedBox(height: 10),

                      // Recomendações (existente)
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
            return SizedBox(
              height: context.screenHeight * 0.4,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  InsightCardWidget(
                    title: translate('dashboard.total_solves'),
                    value: '${dashboardController.totalSolves}',
                    icon: Icons.timer,
                    color: Colors.blue,
                  ),
                  InsightCardWidget(
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
                  InsightCardWidget(
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
                  InsightCardWidget(
                    title: translate('dashboard.most_practiced'),
                    value: dashboardController.mostPracticedGroup.isNotEmpty
                        ? dashboardController.mostPracticedGroup
                        : '-',
                    icon: Icons.favorite,
                    color: Colors.red,
                    subtitle: dashboardController.mostPracticedGroup.isNotEmpty
                        ? '${dashboardController.solvesByGroup[dashboardController.mostPracticedGroup]} ${translate('dashboard.solves_count')}'
                        : null,
                  ),
                ],
              ),
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

        final maxSolves = solvesByGroup.values.reduce((a, b) => a > b ? a : b);

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
              return RecommendationCardWidget(recommendation: recommendation);
            }),
          ],
        );
      },
    );
  }

  Widget _buildAdvancedMetricsSection() {
    return Observer(
      builder: (context) {
        final analytics = dashboardController.analytics;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('dashboard.advanced_metrics_title'),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                if (analytics.currentAo5 != null)
                  InsightCardWidget(
                    title: translate('dashboard.kpi_ao5_label'),
                    value: StopWatchTimer.getDisplayTime(
                      analytics.currentAo5!,
                      hours: false,
                    ),
                    icon: Icons.trending_down,
                    color: Colors.blue.shade600,
                  ),
                if (analytics.currentAo12 != null)
                  InsightCardWidget(
                    title: translate('dashboard.kpi_ao12_label'),
                    value: StopWatchTimer.getDisplayTime(
                      analytics.currentAo12!,
                      hours: false,
                    ),
                    icon: Icons.analytics,
                    color: Colors.green.shade600,
                  ),
                InsightCardWidget(
                  title: translate('dashboard.kpi_consistency_label'),
                  value:
                      '${(analytics.consistencyScoreOverall * 100).toStringAsFixed(0)}%',
                  icon: Icons.timeline,
                  color: analytics.consistencyScoreOverall > 0.8
                      ? Colors.green.shade600
                      : Colors.orange.shade600,
                ),
                if (analytics.hasEnoughDataForTrends)
                  InsightCardWidget(
                    title: translate('dashboard.kpi_improvement_label'),
                    value: analytics.improvementRate < 0
                        ? '${analytics.improvementRate.abs().toStringAsFixed(1)}%'
                        : '-',
                    icon: analytics.isImproving
                        ? Icons.trending_up
                        : Icons.trending_flat,
                    color: analytics.isImproving
                        ? Colors.green.shade600
                        : Colors.grey.shade600,
                    subtitle: analytics.isImproving
                        ? translate('dashboard.improving_badge').replaceAll(
                            '{percent}',
                            analytics.improvementRate.abs().toStringAsFixed(1),
                          )
                        : null,
                  ),
                if (analytics.bestPerformingCube != null)
                  InsightCardWidget(
                    title: translate('dashboard.kpi_best_cube_label'),
                    value: analytics.bestPerformingCube!,
                    icon: Icons.emoji_events,
                    color: Colors.amber.shade700,
                  ),
                if (analytics.outliers.isNotEmpty)
                  InsightCardWidget(
                    title: translate('dashboard.kpi_outliers_label'),
                    value: '${analytics.outliers.length}',
                    icon: Icons.warning_amber,
                    color: Colors.red.shade600,
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildIntelligentInsightsSection() {
    return Observer(
      builder: (context) {
        final insights = dashboardController.intelligentInsights;

        if (insights.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('dashboard.insights_section_title'),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...insights.map((insight) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.amber.shade700,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          insight,
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildModelAnalysisSection() {
    return Observer(
      builder: (context) {
        final summary = dashboardController.performanceSummary;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('dashboard.model_analysis_title'),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Best Performers
            if (summary.bestPerformers.isNotEmpty) ...[
              Text(
                translate('dashboard.best_performers_title'),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 8),
              ...summary.bestPerformers.map((metric) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(Icons.stars, color: Colors.green.shade700),
                    title: Text(
                      metric.cubeModel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${translate('dashboard.median')}: ${(metric.medianTime / 1000).toStringAsFixed(2)}s • '
                      '${translate('dashboard.consistency')}: ${(metric.consistencyScore * 100).toStringAsFixed(0)}%',
                    ),
                    trailing: Text(
                      '${metric.totalSolves}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 10),
            ],

            // Needs Practice
            if (summary.needsPractice.isNotEmpty) ...[
              Text(
                translate('dashboard.needs_practice_title'),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(height: 8),
              ...summary.needsPractice.map((metric) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      Icons.fitness_center,
                      color: Colors.orange.shade700,
                    ),
                    title: Text(
                      metric.cubeModel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${translate('dashboard.median')}: ${(metric.medianTime / 1000).toStringAsFixed(2)}s • '
                      '+${metric.percentDifferenceFromBest.toStringAsFixed(1)}% ${translate('dashboard.percent_from_best')}',
                    ),
                    trailing: Text(
                      '${metric.totalSolves}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ],
        );
      },
    );
  }
}
