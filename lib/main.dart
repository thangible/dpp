import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app/routes/app_pages.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dpp/app/services/api/dio_aux.dart';
import 'package:dpp/app/services/api/nameplate_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('nameplate');

  final dio = getDio();

  try { 
    final client = NameplateService(dio);
    final Submodel submodel = await client.getNameplateSubmodel();

    print(submodel.toString());
    await Hive.box('nameplate').put('submodel', submodel.toJson());
    final submodelJson = Hive.box('nameplate').get('submodel');
    if (submodelJson != null) {
      final retrievedSubmodel = Submodel.fromJson(
        Map<String, dynamic>.from(submodelJson),
      );
      print('Retrieved Submodel: ${retrievedSubmodel.toString()}');
    }
  } catch (e) {
    print('Error loading submodels: $e');
  }

  debugPaintSizeEnabled = true;

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness:
            !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return GetMaterialApp(
      title: 'DPP Mockup App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.android,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.pages,
    );
  }
}
