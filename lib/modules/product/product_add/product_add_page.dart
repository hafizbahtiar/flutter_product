import 'package:flutter/material.dart';
import 'package:flutter_product/modules/product/product_add/product_add_provider.dart';
import 'package:flutter_product/widgets/my_appbar.dart';
import 'package:flutter_product/widgets/my_dropdown.dart';
import 'package:flutter_product/widgets/my_snackbar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key});

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productBarcodeController = TextEditingController();

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productDescriptionController.dispose();
    _productBarcodeController.dispose();
    super.dispose();
  }

  Future<dynamic> _showBarcodeBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Scan Barcode',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  MobileScanner(
                    fit: BoxFit.contain,
                    scanWindowUpdateThreshold: 5.0,
                    scanWindow: Rect.fromCenter(
                      center: Offset(
                        MediaQuery.of(context).size.width / 2,
                        MediaQuery.of(context).size.height * 0.4,
                      ),
                      width: 200,
                      height: 200,
                    ),
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Error: ${error.toString()}',
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    },
                    onDetectError: (error, stackTrace) {
                      debugPrint('Scanner error: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'An error occurred: $error',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    overlayBuilder: (context, constraints) {
                      return Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    placeholderBuilder: (context, child) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    onDetect: (BarcodeCapture capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final String? code = barcodes.first.rawValue;
                        if (code != null) {
                          setState(() {
                            _productBarcodeController.text = code; // Update the text field
                          });
                          Navigator.pop(context); // Close the bottom sheet
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to scan barcode')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No barcode detected')),
                        );
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Align the barcode inside the green box',
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close Scanner'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductAddProvider()..init(),
      child: Consumer<ProductAddProvider>(
        builder: (BuildContext context, ProductAddProvider provider, Widget? _) {
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
      title: 'Add Product',
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBody(BuildContext context, ProductAddProvider provider) {
    if (provider.isLoading) {
      return _buildLoading();
    }

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 7.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                errorText: provider.productNameError,
              ),
              onChanged: (value) => provider.setProductName(value),
            ),
            TextField(
              controller: _productPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                errorText: provider.productPriceError,
              ),
              onChanged: (value) => provider.setProductPrice(value),
            ),
            TextField(
              controller: _productDescriptionController,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                errorText: provider.productDescriptionError,
              ),
              onChanged: (value) => provider.setProductDescription(value),
            ),
            TextField(
              controller: _productBarcodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Barcode',
                errorText: provider.productBarcodeError,
                suffixIcon: IconButton(
                  onPressed: () async => _showBarcodeBottomSheet(context),
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: 'Scan Barcode',
                ),
              ),
              onChanged: (value) => provider.setProductBarcode(value),
            ),
            MyDropdown(
              label: 'Company',
              items: {for (var comp in provider.companies) comp.id.toString(): comp.name.toString()},
              selectedValue: provider.selectedCompanyId,
              errorLabel: provider.selectedCompanyIdError,
              onSelected: (value) => provider.setSelectedCompanyId(value!),
            ),
            MyDropdown(
              label: 'Category',
              items: {for (var cat in provider.categories) cat.id.toString(): cat.title.toString()},
              selectedValue: provider.selectedCategoryId,
              errorLabel: provider.selectedCategoryIdError,
              onSelected: (value) => provider.setSelectedCategoryId(value!),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final isSuccess = await provider.saveProduct();
                  if (isSuccess && context.mounted) {
                    Navigator.pop(context);
                    if (provider.message != '') MySnackbar.showSnackbar(context, provider.message);
                  }
                },
                child: const Text('Save Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
