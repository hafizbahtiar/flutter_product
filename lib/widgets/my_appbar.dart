import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leadingWidget;
  final String? subtitle;
  final Color? themeColor;
  final bool centerTitle;
  final VoidCallback? leadingCallback;
  final void Function(String)? searchOnChange;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool showSearch;
  final bool showLeading;
  final bool isLoading;
  final bool keepTitle;
  final bool keepSubtitle;
  final bool keepLeading;
  final TextEditingController? searchController;
  final Iterable<String>? autofillHints;

  const MyAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.themeColor,
    this.centerTitle = false,
    this.leadingCallback,
    this.actions,
    this.bottom,
    this.showSearch = false,
    this.showLeading = false,
    this.isLoading = false,
    this.keepTitle = false,
    this.keepSubtitle = false,
    this.keepLeading = false,
    this.searchController,
    this.searchOnChange,
    this.autofillHints,
    this.leadingWidget,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final primary = Theme.of(context).colorScheme.primary;

    // Define base font sizes
    const baseTitleFontSize = 20.0;
    const baseSubtitleFontSize = 10.0;

    // Adjust font sizes based on screen width
    final titleFontSize = baseTitleFontSize * (screenWidth / 375);
    final subtitleFontSize = baseSubtitleFontSize * (screenWidth / 375);

    return AppBar(
      backgroundColor: themeColor ?? primary,
      centerTitle: centerTitle,
      leadingWidth: showLeading == false ? 0 : 50.0,
      leading: (showLeading == true
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: leadingCallback,
            )
          : const SizedBox(width: 0, height: 0)),
      actions: actions,
      title: showSearch
          ? TextField(
              controller: searchController,
              onChanged: searchOnChange,
              autofocus: true,
              autofillHints: autofillHints,
              showCursor: true,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  focusColor: Colors.amber,
                  hoverColor: Colors.blueAccent),
              style: const TextStyle(color: Colors.white),
            )
          : Column(
              crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: subtitleFontSize,
                    ),
                  ),
              ],
            ),
      bottom: bottom, // Use bottom parameter
    );
  }
}
