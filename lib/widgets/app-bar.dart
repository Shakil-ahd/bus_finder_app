import 'package:flutter/material.dart';
import 'package:figma/constants/colors/app_colors.dart';

class GradientAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 2)),
        ],
      ),
      child: AppBar(
        centerTitle: true,
        title: title,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme:
            const IconThemeData(color: Colors.white),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize {
    final topPadding = MediaQueryData.fromView(
            WidgetsBinding.instance.window)
        .padding
        .top;
    return Size.fromHeight(kToolbarHeight + topPadding);
  }
}
