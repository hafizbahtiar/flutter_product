import 'package:flutter/material.dart';
import 'package:flutter_product/modules/company/company_add/company_add_provider.dart';
import 'package:flutter_product/widgets/my_appbar.dart';
import 'package:flutter_product/widgets/my_snackbar.dart';
import 'package:provider/provider.dart';

class CompanyAddPage extends StatelessWidget {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyDescriptionController = TextEditingController();

  CompanyAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompanyAddProvider(),
      child: Consumer<CompanyAddProvider>(
        builder: (BuildContext context, CompanyAddProvider provider, Widget? _) {
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
      title: 'Add Company',
    );
  }

  Widget _buildBody(BuildContext context, CompanyAddProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _companyNameController,
            decoration: InputDecoration(
              labelText: 'Company Name',
              errorText: provider.companyNameError,
            ),
            onChanged: (value) => provider.setCompanyName(value),
          ),
          TextField(
            controller: _companyDescriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              errorText: provider.companyDescriptionError,
            ),
            onChanged: (value) => provider.setCompanyDescription(value),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final isSuccess = await provider.saveCompany();
                if (isSuccess && context.mounted) {
                  Navigator.pop(context);
                  if (provider.message != '') MySnackbar.showSnackbar(context, provider.message);
                }
              },
              child: Text('Save Company'),
            ),
          ),
        ],
      ),
    );
  }
}
