import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme_tokens.dart';

class ArTryOnScreen extends ConsumerStatefulWidget {
  const ArTryOnScreen({super.key});

  @override
  ConsumerState<ArTryOnScreen> createState() => _ArTryOnScreenState();
}

class _ArTryOnScreenState extends ConsumerState<ArTryOnScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) return;

      // Prefer front camera for try-on
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1114),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('AI Virtual Try-On', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          if (_isInitialized && _controller != null)
            CameraPreview(_controller!)
          else
            const Center(child: CircularProgressIndicator(color: ThemeTokens.primary)),

          // Filter Overlay
          if (_selectedFilter != null)
            _buildFilterOverlay(),

          // UI Overlays
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: _buildFilterSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOverlay() {
    final Map<String, dynamic>? selectedData = _getFilterData(_selectedFilter);
    final String category = selectedData?['category'] ?? 'face';
    
    double topOffset = 0;
    double width = 250;

    // Basic positioning logic based on category
    switch (category) {
      case 'ears':
        topOffset = 0; // Earrings centered relative to face usually works for mock
        width = 280;
        break;
      case 'neck':
        topOffset = 220; // Lower for necklace
        width = 300;
        break;
      case 'head':
        topOffset = -200; // Above for crowns/hats
        width = 240;
        break;
      case 'shades':
        topOffset = -40; // Eyes level
        width = 230;
        break;
      default:
        topOffset = 0;
        width = 250;
    }

    return Center(
      child: Transform.translate(
        offset: Offset(0, topOffset),
        child: CachedNetworkImage(
          imageUrl: _selectedFilter!,
          width: width,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Map<String, dynamic>? _getFilterData(String? url) {
    if (url == null) return null;
    final allFilters = _getAllFilters();
    try {
      return allFilters.firstWhere((f) => f['url'] == url);
    } catch (_) {
      return null;
    }
  }

  List<Map<String, dynamic>> _getAllFilters() {
    return [
      {'name': 'Clear', 'url': null, 'icon': Icons.block, 'category': 'none'},
      {'name': 'Aviators', 'url': 'https://img.icons8.com/color/512/sunglasses.png', 'icon': Icons.wb_sunny, 'category': 'shades'},
      {'name': 'Hoops', 'url': 'https://img.icons8.com/color/512/earrings.png', 'icon': Icons.hearing, 'category': 'ears'},
      {'name': 'Pearl Neck', 'url': 'https://img.icons8.com/color/512/necklace.png', 'icon': Icons.person_outline, 'category': 'neck'},
      {'name': 'Diamond', 'url': 'https://img.icons8.com/color/512/diamond.png', 'icon': Icons.auto_awesome, 'category': 'ears'},
      {'name': 'Crown', 'url': 'https://img.icons8.com/color/512/crown.png', 'icon': Icons.workspace_premium, 'category': 'head'},
      {'name': 'Gold Chain', 'url': 'https://img.icons8.com/color/512/jewelry.png', 'icon': Icons.link, 'category': 'neck'},
      {'name': 'Cat Eyes', 'url': 'https://img.icons8.com/color/512/glasses.png', 'icon': Icons.remove_red_eye, 'category': 'shades'},
      {'name': 'Cap', 'url': 'https://img.icons8.com/color/512/cowboy-hat.png', 'icon': Icons.person, 'category': 'head'},
    ];
  }

  Widget _buildFilterSelector() {
    final filters = _getAllFilters();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Jewelry & Accessories',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 85,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = _selectedFilter == filter['url'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = filter['url'] as String?;
                  });
                },
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: isSelected ? ThemeTokens.primary : Colors.white10,
                        shape: BoxShape.circle,
                        boxShadow: isSelected ? [
                          BoxShadow(color: ThemeTokens.primary.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)
                        ] : null,
                        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                      ),
                      child: Icon(
                        filter['icon'] as IconData,
                        color: isSelected ? Colors.white : Colors.white60,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      filter['name'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white60,
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
