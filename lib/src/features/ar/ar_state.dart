import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- VISUAL ASSETS ---
const _models = [
  ArModel(id: 'f_light', path: 'model_female_light.png', name: 'Sarah', type: 'Female', tone: 'Light', faceShape: 'Oval', aiScore: '98%', landmarks: FaceLandmarks(eyeY: 0.42, lipY: 0.65, neckY: 0.82, noseY: 0.52, earY: 0.50)),
  ArModel(id: 'f_med', path: 'model_female_medium.png', name: 'Priya', type: 'Female', tone: 'Medium', faceShape: 'Round', aiScore: '96%', landmarks: FaceLandmarks(eyeY: 0.44, lipY: 0.66, neckY: 0.84, noseY: 0.54, earY: 0.52)),
  ArModel(id: 'f_deep', path: 'model_female_deep.png', name: 'Maya', type: 'Female', tone: 'Deep', faceShape: 'Heart', aiScore: '99%', landmarks: FaceLandmarks(eyeY: 0.43, lipY: 0.65, neckY: 0.83, noseY: 0.53, earY: 0.51)),
  ArModel(id: 'm_fair', path: 'model_male_fair.png', name: 'Alex', type: 'Male', tone: 'Fair', faceShape: 'Square', aiScore: '95%', landmarks: FaceLandmarks(eyeY: 0.45, lipY: 0.68, neckY: 0.88, noseY: 0.55, earY: 0.54, isBroader: true)),
  ArModel(id: 'm_warm', path: 'model_male_warm.png', name: 'James', type: 'Male', tone: 'Warm', faceShape: 'Oblong', aiScore: '97%', landmarks: FaceLandmarks(eyeY: 0.46, lipY: 0.69, neckY: 0.89, noseY: 0.56, earY: 0.55, isBroader: true)),
  ArModel(id: 'm_dark', path: 'model_male_dark.png', name: 'Marcus', type: 'Male', tone: 'Dark', faceShape: 'Square', aiScore: '94%', landmarks: FaceLandmarks(eyeY: 0.45, lipY: 0.68, neckY: 0.88, noseY: 0.55, earY: 0.54, isBroader: true)),
  ArModel(id: 'teen', path: 'model_male_fair.png', name: 'Ryan', type: 'Teen', tone: 'Fair', faceShape: 'Round', aiScore: '89%', landmarks: FaceLandmarks(eyeY: 0.45, lipY: 0.68, neckY: 0.88, noseY: 0.55, earY: 0.54)),
  ArModel(id: 'senior', path: 'model_female_light.png', name: 'Elena', type: 'Senior', tone: 'Silver', faceShape: 'Oval', aiScore: '92%', landmarks: FaceLandmarks(eyeY: 0.42, lipY: 0.65, neckY: 0.82, noseY: 0.52, earY: 0.50)),
  ArModel(id: 'user_model', path: 'model_user_nosepin.webp', name: 'You', type: 'Female', tone: 'Light', faceShape: 'Custom', aiScore: '100%', landmarks: FaceLandmarks(eyeY: 0.40, lipY: 0.60, neckY: 0.85, noseY: 0.50, earY: 0.53)),
];

// --- LOOKS ---
const _looks = [
  ArLook(name: 'Aviator Gold', mood: 'Golden Hour', items: {'Glasses': 'g1'}),
  ArLook(name: 'Ruby Woo', mood: 'Studio', items: {'Lipstick': 'l1'}),
  ArLook(name: 'Gold Jewelry', mood: 'Studio', items: {'Earrings': 'j1', 'Necklace': 'n1'}),
  ArLook(name: 'Fresh Makeup', mood: 'Daylight', items: {'Lipstick': 'l2', 'Earrings': 'j1'}),
  ArLook(name: 'Makeup-Pop', mood: 'Studio', items: {'Lipstick': 'l1', 'Earrings': 'j1'}), // Intense look
  ArLook(name: 'Chic Cat-Eye', mood: 'Neon Night', items: {'Glasses': 'g1'}), // Using Aviator as placeholder for Cat-Eye
];

// --- GALLERY LOOKS ---
// Defining these specifically for the Grid View
// Reusing _looks for simplicity but exposing them cleanly


// --- DATA CLASSES ---

