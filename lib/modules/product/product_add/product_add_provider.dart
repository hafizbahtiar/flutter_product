import 'package:flutter/material.dart';
import 'package:flutter_product/data/category_model.dart';
import 'package:flutter_product/data/company_model.dart';
import 'package:flutter_product/helpers/database_helper.dart';

class ProductAddProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool _isLoading = false;
  String _message = '';
  String _selectedCategoryId = '';
  String _selectedCompanyId = '';
  String _productName = '';
  double _productPrice = 0.0;
  String _productDescription = '';
  String _productBarcode = '';
  String _productNameError = '';
  String _productPriceError = '';
  String _productDescriptionError = '';
  String _selectedCategoryIdError = '';
  String _selectedCompanyIdError = '';
  String _productBarcodeError = '';
  List<Category> _categories = [];
  List<Company> _companies = [];

  bool get isLoading => _isLoading;
  String get message => _message;
  String get selectedCategoryId => _selectedCategoryId;
  String get selectedCompanyId => _selectedCompanyId;
  String get productName => _productName;
  double get productPrice => _productPrice;
  String get productDescription => _productDescription;
  String get productBarcode => _productBarcode;
  String get productNameError => _productNameError;
  String get productPriceError => _productPriceError;
  String get productDescriptionError => _productDescriptionError;
  String get selectedCategoryIdError => _selectedCategoryIdError;
  String get selectedCompanyIdError => _selectedCompanyIdError;
  String get productBarcodeError => _productBarcodeError;
  List<Category> get categories => _categories;
  List<Company> get companies => _companies;

  void init() {
    setLoading(true);
    fetchCategoriesData();
    fetchCompaniesData();
    setLoading(false);
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSelectedCategoryId(String value) {
    _selectedCategoryId = value;
    notifyListeners();
  }

  void setSelectedCompanyId(String value) {
    _selectedCompanyId = value;
    notifyListeners();
  }

  void setProductName(String value) {
    _productName = value;
    notifyListeners();
  }

  void setProductPrice(String value) {
    _productPrice = double.tryParse(value.trim()) ?? 0.0;
    notifyListeners();
  }

  void setProductDescription(String value) {
    _productDescription = value;
    notifyListeners();
  }

  void setProductBarcode(String value) {
    _productBarcode = value;
    notifyListeners();
  }

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void clearProduct() {
    _productName = '';
    _productPrice = 0.0;
    _productDescription = '';
    notifyListeners();
  }

  void _validateProductName(String value) {
    if (value.isEmpty) {
      _productNameError = 'Product name is required';
    } else {
      _productNameError = '';
    }
    notifyListeners();
  }

  void _validateProductPrice(double value) {
    if (value <= 0) {
      _productPriceError = 'Product price must be greater than 0';
    } else {
      _productPriceError = '';
    }
    notifyListeners();
  }

  void _validateProductDescription(String value) {
    if (value.isEmpty) {
      _productDescriptionError = 'Product description is required';
    } else {
      _productDescriptionError = '';
    }
    notifyListeners();
  }

  void _validateSelectedCategoryId(String value) {
    if (value.isEmpty) {
      _selectedCategoryIdError = 'Category is required';
    } else {
      _selectedCategoryIdError = '';
    }
    notifyListeners();
  }

  void _validateSelectedCompanyId(String value) {
    if (value.isEmpty) {
      _selectedCompanyIdError = 'Company is required';
    } else {
      _selectedCompanyIdError = '';
    }
    notifyListeners();
  }

  void _validateProductBarcode(String value) {
    if (value.isEmpty) {
      _productBarcodeError = 'Product barcode is required';
    } else {
      _productBarcodeError = '';
    }
    notifyListeners();
  }

  bool _validateProduct() {
    _validateProductName(_productName);
    _validateProductPrice(_productPrice);
    _validateProductDescription(_productDescription);
    _validateSelectedCategoryId(_selectedCategoryId);
    _validateSelectedCompanyId(_selectedCompanyId);
    _validateProductBarcode(_productBarcode);
    return _productNameError.isEmpty &&
        _productPriceError.isEmpty &&
        _productDescriptionError.isEmpty &&
        _selectedCategoryIdError.isEmpty &&
        _selectedCompanyIdError.isEmpty &&
        _productBarcodeError.isEmpty;
  }

  Future<void> fetchCategoriesData() async {
    final categories = await _dbHelper.getAll(DatabaseHelper.categoriesTable);
    _categories = categories.map((categoryMap) => Category.fromJson(categoryMap)).toList();
    if (_categories.isNotEmpty) {
      _selectedCategoryId = _categories.first.id.toString();
    }
    notifyListeners();
  }

  Future<void> fetchCompaniesData() async {
    final companies = await _dbHelper.getAll(DatabaseHelper.companiesTable);
    _companies = companies.map((companyMap) => Company.fromJson(companyMap)).toList();
    if (_companies.isNotEmpty) {
      _selectedCompanyId = _companies.first.id.toString();
    }
    notifyListeners();
  }

  Future<bool> saveProduct() async {
    if (!_validateProduct()) return false;

    await _dbHelper.insert(DatabaseHelper.productsTable, {
      'name': _productName.trim(),
      'price': _productPrice,
      'description': _productDescription.trim(),
      'category_id': int.tryParse(_selectedCategoryId),
      'company_id': int.tryParse(_selectedCompanyId),
    });
    _message = 'Product added successfully';
    return true;
  }
}
