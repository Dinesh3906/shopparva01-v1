import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/providers.dart';
import '../../core/theme_tokens.dart';

// Provider to hold the generated kit state locally for the wizard
final localKitProvider = StateProvider<AsyncValue<dynamic>>((ref) => const AsyncValue.data(null));

class KitBuilderScreen extends ConsumerStatefulWidget {
  const KitBuilderScreen({super.key});

  @override
  ConsumerState<KitBuilderScreen> createState() => _KitBuilderScreenState();
}

class _KitBuilderScreenState extends ConsumerState<KitBuilderScreen> {
  int _currentStep = 0;
  
  // Step 1: Use Case
  String _selectedUseCase = 'Gaming';
  final List<String> _useCases = ['Gaming', 'Office', 'Content Creation', 'Streaming'];

  // Step 2: Components (Checkboxes)
  final Map<String, bool> _selectedComponents = {
    'CPU': true,
    'GPU': true,
    'RAM': true,
    'Storage': true,
    'Motherboard': true,
    'Case': true,
    'PSU': true,
    'Monitor': false,
    'Keyboard': false,
    'Mouse': false,
  };

  // Step 3: Budget
  double _budget = 1500;

  @override
  Widget build(BuildContext context) {
    final kitAsync = ref.watch(localKitProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Kit Builder')),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
             setState(() => _currentStep++);
          } else {
             // Generate Kit
             final query = '$_selectedUseCase PC with ${_selectedComponents.entries.where((e) => e.value).map((e) => e.key).join(", ")}';
             
             ref.read(localKitProvider.notifier).state = const AsyncValue.loading();
             
             ref.read(apiServiceProvider).generateKit(query, _budget).then((kit) {
                ref.read(localKitProvider.notifier).state = AsyncValue.data(kit);
                 _showKitResult(context, kit);
                           }).catchError((err) {
                ref.read(localKitProvider.notifier).state = AsyncValue.error(err, StackTrace.current);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $err')));
             });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          Step(
            title: const Text('Use Case'),
            content: Column(
              children: _useCases.map((useCase) => RadioListTile<String>(
                title: Text(useCase),
                value: useCase,
                groupValue: _selectedUseCase,
                onChanged: (val) => setState(() => _selectedUseCase = val!),
                activeColor: ThemeTokens.primary,
              )).toList(),
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Parts'),
             // Fix for overflow if list is long
            content: SizedBox(
               height: 300,
              child: ListView(
                children: _selectedComponents.keys.map((key) => CheckboxListTile(
                  title: Text(key),
                  value: _selectedComponents[key],
                  onChanged: (val) => setState(() => _selectedComponents[key] = val!),
                  activeColor: ThemeTokens.primary,
                )).toList(),
              ),
            ),
             isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Budget'),
            content: Column(
              children: [
                const SizedBox(height: 20),
                Text('\$${_budget.toInt()}', style: ThemeTokens.headlineLarge.copyWith(color: ThemeTokens.primary)),
                const SizedBox(height: 20),
                Slider(
                  value: _budget,
                  min: 500,
                  max: 5000,
                  divisions: 45,
                  label: _budget.round().toString(),
                  activeColor: ThemeTokens.primary,
                  onChanged: (val) => setState(() => _budget = val),
                ),
                 const Text("Adjust your maximum budget", style: TextStyle(color: Colors.grey)),
              ],
            ),
             isActive: _currentStep >= 2,
          ),
        ],
        controlsBuilder: (context, details) {
           final isLastStep = _currentStep == 2;
           final isLoading = kitAsync.isLoading;

           return Padding(
             padding: const EdgeInsets.only(top: 20),
             child: Row(
               children: [
                 if (isLoading)
                    const CircularProgressIndicator()
                 else
                   FilledButton(
                     onPressed: details.onStepContinue,
                     child: Text(isLastStep ? 'Generate Kit' : 'Next'),
                   ),
                 const SizedBox(width: 12),
                 if (_currentStep > 0 && !isLoading)
                   TextButton(
                     onPressed: details.onStepCancel,
                     child: const Text('Back'),
                   ),
               ],
             ),
           );
        },
      ),
    );
  }

  void _showKitResult(BuildContext context, dynamic kit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                   const Icon(Icons.check_circle, color: Colors.green, size: 48),
                   const SizedBox(height: 12),
                   Text('Kit Generated!', style: ThemeTokens.headlineMedium),
                   Text(kit.name, style: ThemeTokens.titleLarge),
                   Text('Total: \$${kit.totalPrice}', style: const TextStyle(color: ThemeTokens.primary, fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: kit.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = kit.items[index];
                  final hasOffers = item.offers.isNotEmpty;
                  final priceText = hasOffers
                      ? '\$${item.offers.first.price.toStringAsFixed(0)}'
                      : 'Price unavailable';

                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.images.first,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.computer),
                      ),
                    ), // Use Image.network directly for simplicity here or Cached
                    title: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(item.brand),
                    trailing: Text(
                      priceText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () => context.push('/product/${item.id}'),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () { 
                    Navigator.pop(context);
                    // Add to cart logic would go here
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kit added to cart!")));
                  },
                  child: const Text('Add All to Cart'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
