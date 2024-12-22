import 'package:flutter/material.dart';
import 'package:flutter_product/providers/app_provider.dart';
import 'package:flutter_product/routes/route_generator.dart';
import 'package:flutter_product/routes/route_names.dart';
import 'package:flutter_product/themes/app_theme.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appWatch = Provider.of<AppProvider>(context);
    // Build the MaterialApp widget, which is the root of your Flutter application
    return MaterialApp(
      title: 'Flutter Products', // App title shown in the app bar

      // Define the light theme for the app
      theme: appThemeData(context, false), // Light theme is provided based on context

      // Define the dark theme for the app
      darkTheme: appThemeData(context, true), // Dark theme is provided based on context

      // Automatically adjust the theme based on system preferences (light or dark mode)
      themeMode: appWatch.darkMode ? ThemeMode.dark : ThemeMode.light,

      // Set the initial route to be loaded when the app starts
      initialRoute: RouteNames.splash, // This points to the 'home' route

      // Use the custom route generator to handle navigation between pages
      onGenerateRoute: RouteGenerator.generateRoute, // This generates routes dynamically based on the name
    );
  }
}
