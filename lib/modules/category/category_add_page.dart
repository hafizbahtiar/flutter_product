import 'package:flutter/material.dart';
import 'package:flutter_product/helpers/database_helper.dart';
import 'package:flutter_product/widgets/my_appbar.dart';

class CategoryAddPage extends StatefulWidget {
  const CategoryAddPage({super.key});

  @override
  State<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _categoryTitleController = TextEditingController();

  String? _categoryTitleError;

  Future<void> _addCategory(BuildContext context) async {
    if (!_validateInputs()) return;

    await _dbHelper.insert(DatabaseHelper.categoriesTable, {
      'title': _categoryTitleController.text.trim(),
    });
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Category added!')));
    }
  }

  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      _categoryTitleError = null;
    });
    if (_categoryTitleController.text.trim().isEmpty) {
      setState(() {
        _categoryTitleError = 'Please enter a product name';
      });
      isValid = false;
    }
    return isValid;
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
      title: 'Add Category',
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _categoryTitleController,
            decoration: InputDecoration(
              labelText: 'Category Title',
              errorText: _categoryTitleError,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _addCategory(context),
              child: Text('Save Category'),
            ),
          ),
        ],
      ),
    );
  }
}
