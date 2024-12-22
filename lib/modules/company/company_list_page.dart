import 'package:flutter/material.dart';
import 'package:flutter_product/helpers/database_helper.dart';
import 'package:flutter_product/routes/route_names.dart';
import 'package:flutter_product/widgets/my_appbar.dart';

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({super.key});

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  List<Map<String, dynamic>> _companies = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final companies = await _dbHelper.getAll(DatabaseHelper.companiesTable);
    setState(() => _companies = companies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFab(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return MyAppBar(
      showLeading: true,
      leadingCallback: () => Navigator.pop(context),
      title: 'Company List',
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
      itemCount: _companies.length,
      itemBuilder: (context, index) {
        final company = _companies[index];
        return ListTile(
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          leading: Icon(Icons.home_work_outlined),
          title: Text(company['name']),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, RouteNames.companyAdd),
    );
  }
}
