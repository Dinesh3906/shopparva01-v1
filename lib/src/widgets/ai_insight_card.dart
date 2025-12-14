import 'package:flutter/material.dart';

import '../../core/theme_tokens.dart';

class AIInsightCard extends StatelessWidget {
  const AIInsightCard({
    super.key,
    required this.trend,
    required this.trendPercentage,
    required this.currentPrice,
    required this.lowestPrice,
    required this.highestPrice,
    required this.averagePrice,
  });

  final String trend; // 'up', 'down', 'stable'
  final double trendPercentage;
  final double currentPrice;
  final double lowestPrice;
  final double highestPrice;
  final double averagePrice;

  @override
  Widget build(BuildContext context) {
    final insight = _generateInsight();
    final recommendation = _generateRecommendation();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeTokens.primary.withOpacity(0.2),
            ThemeTokens.accent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeTokens.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeTokens.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: ThemeTokens.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightRow(
            icon: _getTrendIcon(),
            color: _getTrendColor(),
            title: 'Price Trend',
            value: insight,
          ),
          const SizedBox(height: 12),
          _buildInsightRow(
            icon: Icons.shopping_bag_outlined,
            color: _getRecommendationColor(),
            title: 'Recommendation',
            value: recommendation,
          ),
          const SizedBox(height: 16),
          _buildPriceStats(),
        ],
      ),
    );
  }

  Widget _buildInsightRow({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceStats() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeTokens.surfaceDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Low', '\$${lowestPrice.toStringAsFixed(0)}', Colors.green),
          _buildStatItem('Avg', '\$${averagePrice.toStringAsFixed(0)}', Colors.white70),
          _buildStatItem('High', '\$${highestPrice.toStringAsFixed(0)}', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _generateInsight() {
    if (trend == 'down') {
      return 'Price dropping ${trendPercentage.abs().toStringAsFixed(1)}%';
    } else if (trend == 'up') {
      return 'Price rising ${trendPercentage.toStringAsFixed(1)}%';
    } else {
      return 'Price stable (±${trendPercentage.abs().toStringAsFixed(1)}%)';
    }
  }

  String _generateRecommendation() {
    final priceDiffFromLow = ((currentPrice - lowestPrice) / lowestPrice * 100);
    final priceDiffFromHigh = ((highestPrice - currentPrice) / highestPrice * 100);

    if (trend == 'down' && priceDiffFromLow < 10) {
      return 'Great time to buy! Price near lowest.';
    } else if (trend == 'down') {
      return 'Good opportunity - price is falling.';
    } else if (trend == 'up' && priceDiffFromHigh < 10) {
      return 'Wait - price near peak.';
    } else if (currentPrice < averagePrice) {
      return 'Below average - consider buying.';
    } else if (currentPrice > averagePrice * 1.1) {
      return 'Above average - wait for drop.';
    } else {
      return 'Monitor for a few more days.';
    }
  }

  IconData _getTrendIcon() {
    switch (trend) {
      case 'down':
        return Icons.trending_down_rounded;
      case 'up':
        return Icons.trending_up_rounded;
      default:
        return Icons.trending_flat_rounded;
    }
  }

  Color _getTrendColor() {
    switch (trend) {
      case 'down':
        return Colors.green;
      case 'up':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Color _getRecommendationColor() {
    final priceDiffFromLow = ((currentPrice - lowestPrice) / lowestPrice * 100);
    
    if (trend == 'down' || currentPrice < averagePrice) {
      return Colors.green;
    } else if (priceDiffFromLow > 15) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }
}
