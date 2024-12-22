import 'package:flutter/material.dart';
import 'package:flutter_product/data/company_model.dart';
import 'package:flutter_product/helpers/database_helper.dart';

class CompanyListProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool _isLoading = false;
  List<Company> _companies = [];

  bool get isLoading => _isLoading;
  List<Company> get companies => _companies;

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
    final companies = await _dbHelper.getAll(DatabaseHelper.companiesTable);
    _companies = companies.map((companyMap) => Company.fromJson(companyMap)).toList();
    notifyListeners();
  }
}
