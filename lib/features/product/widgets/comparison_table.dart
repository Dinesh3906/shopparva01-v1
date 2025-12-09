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

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeTokens.surfaceLight,
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(ThemeTokens.r12)),
            ),
             child: Text('Price Comparison', style: ThemeTokens.titleLarge),
          ),
          if (sortedOffers.isEmpty)
            const Padding(padding: EdgeInsets.all(16), child: Text("No offers available")),
          
          ...sortedOffers.asMap().entries.map((entry) {
             final index = entry.key;
             final offer = entry.value;
             final isBest = index == 0;

             return Container(
               decoration: BoxDecoration(
                 color: isBest ? Colors.green.withValues(alpha: 0.05) : null,
                 border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
               ),
               child: ListTile(
                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 leading: CircleAvatar(
                   backgroundColor: Colors.grey[200],
                   child: Text(offer.marketplace[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                 ),
                 title: Text(offer.marketplace, style: const TextStyle(fontWeight: FontWeight.bold)),
                 subtitle: Text('Sold by ${offer.seller}'),
                 trailing: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         Text(
                           '\$${offer.price.toStringAsFixed(2)}',
                           style: TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                             color: isBest ? Colors.green : Colors.black,
                           ),
                         ),
                         if (isBest)
                           Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('BEST DEAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                           ),
                       ],
                     ),
                     const SizedBox(width: 16),
                     const Icon(Icons.open_in_new, size: 20, color: Colors.grey),
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
