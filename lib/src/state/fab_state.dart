import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controls whether the FAB on the Home screen should play a highlight animation
final fabHighlightProvider = StateProvider<bool>((ref) => false);
