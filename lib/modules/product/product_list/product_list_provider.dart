import 'package:flutter/material.dart';
import 'package:flutter_product/data/product_model.dart';
import 'package:flutter_product/helpers/database_helper.dart';

class ProductListProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool _isLoading = false;
  List<Product> _products = [];

  bool get isLoading => _isLoading;
  List<Product> get products => _products;

  void init() {
    setLoading(true);
    fetchProductsData();
    setLoading(false);
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchProductsData() async {
    final products = await _dbHelper.getAll(DatabaseHelper.productsTable);
    _products = products.map((productMap) => Product.fromJson(productMap)).toList();
    notifyListeners();
  }
}
