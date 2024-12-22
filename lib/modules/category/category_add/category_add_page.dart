import 'package:flutter/material.dart';
import 'package:flutter_product/modules/category/category_add/category_add_provider.dart';
import 'package:flutter_product/widgets/my_appbar.dart';
import 'package:flutter_product/widgets/my_snackbar.dart';
import 'package:provider/provider.dart';

class CategoryAddPage extends StatefulWidget {
  const CategoryAddPage({super.key});

  @override
  State<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  final TextEditingController _categoryTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryAddProvider(),
      child: Consumer<CategoryAddProvider>(
        builder: (BuildContext context, CategoryAddProvider provider, Widget? _) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context, provider),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return MyAppBar(
      showLeading: true,
      leadingCallback: () => Navigator.pop(context),
      title: 'Add Category',
    );
  }

  Widget _buildBody(BuildContext context, CategoryAddProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _categoryTitleController,
            decoration: InputDecoration(
              labelText: 'Category Title',
              errorText: provider.categoryTitleError,
            ),
            onChanged: (value) => provider.setCategoryTitle(value),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final isSuccess = await provider.saveCategory();
                if (isSuccess && context.mounted) {
                  Navigator.pop(context);
                  if (provider.message != '') MySnackbar.showSnackbar(context, provider.message);
                }
              },
              child: Text('Save Category'),
            ),
          ),
        ],
      ),
    );
  }
}
