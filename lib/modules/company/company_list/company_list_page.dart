import 'package:flutter/material.dart';
import 'package:flutter_product/modules/company/company_list/company_list_provider.dart';
import 'package:flutter_product/routes/route_names.dart';
import 'package:flutter_product/widgets/my_appbar.dart';
import 'package:provider/provider.dart';

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({super.key});

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompanyListProvider()..init(),
      child: Consumer<CompanyListProvider>(
        builder: (BuildContext context, CompanyListProvider provider, Widget? child) {
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
      title: 'Company List',
    );
  }

  Widget _buildBody(BuildContext context, CompanyListProvider provider) {
    return ListView.builder(
      itemCount: provider.companies.length,
      itemBuilder: (context, index) {
        final company = provider.companies[index];
        return ListTile(
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          leading: Icon(Icons.home_work_outlined),
          title: Text(company.name),
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
