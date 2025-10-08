// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/material.dart';

import '../../../core/domain/entities/subscription_plan.dart';
import '../../../di/dependency_injection.dart';
import '../services/purchase_service.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  final PurchaseService purchaseService = getIt<PurchaseService>();

  @override
  void initState() {
    super.initState();
    purchaseService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('subscriptions_page.title_appbar')),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: purchaseService,
        builder: (_, __) => SingleChildScrollView(
          child: Column(
            children: [
              if (purchaseService.isPremium)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        translate('subscriptions_page.premium_active'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        translate('subscriptions_page.premium_thanks'),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else ...[
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        translate('subscriptions_page.upgrade_title'),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        translate('subscriptions_page.upgrade_subtitle'),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _BenefitsList(),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _AnnualPremiumPlanCard(
                        price: purchaseService.priceFor(
                          SubscriptionPlan.annual,
                        ),
                        onTap: () =>
                            purchaseService.buy(SubscriptionPlan.annual),
                      ),
                      const SizedBox(height: 16),
                      _PremiumPlanCard(
                        plan: SubscriptionPlan.monthly,
                        title: translate('subscriptions_page.plan_monthly'),
                        price: purchaseService.priceFor(
                          SubscriptionPlan.monthly,
                        ),
                        benefits: [
                          translate('subscriptions_page.benefit_no_ads'),
                          translate(
                            'subscriptions_page.benefit_monthly_billing',
                          ),
                        ],
                        onTap: () =>
                            purchaseService.buy(SubscriptionPlan.monthly),
                      ),
                      const SizedBox(height: 16),
                      _PremiumPlanCard(
                        plan: SubscriptionPlan.weekly,
                        title: translate('subscriptions_page.plan_weekly'),
                        price: purchaseService.priceFor(
                          SubscriptionPlan.weekly,
                        ),
                        benefits: [
                          translate('subscriptions_page.benefit_no_ads'),
                          translate(
                            'subscriptions_page.benefit_weekly_billing',
                          ),
                        ],
                        onTap: () =>
                            purchaseService.buy(SubscriptionPlan.weekly),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final benefits = [
      translate('subscriptions_page.feature_no_ads'),
      translate('subscriptions_page.feature_unlimited'),
      translate('subscriptions_page.feature_support'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('subscriptions_page.features_title'),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      benefit,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnualPremiumPlanCard extends StatelessWidget {
  final String price;
  final VoidCallback onTap;

  const _AnnualPremiumPlanCard({required this.price, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.workspace_premium,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate('subscriptions_page.plan_annual'),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              translate(
                                'subscriptions_page.annual_exclusive_feature',
                              ),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.dashboard_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              translate(
                                'subscriptions_page.annual_dashboard_title',
                              ),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        translate(
                          'subscriptions_page.annual_dashboard_description',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildBenefit(
                  context,
                  Icons.block,
                  translate('subscriptions_page.benefit_no_ads'),
                ),
                const SizedBox(height: 10),
                _buildBenefit(
                  context,
                  Icons.calendar_today,
                  translate('subscriptions_page.benefit_annual_billing'),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                price.isEmpty ? 'R\$ 199,90' : price,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _calculateOriginalPrice(price, 279.90),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _calculateDiscountPercentage(price, 279.90),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.upgrade, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          translate('subscriptions_page.button_subscribe'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -12,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade600, Colors.deepOrange.shade700],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  translate('subscriptions_page.save_most'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefit(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  String _calculateOriginalPrice(String currentPrice, double addValue) {
    if (currentPrice.isEmpty) {
      return 'R\$ ${(199.90 + addValue).toStringAsFixed(2).replaceAll('.', ',')}';
    }

    // Extrair valor numérico do preço (remove símbolos e converte vírgula para ponto)
    final cleanPrice = currentPrice
        .replaceAll(RegExp(r'[^\d,.]'), '')
        .replaceAll(',', '.');

    final numericPrice = double.tryParse(cleanPrice) ?? 199.90;
    final originalPrice = numericPrice + addValue;

    // Manter o formato do preço original (símbolo de moeda)
    final symbol = currentPrice.split(RegExp(r'[\d,.]')).first.trim();
    return '$symbol ${originalPrice.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String _calculateDiscountPercentage(String currentPrice, double addValue) {
    if (currentPrice.isEmpty) {
      final discount = (addValue / (199.90 + addValue) * 100).round();
      return '$discount% OFF';
    }

    final cleanPrice = currentPrice
        .replaceAll(RegExp(r'[^\d,.]'), '')
        .replaceAll(',', '.');

    final numericPrice = double.tryParse(cleanPrice) ?? 199.90;
    final originalPrice = numericPrice + addValue;
    final discount = (addValue / originalPrice * 100).round();

    return '$discount% OFF';
  }
}

class _PremiumPlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final String title;
  final String price;
  final String? discount;
  final bool isPopular;
  final List<String> benefits;
  final VoidCallback onTap;

  const _PremiumPlanCard({
    required this.plan,
    required this.title,
    required this.price,
    this.discount,
    this.isPopular = false,
    required this.benefits,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Definir valores a adicionar baseado no plano
    double addValue = 0;

    if (plan == SubscriptionPlan.monthly) {
      addValue = 30.00; // Adiciona R$ 30 ao preço real
    } else if (plan == SubscriptionPlan.weekly) {
      addValue = 10.00; // Adiciona R$ 10 ao preço real
    }

    final originalPrice = _calculateOriginalPriceForPlan(price, addValue);
    final discountPercentage = _calculateDiscountPercentageForPlan(
      price,
      addValue,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: isPopular
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: Border.all(
              color: isPopular
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300]!,
              width: isPopular ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                price.isEmpty
                                    ? (plan == SubscriptionPlan.monthly
                                          ? 'R\$ 29,90'
                                          : 'R\$ 14,90')
                                    : price,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (originalPrice.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Text(
                                  originalPrice,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2,
                                      ),
                                ),
                              ],
                            ],
                          ),
                          if (discountPercentage.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                discountPercentage,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isPopular)
                      Icon(
                        Icons.star_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ...benefits.map(
                  (benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            benefit,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: isPopular ? 4 : 2,
                    ),
                    child: Text(
                      translate('subscriptions_page.button_subscribe'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (discount != null)
          Positioned(
            top: -12,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade600, Colors.deepOrange.shade600],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                discount!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _calculateOriginalPriceForPlan(String currentPrice, double addValue) {
    if (currentPrice.isEmpty || addValue == 0) {
      return '';
    }

    // Extrair valor numérico do preço (remove símbolos e converte vírgula para ponto)
    final cleanPrice = currentPrice
        .replaceAll(RegExp(r'[^\d,.]'), '')
        .replaceAll(',', '.');

    final numericPrice = double.tryParse(cleanPrice);
    if (numericPrice == null) return '';

    final originalPrice = numericPrice + addValue;

    // Manter o formato do preço original (símbolo de moeda)
    final symbol = currentPrice.split(RegExp(r'[\d,.]')).first.trim();
    return '$symbol ${originalPrice.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String _calculateDiscountPercentageForPlan(
    String currentPrice,
    double addValue,
  ) {
    if (currentPrice.isEmpty || addValue == 0) {
      return '';
    }

    final cleanPrice = currentPrice
        .replaceAll(RegExp(r'[^\d,.]'), '')
        .replaceAll(',', '.');

    final numericPrice = double.tryParse(cleanPrice);
    if (numericPrice == null) return '';

    final originalPrice = numericPrice + addValue;
    final discount = (addValue / originalPrice * 100).round();

    return '$discount% OFF';
  }
}
