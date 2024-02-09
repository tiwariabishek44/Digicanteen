import 'package:flutter/material.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final Icon leadingIcon;
  final VoidCallback? onTap;

  const ProfileTile({
    Key? key,
    required this.title,
    required this.leadingIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: leadingIcon,
        tileColor: AppColors.lightColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        title: Text(
          title,
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: 25.sp,
          color: Color.fromARGB(255, 173, 186, 159),
        ),
        onTap: onTap,
      ),
    );
  }
}
