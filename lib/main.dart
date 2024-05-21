import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_editor_hub/editor_demo_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  final Logger logger = Logger();
  Workmanager().executeTask((task, inputData) {
    logger.t("Workmanager().executeTask <$task> : $inputData");
    return Future.value(true);
  });
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // _firebaseInit();
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    "task-identifier",
    "myTask",
    initialDelay: const Duration(minutes: 1),
    // constraints: Constraints (
    //   requiresCharging: true,
    //   networkType: NetworkType.connected,
    // ),
  );
  // Wakelock.enable();
  await Future.delayed(const Duration(milliseconds: 50), () {
    initializeDateFormatting().then((_){
      runApp(const MyApp());
    });
  });
  SystemChrome.restoreSystemUIOverlays();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.green.shade100,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EditorDemoPage(),
    );
  }
}