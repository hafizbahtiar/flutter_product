import 'package:flutter/material.dart';
import 'package:flutter_product/data/category_model.dart';
import 'package:flutter_product/helpers/database_helper.dart';

class CategoryListProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool _isLoading = false;
  List<Category> _categories = [];

  bool get isLoading => _isLoading;
  List<Category> get categories => _categories;

  void init() {
    setLoading(true);
    fetchCategoriesData();
    setLoading(false);
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchCategoriesData() async {
    final categories = await _dbHelper.getAll(DatabaseHelper.companiesTable);
    _categories = categories.map((categoriesMap) => Category.fromJson(categoriesMap)).toList();
    notifyListeners();
  }
}
