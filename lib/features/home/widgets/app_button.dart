import 'package:alemeno_task/core/app_color.dart';
import 'package:alemeno_task/core/helper.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  const AppButton({Key? key,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColor.primaryColor,
        boxShadow: buttonShadow,
      ),
      child: Text(text,style: const TextStyle(fontFamily: 'Andika',fontSize: 22, color: AppColor.buttonTextColor)),
    );
  }
}
