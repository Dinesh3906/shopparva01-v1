import 'dart:developer' as developer;
import 'package:shopparva/services/api_service.dart';

void testApis() async {
  final apiService = ApiService();
  
  print('Testing Fake Store API...');
  final fakeStoreProducts = await apiService.fetchFakeStoreProducts();
  print('Fake Store Products: ${fakeStoreProducts.length}');
  if (fakeStoreProducts.isNotEmpty) {
    print('First Fake Store Product: ${fakeStoreProducts.first.name} - ${fakeStoreProducts.first.price}');
  }

  print('\nTesting RapidAPI (femalefootwear)...');
  final rapidApiProducts = await apiService.fetchRapidAPIProducts('femalefootwear');
  print('RapidAPI Products: ${rapidApiProducts.length}');
  if (rapidApiProducts.isNotEmpty) {
    print('First RapidAPI Product: ${rapidApiProducts.first.name} - ${rapidApiProducts.first.price}');
  }
}
