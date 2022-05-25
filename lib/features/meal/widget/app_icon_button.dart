import 'package:alemeno_task/core/app_color.dart';
import 'package:alemeno_task/core/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIconButton extends StatelessWidget {
  final String name;

  const AppIconButton({Key? key, required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColor.primaryColor, shape: BoxShape.circle,boxShadow: buttonShadow),
      child: SvgPicture.asset(name, width: 25, height: 25),
    );
  }
}
