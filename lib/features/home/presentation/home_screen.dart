import 'package:alemeno_task/core/app_color.dart';
import 'package:alemeno_task/features/home/widgets/app_button.dart';
import 'package:alemeno_task/features/meal/presentation/meal_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var screenWidth = 360.0;
  var tolarableWidth = 360.0;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor:AppColor.backgroundColor,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('Assets/images/logo.png',width: screenWidth>tolarableWidth ? tolarableWidth: screenWidth,),
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MealScreen()));
                  },
                  child: AppButton(text: 'Share your meal'))
            ],
          ),
        ),
      ),
    );
  }
}
