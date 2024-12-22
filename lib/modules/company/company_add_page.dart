import 'package:flutter/material.dart';
import 'package:flutter_product/helpers/database_helper.dart';
import 'package:flutter_product/widgets/my_appbar.dart';

class CompanyAddPage extends StatelessWidget {
  final _companyNameController = TextEditingController();
  final _companyDescriptionController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  CompanyAddPage({super.key});

  Future<void> _addCompany(BuildContext context) async {
    await _dbHelper.insert(DatabaseHelper.companiesTable, {
      'name': _companyNameController.text.trim(),
      'description': _companyDescriptionController.text.trim(),
    });
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Company added!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return MyAppBar(
      showLeading: true,
      leadingCallback: () => Navigator.pop(context),
      title: 'Add Company',
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(controller: _companyNameController, decoration: InputDecoration(labelText: 'Company Name')),
          TextField(controller: _companyDescriptionController, decoration: InputDecoration(labelText: 'Description')),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _addCompany(context),
              child: Text('Save Company'),
            ),
          ),
        ],
      ),
    );
  }
}
