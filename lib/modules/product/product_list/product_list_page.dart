import 'package:flutter/material.dart';
import 'package:flutter_product/modules/product/product_list/product_list_provider.dart';
import 'package:flutter_product/routes/route_names.dart';
import 'package:flutter_product/widgets/my_appbar.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductListProvider()..init(),
      child: Consumer<ProductListProvider>(
        builder: (BuildContext context, ProductListProvider provider, Widget? _) {
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
      title: 'Product List',
    );
  }

  Widget _buildBody(BuildContext context, ProductListProvider provider) {
    return ListView.builder(
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        final product = provider.products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('RM ${product.price.toStringAsFixed(2)}'),
        );
      },
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, RouteNames.productAdd),
    );
  }
}
