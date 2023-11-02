import 'package:cfm_feedback/Model/CfmerModel.dart';
import 'package:cfm_feedback/Model/VersionModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'Page/MyHomePage.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'mission_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE missions(id INTEGER PRIMARY KEY, name TEXT, content TEXT, pay INTEGER, version TEXT, isFinished INTEGER, deadline TEXT, claim TEXT, url TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 3,
  );
  Globals.database = database;
  Globals.prefs = await SharedPreferences.getInstance();
  //initJPushState();

  runApp(MyApp());
}

class Globals {
  static late final database;
  static late final prefs;
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //late SharedPreferences pref;


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return CfmerModel(
              Globals.prefs.getString("Name").toString(),
              Globals.prefs.getString("QQ").toString(),
              Globals.prefs.getString("Phone").toString()
          );
        }),
        ChangeNotifierProvider(create: (context) {
          var version = Globals.prefs.getString("Version").toString();
          var versions = [];
          if (Globals.prefs.getStringList("Versions") != null) {
            versions = Globals.prefs.getStringList("Versions")!;
          } else {
            versions.add("${DateTime.now().year}年${DateTime.now().month}月");
            version = versions[0];
          }
          return VersionModel(
              version,
              versions
          );
        }),
      ],
      child: MaterialApp(
        title: 'M组小工具',
        theme: ThemeData(
          //primarySwatch: Colors.orange,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
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
      ),
    );
  }

}
