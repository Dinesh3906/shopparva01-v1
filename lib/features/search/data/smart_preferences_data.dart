
import 'package:shopparva/models/product.dart';

class SmartPreferencesData {
  // Laptop Filters (Unchanged)
  static const List<String> laptopBrands = [
    'HP', 'Dell', 'Lenovo', 'ASUS', 'Apple MacBook',
  ];

  static const List<String> laptopPriceRanges = [
    'Under \$500', '\$500 – \$1000', 'Above \$1000',
  ];

  static const List<String> laptopPerformance = [
    'i5 or equivalent', 'i7 or equivalent', 'Dedicated GPU', 'SSD Storage',
  ];

  static const List<String> laptopUsage = [
    'Student', 'Office Work', 'Programming', 'Gaming',
  ];

  // Phone Filters - NEW STRUCTURAL UPDATE
  static const List<String> phonePrimaryUsage = [
    'Gaming',
    'Camera / Photography',
    'Daily Use',
    'Business / Productivity',
    'Content & Social Media',
  ];

  static const List<String> phoneRam = [
    '4 GB', '6 GB', '8 GB', '12 GB or more',
  ];

  static const List<String> phoneStorage = [
    '64 GB', '128 GB', '256 GB', '512 GB',
  ];

  static const List<String> phonePerformance = [
    'High-end Processor',
    'Smooth UI (120Hz / 144Hz)',
    'Thermal Cooling for Gaming',
  ];

  static const List<String> phoneCamera = [
    'Good Selfie Camera',
    'High-Resolution Main Camera',
    'Optical Image Stabilization (OIS)',
    'Video Recording Quality',
  ];

  static const List<String> phoneBattery = [
    'Long Battery Life',
    'Fast Charging',
    'Wireless Charging',
  ];

  static const List<String> phoneDisplay = [
    'AMOLED / OLED',
    'Large Screen',
    'High Refresh Rate',
  ];
  
  static const List<String> phoneNetwork = [
    '5G Support',
    'Dual SIM',
    'Stereo Speakers',
  ];

  // Smart Rules Mapping
  // Usage -> [List of auto-selected features from other categories]
  static const Map<String, List<String>> phoneSmartRules = {
    'Gaming': [
      '8 GB', '12 GB or more', // RAM
      'High-end Processor', 'Thermal Cooling for Gaming', // Performance
      'High Refresh Rate', // Display
    ],
    'Camera / Photography': [
      'Optical Image Stabilization (OIS)', 'High-Resolution Main Camera',
      'AMOLED / OLED', // Display
      '256 GB', '512 GB', // Storage (implicitly good for photos)
    ],
    'Content & Social Media': [
      'Good Selfie Camera',
      'Long Battery Life',
      'Large Screen',
    ],
    'Business / Productivity': [
      'Long Battery Life',
      'Fast Charging',
      '128 GB', '256 GB',
      '5G Support',
    ],
  };

  // Mock Results (Laptops Unchanged)
  static final List<Product> mockLaptops = [
    const Product(
      id: 'lp1',
      name: 'HP Pavilion 15',
      price: 749,
      rating: 4.6,
      stores: 5,
      brand: 'HP',
      image: 'https://images.unsplash.com/photo-1589561084771-00396e5da500?auto=format&fit=crop&q=80&w=500',
    ),
    const Product(
      id: 'lp2',
      name: 'Dell Inspiron 14',
      price: 699,
      rating: 4.5,
      stores: 4,
      brand: 'Dell',
      image: 'https://images.unsplash.com/photo-1588872657578-a3d2e3039d58?auto=format&fit=crop&q=80&w=500',
    ),
    const Product(
      id: 'lp3',
      name: 'Lenovo IdeaPad Gaming 3',
      price: 899,
      rating: 4.7,
      stores: 6,
      brand: 'Lenovo',
      image: 'https://images.unsplash.com/photo-1629131726692-1accd0c53ce0?auto=format&fit=crop&q=80&w=500',
    ),
  ];

  // Updated Mock Phone Results matching specific examples
  static final List<Product> mockPhones = [
    const Product(
      id: 'ph1',
      name: 'OnePlus 12R',
      price: 499,
      rating: 4.6,
      stores: 7,
      brand: 'OnePlus',
      image: 'https://images.unsplash.com/photo-1628148856453-29402518e95c?auto=format&fit=crop&q=80&w=500',
      badges: ['8GB RAM', 'AMOLED', '120Hz'],
    ),
    const Product(
      id: 'ph2',
      name: 'Samsung Galaxy S23',
      price: 749,
      rating: 4.7,
      stores: 5,
      brand: 'Samsung',
      image: 'https://images.unsplash.com/photo-1675769273919-4cb50de00578?auto=format&fit=crop&q=80&w=500',
      badges: ['OIS Camera', 'AMOLED'],
    ),
    const Product(
      id: 'ph3',
      name: 'iQOO Neo Series',
      price: 429,
      rating: 4.5,
      stores: 4,
      brand: 'iQOO',
      image: 'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?auto=format&fit=crop&q=80&w=500', // Generic gaming phone
      badges: ['Gaming Focus', '144Hz', 'Snapdragon'],
    ),
    const Product(
      id: 'ph4',
      name: 'Google Pixel 7a',
      price: 449,
      rating: 4.7,
      stores: 6,
      brand: 'Google',
      image: 'https://images.unsplash.com/photo-1610438235354-a6ae5528385c?auto=format&fit=crop&q=80&w=500',
      badges: ['Best Camera', 'Stock Android'],
    ),
  ];
}
