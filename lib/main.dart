import 'package:cfm_feedback/Model/CfmerModel.dart';
import 'package:cfm_feedback/Model/VersionModel.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'Common/Globals.dart';
import 'Page/MyHomePage.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final database = openDatabase(
    join(await getDatabasesPath(), 'mission_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE missions(id INTEGER PRIMARY KEY, name TEXT, content TEXT, pay INTEGER, version TEXT, isFinished INTEGER, deadline TEXT, claim TEXT, url TEXT)',
      );
    },
    version: 3,
  );
  Globals.database = database;

  await getData();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Globals.cfmerModel;
        }),
        ChangeNotifierProvider(create: (context) {
          return Globals.versionModel;
        }),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return MaterialApp(
            title: 'M组小工具',
            theme: ThemeData(
              //primarySwatch: Colors.orange,
              colorScheme: lightDynamic,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: darkDynamic,
              useMaterial3: true,
            ),
            home: MyHomePage(title: 'M组小工具'),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('zh', 'CN'),
            ],
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

getData() async {
  // 获取全局sp实例
  Globals.prefs = await SharedPreferences.getInstance();

  // 初始化模型
  Globals.cfmerModel = CfmerModel(Globals.prefs.getString("Name"),
      Globals.prefs.getString("QQ"), Globals.prefs.getString("Phone"), Globals.prefs.getBool("AutoUnFinished"));
  var version = Globals.prefs.getString("Version").toString();
  List<String> versions = [];
  if (Globals.prefs.getStringList("Versions") != null) {
    versions = Globals.prefs.getStringList("Versions")!;
  } else {
    versions.add("${DateTime.now().year}年${DateTime.now().month}月");
    version = versions[0];
  }
  Globals.versionModel = VersionModel(version, versions);
}