class FaceLandmarks {
  final double eyeY;
  final double lipY;
  final double neckY;
  final double noseY; 
  final double earY; 
  final bool isBroader; 

  const FaceLandmarks({required this.eyeY, required this.lipY, required this.neckY, required this.noseY, required this.earY, this.isBroader = false});
}

class ArModel {
  final String id;
  final String path;
  final String name;
  final String type;
  final String tone;
  final String faceShape;
  final String aiScore;
  final FaceLandmarks landmarks;

  const ArModel({
    required this.id, required this.path, required this.name, required this.type,
    required this.tone, required this.faceShape, required this.aiScore, required this.landmarks
  });
}

class ArProduct {
  final String id;
  final String category;
  final String name;
  final Color color;
  final String assetPath;
  final String overlayIcon;

  const ArProduct({required this.id, required this.category, required this.name, required this.color, required this.assetPath, required this.overlayIcon});
}

class ArLook {
  final String name;
  final String mood;
  final Map<String, String> items; // Category -> ProductID
  const ArLook({required this.name, required this.mood, required this.items});
}

// --- STATE MANAGER ---

final arModelsProvider = Provider<List<ArModel>>((ref) => _models);
final arLooksProvider = Provider<List<ArLook>>((ref) => _looks);

final arProductProvider = Provider<List<ArProduct>>((ref) => [
  const ArProduct(id: 'g1', category: 'Glasses', name: 'Aviator Gold', color: Colors.amber, assetPath: 'assets/overlays/glasses_aviator.jpg', overlayIcon: '️'),
  const ArProduct(id: 'l1', category: 'Lipstick', name: 'Ruby Woo', color: Color(0xFFD50000), assetPath: 'assets/overlays/lipstick_ruby.jpg', overlayIcon: ''),
  const ArProduct(id: 'l2', category: 'Lipstick', name: 'Nude Matte', color: Color(0xFFD7A29E), assetPath: 'assets/overlays/lipstick_nude.jpg', overlayIcon: ''),
  const ArProduct(id: 'j1', category: 'Earrings', name: 'Gold Earrings', color: Colors.amber, assetPath: 'assets/overlays/earrings_gold.jpg', overlayIcon: '✨'),
  const ArProduct(id: 'n1', category: 'Necklace', name: 'Gold Chain', color: Colors.amber, assetPath: 'assets/overlays/necklace_gold.jpg', overlayIcon: '⛓️'),
  const ArProduct(id: 'nr1', category: 'Nose Pin', name: 'Silver Pin', color: Colors.grey, assetPath: 'assets/overlays/nose_pin.webp', overlayIcon: ''),
]);

final selectedModelProvider = StateProvider<ArModel>((ref) => _models[0]);
final activeProductsProvider = StateProvider<Map<String, ArProduct>>((ref) => {});
final arTransformScaleProvider = StateProvider<double>((ref) => 1.0);
final arTransformOffsetProvider = StateProvider<Offset>((ref) => Offset.zero);

// New Providers
final arMoodProvider = StateProvider<String>((ref) => 'Studio'); // Studio, Golden Hour, Neon Night

class ArLogic {
  static void resetTransform(WidgetRef ref) {
    ref.read(arTransformScaleProvider.notifier).state = 1.0;
    ref.read(arTransformOffsetProvider.notifier).state = Offset.zero;
  }
  
  static void toggleProduct(WidgetRef ref, ArProduct product) {
    final current = ref.read(activeProductsProvider);
    final newState = Map<String, ArProduct>.from(current);
    if (current[product.category]?.id == product.id) {
       newState.remove(product.category);
    } else {
       newState[product.category] = product;
    }
    ref.read(activeProductsProvider.notifier).state = newState;
  }
  
  static bool isActive(WidgetRef ref, ArProduct product) {
    final current = ref.watch(activeProductsProvider);
    return current[product.category]?.id == product.id;
  }

  static void applyLook(WidgetRef ref, ArLook look) {
      ref.read(arMoodProvider.notifier).state = look.mood;
      final allProducts = ref.read(arProductProvider);
      final newState = <String, ArProduct>{};
      
      look.items.forEach((cat, pid) {
         final p = allProducts.firstWhere((p) => p.id == pid, orElse: () => allProducts[0]); // Safe fallback
         newState[cat] = p;
      });
      
      ref.read(activeProductsProvider.notifier).state = newState;
  }
}
