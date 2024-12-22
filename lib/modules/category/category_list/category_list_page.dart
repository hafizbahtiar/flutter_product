import 'package:flutter/material.dart';
import 'package:flutter_product/modules/category/category_list/category_list_provider.dart';
import 'package:flutter_product/routes/route_names.dart';
import 'package:flutter_product/widgets/my_appbar.dart';
import 'package:provider/provider.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryListProvider()..init(),
      child: Consumer<CategoryListProvider>(
        builder: (BuildContext context, CategoryListProvider provider, Widget? child) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context, provider),
            floatingActionButton: _buildFab(context),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return MyAppBar(
      showLeading: true,
      leadingCallback: () => Navigator.pop(context),
      title: 'Category List',
    );
  }

  Widget _buildBody(BuildContext context, CategoryListProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.fetchCategoriesData(),
      child: ListView.builder(
        itemCount: provider.categories.length,
        itemBuilder: (context, index) {
          final category = provider.categories[index];
          return ListTile(
            trailing: Icon(Icons.arrow_forward_ios_outlined),
            leading: Icon(Icons.category_outlined),
            title: Text(category.title),
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, RouteNames.categoryAdd),
    );
  }
}
