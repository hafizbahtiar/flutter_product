// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_product/providers/app_provider.dart';
import 'package:flutter_product/routes/route_names.dart';
import 'package:flutter_product/themes/app_pallete.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _titleAnimationController;
  late AnimationController _subtitleAnimationController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _subtitleFadeAnimation;

  @override
  void initState() {
    super.initState();

    _initializeAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      await appProvider.initialize();
      Future.delayed(const Duration(seconds: 3), _navigateAfterSplash);
    });
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoFadeAnimation = CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    );
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_logoAnimationController);

    _titleAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _titleFadeAnimation = CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeInOut,
    );

    _subtitleAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _subtitleFadeAnimation = CurvedAnimation(
      parent: _subtitleAnimationController,
      curve: Curves.easeInOut,
    );

    _logoAnimationController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      _titleAnimationController.forward();
    });

    Future.delayed(const Duration(seconds: 2), () {
      _subtitleAnimationController.forward();
    });
  }

  Future<void> _navigateAfterSplash() async {
    Navigator.of(context).pushNamedAndRemoveUntil(RouteNames.home, (route) => false);
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _titleAnimationController.dispose();
    _subtitleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const baseTitleFontSize = 50.0;
    const baseSubtitleFontSize = 20.0;

    final titleFontSize = baseTitleFontSize * (screenWidth / 375);
    final subtitleFontSize = baseSubtitleFontSize * (screenWidth / 375);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(color: AppPallete.primaryLight),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // FadeTransition(
                  //   opacity: _logoFadeAnimation,
                  //   child: ScaleTransition(
                  //     scale: _logoScaleAnimation,
                  //     child: SvgPicture.asset(CustomImage.dbkl, width: 200, height: 200),
                  //   ),
                  // ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  FadeTransition(
                    opacity: _titleFadeAnimation,
                    child: Text(
                      'Flutter',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _subtitleFadeAnimation,
                    child: Text(
                      'Product',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: subtitleFontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
