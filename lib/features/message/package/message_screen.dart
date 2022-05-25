import 'package:alemeno_task/features/meal/provider/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_color.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        context.read<AppState>().refreshData();
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        body: Center(
          child: Text('GOOD JOB',
              style: const TextStyle(
                  fontFamily: 'LilitaOne',
                  fontSize: 50,
                  color: AppColor.primaryColor)),
        ),
      )),
    );
  }
}
