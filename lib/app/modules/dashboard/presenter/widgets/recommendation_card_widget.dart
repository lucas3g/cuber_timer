import 'package:flutter/material.dart';
import 'package:cuber_timer/app/core/constants/constants.dart';

class RecommendationCardWidget extends StatelessWidget {
  final String recommendation;
  final IconData icon;

  const RecommendationCardWidget({
    super.key,
    required this.recommendation,
    this.icon = Icons.lightbulb_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recommendation,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
