import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme_tokens.dart';

class PriceChart extends StatelessWidget {
  final List<({String date, double price})> history;

  const PriceChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No price history available')));
    }

    final prices = history.map((e) => e.price).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final buffer = (maxPrice - minPrice) * 0.2;

    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
            color: ThemeTokens.surfaceLight,
            borderRadius: BorderRadius.circular(ThemeTokens.r16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
         ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price History', style: ThemeTokens.titleLarge),
            const SizedBox(height: 24),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: (maxPrice - minPrice) / 3, // Roughly 3 lines
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[200], strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                     rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                     topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                     bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                             if (value.toInt() >= 0 && value.toInt() < history.length) {
                               // Show date for every few points to avoid clutter
                               if (value.toInt() % 2 == 0) {
                                  // Parse date string assuming YYYY-MM-DD
                                  final dateParts = history[value.toInt()].date.split('-');
                                  if (dateParts.length > 1) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text('${dateParts[1]}/${dateParts[2]}', style: const TextStyle(fontSize: 10)),
                                      );
                                  }
                               }
                             }
                             return const SizedBox();
                          },
                        ),
                     ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: minPrice - buffer,
                  maxY: maxPrice + buffer,
                  lineBarsData: [
                    LineChartBarData(
                      spots: history.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.price)).toList(),
                      isCurved: true,
                      color: ThemeTokens.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: ThemeTokens.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
