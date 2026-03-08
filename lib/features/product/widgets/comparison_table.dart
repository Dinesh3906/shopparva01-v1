import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../core/theme_tokens.dart';

class ComparisonTable extends StatelessWidget {
  final List<Offer> offers;

  const ComparisonTable({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    // Sort offers by price ascending
    final sortedOffers = [...offers]..sort((a, b) => a.price.compareTo(b.price));

    return Container(
      decoration: BoxDecoration(
        color: ThemeTokens.surfaceDark,
        borderRadius: BorderRadius.circular(ThemeTokens.r16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeTokens.surfaceMuted,
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(ThemeTokens.r16)),
            ),
             child: Text('Price Comparison', style: ThemeTokens.titleLarge.copyWith(color: Colors.white)),
          ),
          if (sortedOffers.isEmpty)
            Padding(padding: const EdgeInsets.all(16), child: Text("No offers available", style: TextStyle(color: Colors.white.withValues(alpha: 0.5)))),
          
          ...sortedOffers.asMap().entries.map((entry) {
             final index = entry.key;
             final offer = entry.value;
             final isBest = index == 0;

             return Container(
               decoration: BoxDecoration(
                 color: isBest ? ThemeTokens.primary.withValues(alpha: 0.05) : null,
                 border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
               ),
               child: ListTile(
                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 leading: CircleAvatar(
                   backgroundColor: ThemeTokens.surfaceMuted,
                   child: Text(offer.marketplace[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                 ),
                 title: Text(offer.marketplace, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                 subtitle: Text('Sold by ${offer.seller}', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
                 trailing: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         Text(
                           '₹${offer.price.toStringAsFixed(0)}',
                           style: TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                             color: isBest ? ThemeTokens.accent : Colors.white,
                           ),
                         ),
                         if (isBest)
                           Container(
                               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                               decoration: BoxDecoration(
                                 color: ThemeTokens.accent,
                                 borderRadius: BorderRadius.circular(4),
                               ),
                               child: const Text('BEST DEAL', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                           ),
                       ],
                     ),
                     const SizedBox(width: 16),
                     Icon(Icons.open_in_new, size: 20, color: Colors.white.withValues(alpha: 0.3)),
                   ],
                 ),
                 onTap: () {
                    // Launch URL logic here
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening ${offer.url}')));
                 },
               ),
             );
          }),
        ],
      ),
    );
  }
}
