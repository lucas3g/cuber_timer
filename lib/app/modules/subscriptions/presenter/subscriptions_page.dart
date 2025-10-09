// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/core/domain/entities/app_global.dart';
import 'package:cuber_timer/app/core/domain/entities/named_routes.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/material.dart';

import '../../../core/domain/entities/subscription_plan.dart';
import '../../../di/dependency_injection.dart';
import '../domain/entities/purchase_state.dart';
import '../services/purchase_service.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  final PurchaseService purchaseService = getIt<PurchaseService>();
  SubscriptionPlan selectedPlan = SubscriptionPlan.annual;
  StreamSubscription<PurchaseState>? _purchaseSubscription;

  @override
  void initState() {
    super.initState();
    purchaseService.init();
    _listenToPurchases();
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }

  void _listenToPurchases() {
    _purchaseSubscription = purchaseService.stream.listen((state) {
      if (!mounted) return;
      if (state == PurchaseState.success) {
        purchaseService.controller.add(PurchaseState.idle);
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    if (!mounted) return;

    final isAnnualPurchase = AppGlobal.instance.isAnnualPremium;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 64,
                color: context.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              translate('subscriptions_page.success_title'),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              translate('subscriptions_page.success_message'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              translate('subscriptions_page.success_description'),
              style: TextStyle(
                fontSize: 14,
                color: context.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop(); // Close dialog
                }

                if (!mounted) return;

                // Se comprou plano anual, volta para a página principal e recarrega
                if (isAnnualPurchase) {
                  // Volta para a rota principal, recarregando a MainNavigatorPage
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    NamedRoutes.mainNavigator.route,
                    (route) => false,
                  );
                } else {
                  // Para outros planos, apenas fecha a página de assinaturas
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.primaryContainer,
                foregroundColor: context.colorScheme.onSurface,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                translate('subscriptions_page.success_button'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness == Brightness.dark;
    final isAnnual = AppGlobal.instance.isAnnualPremium;
    final isPremium = purchaseService.isPremium;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: AnimatedBuilder(
        animation: purchaseService,
        builder: (_, __) {
          if (isAnnual) {
            return _buildAnnualPremiumView(context);
          } else if (isPremium) {
            return _buildUpgradeView(context);
          } else {
            return _buildSubscriptionView(context);
          }
        },
      ),
    );
  }

  Widget _buildAnnualPremiumView(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Close Button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              padding: const EdgeInsets.all(20),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        size: 80,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      translate('subscriptions_page.premium_annual_active'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      translate('subscriptions_page.premium_annual_thanks'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text(
                        translate('subscriptions_page.button_close'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeView(BuildContext context) {
    final isDark = context.brightness == Brightness.dark;
    final currentPlan = AppGlobal.instance.plan;

    return SafeArea(
      child: Column(
        children: [
          // Close Button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              padding: const EdgeInsets.all(20),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Current Plan Badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${translate('subscriptions_page.current_plan')}: ${_getPlanName(currentPlan)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Hero Section - Dashboard Premium
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          context.colorScheme.primaryContainer,
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard_rounded,
                              color: context.colorScheme.onSurface,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                translate(
                                  'subscriptions_page.annual_dashboard_title',
                                ),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          translate(
                            'subscriptions_page.annual_dashboard_description',
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.9),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.workspace_premium_rounded,
                                color: context.colorScheme.onSurface,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                translate(
                                  'subscriptions_page.annual_exclusive_feature',
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translate('subscriptions_page.upgrade_from_plan'),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    translate('subscriptions_page.upgrade_to_annual'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 36),

                  // Annual Plan Card Only
                  _buildPlanCard(
                    context,
                    plan: SubscriptionPlan.annual,
                    title: translate('subscriptions_page.plan_annual'),
                    saveLabel: '58% OFF',
                    isPopular: true,
                    hasDashboard: true,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // CTA Button
          Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              top: 16,
            ),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              border: Border(
                top: BorderSide(
                  color: context.colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: FilledButton(
              onPressed: () => purchaseService.buy(SubscriptionPlan.annual),
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.primaryContainer,
                foregroundColor: context.colorScheme.onSurface,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.5),
              ),
              child: Text(
                translate('subscriptions_page.button_upgrade'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPlanName(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.weekly:
        return translate('subscriptions_page.plan_weekly');
      case SubscriptionPlan.monthly:
        return translate('subscriptions_page.plan_monthly');
      case SubscriptionPlan.annual:
        return translate('subscriptions_page.plan_annual');
      case SubscriptionPlan.free:
        return 'Free';
    }
  }

  Widget _buildSubscriptionView(BuildContext context) {
    final isDark = context.brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        children: [
          // Close Button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              padding: const EdgeInsets.all(20),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Hero Section - Dashboard Premium
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          context.colorScheme.primaryContainer,
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard_rounded,
                              color: context.colorScheme.onSurface,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                translate(
                                  'subscriptions_page.annual_dashboard_title',
                                ),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          translate(
                            'subscriptions_page.annual_dashboard_description',
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.9),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.workspace_premium_rounded,
                                color: context.colorScheme.onSurface,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                translate(
                                  'subscriptions_page.annual_exclusive_feature',
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translate('subscriptions_page.upgrade_title'),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    translate('subscriptions_page.upgrade_subtitle'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Benefits
                  _buildBenefit(
                    context,
                    Icons.block_rounded,
                    translate('subscriptions_page.feature_no_ads'),
                  ),
                  const SizedBox(height: 18),
                  _buildBenefit(
                    context,
                    Icons.all_inclusive_rounded,
                    translate('subscriptions_page.feature_unlimited'),
                  ),
                  const SizedBox(height: 18),
                  _buildBenefit(
                    context,
                    Icons.support_agent_rounded,
                    translate('subscriptions_page.feature_support'),
                  ),

                  const SizedBox(height: 20),

                  // Plans
                  _buildPlanCard(
                    context,
                    plan: SubscriptionPlan.annual,
                    title: translate('subscriptions_page.plan_annual'),
                    saveLabel: '58% OFF',
                    isPopular: true,
                    hasDashboard: true,
                  ),

                  const SizedBox(height: 12),

                  _buildPlanCard(
                    context,
                    plan: SubscriptionPlan.monthly,
                    title: translate('subscriptions_page.plan_monthly'),
                  ),

                  const SizedBox(height: 12),

                  _buildPlanCard(
                    context,
                    plan: SubscriptionPlan.weekly,
                    title: translate('subscriptions_page.plan_weekly'),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // CTA Button
          Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              top: 16,
            ),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              border: Border(
                top: BorderSide(
                  color: context.colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: FilledButton(
              onPressed: () => purchaseService.buy(selectedPlan),
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.primaryContainer,
                foregroundColor: context.colorScheme.onSurface,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.5),
              ),
              child: Text(
                translate('subscriptions_page.button_subscribe'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 24, color: context.colorScheme.onSurface),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required SubscriptionPlan plan,
    required String title,
    String? saveLabel,
    bool isPopular = false,
    bool hasDashboard = false,
  }) {
    final isSelected = selectedPlan == plan;
    final price = purchaseService.priceFor(plan);
    final displayPrice = price;

    final isDark = context.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = plan;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primaryContainer
              : (isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? null
              : (hasDashboard
                    ? Border.all(
                        color: context.colorScheme.primaryContainer,
                        width: 2,
                      )
                    : Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.1),
                        width: 1,
                      )),
          boxShadow: hasDashboard && !isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            Colors.orange.shade600,
                            Colors.deepOrange.shade600,
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            Colors.orange.shade400,
                            Colors.deepOrange.shade400,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  translate('subscriptions_page.save_most'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? context.colorScheme.onSurface
                        : Colors.white,
                  ),
                ),
              ),
            ],
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? context.colorScheme.onSurface
                                    : context.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      displayPrice,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? context.colorScheme.onSurface
                            : context.colorScheme.onSurface,
                      ),
                    ),
                    if (saveLabel != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        saveLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.9)
                              : Colors.green,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (hasDashboard) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.15)
                      : Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.dashboard_rounded,
                      size: 16,
                      color: isSelected
                          ? context.colorScheme.onSurface
                          : context.colorScheme.onSurface,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        translate('subscriptions_page.dashboard_included'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? context.colorScheme.onSurface
                              : context.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
