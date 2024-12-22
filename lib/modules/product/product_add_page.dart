import 'package:flutter/material.dart';
import 'package:flutter_product/helpers/database_helper.dart';
import 'package:flutter_product/widgets/my_appbar.dart';
import 'package:flutter_product/widgets/my_dropdown.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key});

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productBarcodeController = TextEditingController();

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _companies = [];
  String? _selectedCategoryId;
  String? _selectedCompanyId;
  String? _productNameError;
  String? _productPriceError;
  String? _descError;
  String? _barcodeError;
  String? _compError;
  String? _categoryError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadCompanies();
  }

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

  Future<void> _loadCategories() async {
    try {
      final categories = await _dbHelper.getAll(DatabaseHelper.categoriesTable);
      setState(() {
        _categories = categories;
        if (_categories.isNotEmpty) {
          _selectedCategoryId = _categories.first['id'].toString();
        }
      });
    } catch (error) {
      debugPrint('Error loading categories: $error');
    }
  }

  Future<void> _loadCompanies() async {
    try {
      final companies = await _dbHelper.getAll(DatabaseHelper.companiesTable);
      setState(() {
        _companies = companies;
        if (_companies.isNotEmpty) {
          _selectedCompanyId = _companies.first['id'].toString();
        }
      });
    } catch (error) {
      debugPrint('Error loading companies: $error');
    }
  }

  Future<void> _addProduct(BuildContext context) async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      await _dbHelper.insert(DatabaseHelper.productsTable, {
        'name': _productNameController.text.trim(),
        'price': double.tryParse(_productPriceController.text.trim()) ?? 0.0,
        'description': _productDescriptionController.text.trim(),
        'category_id': int.tryParse(_selectedCategoryId ?? ''),
        'company_id': int.tryParse(_selectedCompanyId ?? ''),
      });

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
      }
    } catch (error) {
      debugPrint('Error adding product: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add product. Please try again.')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      _productNameError = null;
      _productPriceError = null;
      _descError = null;
      _barcodeError = null;
      _categoryError = null;
      _compError = null;
    });
    if (_productNameController.text.trim().isEmpty) {
      setState(() {
        _productNameError = 'Please enter a product name';
      });
      isValid = false;
    }
    if (_productPriceController.text.trim().isEmpty || double.tryParse(_productPriceController.text.trim()) == null) {
      setState(() {
        _productPriceError = 'Please enter a valid price';
      });
      isValid = false;
    }
    if (_productDescriptionController.text.trim().isEmpty) {
      setState(() {
        _descError = 'Please enter a description';
      });
      isValid = false;
    }
    if (_productBarcodeController.text.trim().isEmpty) {
      setState(() {
        _barcodeError = 'Please enter a barcode';
      });
      isValid = false;
    }
    if (_selectedCategoryId == null) {
      setState(() {
        _categoryError = 'Please enter a category';
      });
      isValid = false;
    }
    if (_selectedCompanyId == null) {
      setState(() {
        _compError = 'Please enter a company';
      });
      isValid = false;
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _isLoading ? _buildLoading() : _buildBody(context),
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

  Widget _buildBody(BuildContext context) {
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
                errorText: _productNameError,
              ),
            ),
            TextField(
              controller: _productPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                errorText: _productPriceError,
              ),
            ),
            TextField(
              controller: _productDescriptionController,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                errorText: _descError,
              ),
            ),
            TextField(
              controller: _productBarcodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Barcode',
                errorText: _barcodeError,
                suffixIcon: IconButton(
                  onPressed: () async => _showBarcodeBottomSheet(context),
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: 'Scan Barcode',
                ),
              ),
            ),
            MyDropdown(
              label: 'Company',
              items: {for (var comp in _companies) comp['id'].toString(): comp['name'].toString()},
              selectedValue: _selectedCompanyId,
              errorLabel: _compError,
              onSelected: (value) {
                setState(() => _selectedCompanyId = value);
              },
            ),
            MyDropdown(
              label: 'Category',
              items: {for (var cat in _categories) cat['id'].toString(): cat['title'].toString()},
              selectedValue: _selectedCategoryId,
              errorLabel: _categoryError,
              onSelected: (value) {
                setState(() => _selectedCategoryId = value);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _addProduct(context),
                child: const Text('Save Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
