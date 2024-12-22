import 'package:flutter/material.dart';
import 'package:flutter_product/helpers/database_helper.dart';

class CompanyAddProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _message = '';
  String _companyName = '';
  String _companyDescription = '';
  String _companyNameError = '';
  String _companyDescriptionError = '';

  String get message => _message;
  String get companyName => _companyName;
  String get companyDescription => _companyDescription;
  String get companyNameError => _companyNameError;
  String get companyDescriptionError => _companyDescriptionError;

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void setCompanyName(String value) {
    _companyName = value;
    notifyListeners();
  }

  void setCompanyDescription(String value) {
    _companyDescription = value;
    notifyListeners();
  }

  void _validateCompanyName(String value) {
    if (value.isEmpty) {
      _companyNameError = 'Company name is required';
    } else {
      _companyNameError = '';
    }
    notifyListeners();
  }

  void _validateCompanyDescription(String value) {
    if (value.isEmpty) {
      _companyDescriptionError = 'Company description is required';
    } else {
      _companyDescriptionError = '';
    }
    notifyListeners();
  }

  bool _validateCompany() {
    _validateCompanyName(_companyName);
    _validateCompanyDescription(_companyDescription);
    return _companyNameError.isEmpty && _companyDescriptionError.isEmpty;
  }

  Future<bool> saveCompany() async {
    if (!_validateCompany()) return false;

    await _dbHelper.insert(DatabaseHelper.companiesTable, {
      'name': _companyName.trim(),
      'description': _companyDescription.trim(),
    });
    _companyName = '';
    _message = 'Company added!';
    return true;
  }
}
