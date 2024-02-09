import 'package:flutter/material.dart';
import 'package:merocanteen/app/config/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.backgroundColor,
      title: Text(
        title,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
      ),
    );
  }
}
