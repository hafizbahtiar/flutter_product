import 'package:flutter/material.dart';
import 'package:flutter_product/helpers/shared_prefs_helper.dart';
import 'package:flutter_product/my_app.dart';
import 'package:flutter_product/providers.dart';
import 'package:flutter_product/helpers/database_helper.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure that all bindings are initialized before the app starts
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database and wait until it's ready before running the app
  await DatabaseHelper().database;
  await SharedPrefsHelper().init();

  // Run the app within the context of multiple providers to manage state
  runApp(
    MultiProvider(
      providers: Providers.providers, // List of all providers defined in the Providers class
      child: const MyApp(), // Root widget of the app
    ),
  );
}
