import 'package:flutter/material.dart';
import 'package:flutter_product/helpers/database_helper.dart';

class CategoryAddProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _message = '';
  String _categoryTitle = '';
  String _categoryTitleError = '';

  String get message => _message;
  String get categoryTitle => _categoryTitle;
  String get categoryTitleError => _categoryTitleError;

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void setCategoryTitle(String value) {
    _categoryTitle = value;
    notifyListeners();
  }

  void _validateCategoryTitle(String value) {
    if (value.isEmpty) {
      _categoryTitleError = 'Category title is required';
    } else {
      _categoryTitleError = '';
    }
    notifyListeners();
  }

  bool _validateCategory() {
    _validateCategoryTitle(_categoryTitle);
    return _categoryTitleError.isEmpty;
  }

  Future<bool> saveCategory() async {
    if (!_validateCategory()) return false;

    await _dbHelper.insert(DatabaseHelper.categoriesTable, {
      'title': _categoryTitle.trim(),
    });
    _categoryTitle = '';
    _message = 'Company added!';
    return true;
  }
}
