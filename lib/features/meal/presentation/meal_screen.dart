import 'package:alemeno_task/core/app_color.dart';
import 'package:alemeno_task/features/meal/provider/app_state.dart';
import 'package:alemeno_task/features/meal/widget/app_icon_button.dart';
import 'package:alemeno_task/features/message/package/message_screen.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class MealScreen extends StatefulWidget {
  const MealScreen({Key? key}) : super(key: key);

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  @override
  void initState() {
    // TODO: implement initState

    Firebase.initializeApp();
    getPermissionStatus();
    super.initState();
  }

  bool _isCameraPermissionGranted = false;

  CameraController? camController;

  List<CameraDescription> cameras = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void dispose() {
    camController?.dispose();
    super.dispose();
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      _isCameraPermissionGranted = true;

      _setupCameras();
    } else {
      _isCameraPermissionGranted = false;
    }
  }

  Future<void> _setupCameras() async {
    try {
      // initialize cameras.
      cameras = await availableCameras();
      // initialize camera controllers.
      camController = CameraController(cameras[0], ResolutionPreset.medium);
      await camController?.initialize();
    } on CameraException catch (_) {
      // do something on error.
    }
    if (!mounted) return;

    context.read<AppState>().cameraInitialized();
    context.read<AppState>().stepDone(0);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        const AppIconButton(name: 'Assets/svg/arrow_back.svg')),
              ),
              Center(
                  child: Image.asset(
                "Assets/images/cat.png",
                width: 300,
              )),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                    color: AppColor.plateColor,
                  ),
                  child: Consumer<AppState>(
                    builder: (context, value, child) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SvgPicture.asset(
                              'Assets/svg/fork.svg',
                              height: screenHeight * 0.23,
                            ),
                            Stack(alignment: Alignment.center, children: [
                              SvgPicture.asset(
                                'Assets/svg/corners.svg',
                                height: screenWidth * 0.5,
                              ),
                              Container(
                                height: screenWidth * 0.45,
                                width: screenWidth * 0.45,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  //color: Colors.amber
                                ),
                                child: value
                                        .step == 0
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.225),
                                        child: AspectRatio(
                                          aspectRatio: 1 / 1,
                                          child: camController!.buildPreview(),
                                        ),
                                      ):
                                    value.step >= 1?
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.225),
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: Image.file(value.picture,fit: BoxFit.fill),
                                      ),
                                    )
                                    : SvgPicture.asset(
                                        'Assets/svg/plate.svg',
                                        height: screenWidth * 0.5,
                                      ),
                              ),
                            ]),
                            SvgPicture.asset(
                              'Assets/svg/spoon.svg',
                              height: screenHeight * 0.23,
                            ),
                          ],
                        ),
                        Text(value.step == 0?'Click your meal':value.step == 1?'Will you eat this?':'',
                            style: const TextStyle(
                                fontFamily: 'Andika',
                                fontSize: 25,
                                color: AppColor.textColor)),
                        value.step == 0
                            ? GestureDetector(
                                onTap: takePicture,
                                child: const AppIconButton(
                                    name: 'Assets/svg/icon_camera.svg'))
                            : value.step == 1
                                ? GestureDetector(
                                    onTap: () async {
                                      context.read<AppState>().stepDone(value.step+1);
                                      final storageRef = FirebaseStorage.instance.ref();

                                      final mountainsRef = storageRef.child("${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");

                                      try{
                                        await mountainsRef.putFile(context.read<AppState>().picture).whenComplete(() async {
                                          const AndroidNotificationDetails androidPlatformChannelSpecifics =
                                          AndroidNotificationDetails(
                                              '92',
                                              'notification',
                                              'description',
                                              importance: Importance.high,
                                              priority: Priority.high,
                                          );

                                          const NotificationDetails platformChannelSpecifics =
                                          NotificationDetails(android: androidPlatformChannelSpecifics);
                                          await flutterLocalNotificationsPlugin.show(
                                              12345,
                                              "Great Job",
                                              "A Notification From My Application",
                                              platformChannelSpecifics,);
                                          Navigator.push(context, MaterialPageRoute(builder: (_)=>MessageScreen()));
                                        });
                                      }
                                      catch (e) {
                                        print(e);
                                      }

                                      },
                                    child: const AppIconButton(
                                        name: 'Assets/svg/icon_check.svg'))
                                :value.step == 2?CircularProgressIndicator(color: AppColor.primaryColor,): Container(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

   takePicture() async {
    final CameraController? cameraController = camController;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.

    }
    try {
      XFile file = await cameraController.takePicture();
      File imageFile = File(file.path);

      int currentUnix = DateTime.now().millisecondsSinceEpoch;
      final directory = await getApplicationDocumentsDirectory();
      String fileFormat = imageFile.path.split('.').last;

      await imageFile.copy(
        '${directory.path}/$currentUnix.$fileFormat',
      );
      context.read<AppState>().picData(File('${directory.path}/$currentUnix.$fileFormat'));
      context.read<AppState>().stepDone(context.read<AppState>().step + 1);
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');

    }
  }
}
