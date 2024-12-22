import 'package:flutter/material.dart';
import 'package:flutter_product/providers/app_provider.dart';
import 'package:flutter_product/widgets/my_appbar.dart';
import 'package:provider/provider.dart';
import '../../../../routes/route_names.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 5.0,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, RouteNames.productList),
              child: const Text('Product List'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, RouteNames.companyList),
              child: const Text('Company List'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, RouteNames.categoryList),
              child: const Text('Category List'),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final appWatch = Provider.of<AppProvider>(context);
    return MyAppBar(
      title: 'Home Page',
      actions: [
        IconButton(
          onPressed: () => appProvider.setDarkMode(!appWatch.darkMode),
          icon: Icon(
            appWatch.darkMode ? Icons.light_mode : Icons.dark_mode,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
