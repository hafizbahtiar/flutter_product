import 'package:flutter/material.dart';
import 'package:flutter_product/modules/category/category_add/category_add_page.dart';
import 'package:flutter_product/modules/category/category_list/category_list_page.dart';
import 'package:flutter_product/modules/company/company_add/company_add_page.dart';
import 'package:flutter_product/modules/company/company_list/company_list_page.dart';
import 'package:flutter_product/modules/home/home_page.dart';
import 'package:flutter_product/modules/product/product_add/product_add_page.dart';
import 'package:flutter_product/modules/product/product_list/product_list_page.dart';
import 'package:flutter_product/splash_page.dart';
import 'route_names.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
        case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => SplashPage(),
          settings: RouteSettings(name: RouteNames.splash),
        );
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
          settings: RouteSettings(name: RouteNames.home),
        );
      case RouteNames.productList:
        return MaterialPageRoute(
          builder: (_) => ProductListPage(),
          settings: RouteSettings(name: RouteNames.productList),
        );
      case RouteNames.productAdd:
        return MaterialPageRoute(
          builder: (_) => ProductAddPage(),
          settings: RouteSettings(name: RouteNames.productAdd),
        );
      case RouteNames.companyList:
        return MaterialPageRoute(
          builder: (_) => CompanyListPage(),
          settings: RouteSettings(name: RouteNames.companyList),
        );
      case RouteNames.companyAdd:
        return MaterialPageRoute(
          builder: (_) => CompanyAddPage(),
          settings: RouteSettings(name: RouteNames.companyAdd),
        );
      case RouteNames.categoryList:
        return MaterialPageRoute(
          builder: (_) => CategoryListPage(),
          settings: RouteSettings(name: RouteNames.categoryList),
        );
      case RouteNames.categoryAdd:
        return MaterialPageRoute(
          builder: (_) => CategoryAddPage(),
          settings: RouteSettings(name: RouteNames.categoryAdd),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Route not found!')),
      ),
    );
  }
}
