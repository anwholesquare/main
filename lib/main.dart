import 'dart:io';
import 'package:app/model/promise.dart';
import 'package:app/pages/homepage.dart';
import 'package:app/pages/add_promise.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';
import 'package:splash_view/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';



String appName = 'uPromise';
ThemeMode? firstThemeMode;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isDark = await getThemeMode();
  runApp(MainApp(initThemeMode: isDark ? ThemeMode.dark : ThemeMode.light));
}

class MainApp extends StatefulWidget {
  final ThemeMode? initThemeMode;
  const MainApp({super.key, this.initThemeMode});

  @override
  State<MainApp> createState() => _MainAppState();
  // ignore: library_private_types_in_public_api
  static _MainAppState of(BuildContext context) => 
      context.findAncestorStateOfType<_MainAppState>()!;
  
}

class _MainAppState extends State<MainApp> {
  ThemeMode? _themeMode;

  @override
  void initState() {
    super.initState();
    setState(() {
      _themeMode = widget.initThemeMode;
      firstThemeMode = widget.initThemeMode;
    });
  }

  void toggleThemeMode (BuildContext context) {
    getThemeMode().then((value) => 
         setState(() {
          _themeMode = value ? ThemeMode.light : ThemeMode.dark;
      setDark(!value);
        })
    );
   
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: appName,
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: GoogleFonts.poppins().fontFamily,
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.all(Colors.red),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        fontFamily: GoogleFonts.poppins().fontFamily,
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.all(Colors.red),
        ),
        
      ),
      initialRoute: "/",
      routes: {
        "/": (context) =>
          SplashView(
            backgroundColor: Theme.of(context).canvasColor,
            title : const Text("uPromise", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            subtitle: const Text("Your Promise Keeper App"),
            done: Done(const HomePage()),
          ),
        "/home":(context) => const HomePage(),
        "/addPromise":(context) =>const AddPromise(),
      },
    );
  }
}


class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();


  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'uPromise.db');
    return await openDatabase(path, version: 1,
        onCreate: (db, version) {
            return db.execute(
              "CREATE TABLE promises(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, startDateTime INTEGER NOT NULL, endDateTime INTEGER NOT NULL, coloring INTEGER NOT NULL DEFAULT '0', isCompleted INT NOT NULL DEFAULT '0', created_date TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)");
            },
    );
  }

  Future<int> insert(Promise myModel) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var dateRange in myModel.dates!) {
      batch.insert("promises", {
        'title': myModel.title,
        'description': myModel.description,
        'coloring': myModel.coloring,
        'isCompleted': myModel.isCompleted! ? 1 : 0,
        'startDateTime': dateRange.startDate!.millisecondsSinceEpoch,
        'endDateTime': dateRange.endDate!.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace
      );
    }
    final result = await batch.commit();
    return result.length;
  }

  Future<List<Promise>> queryByDate(DateTime date) async {
    final db = await instance.database;
    final result = await db.query("promises",
        where:
            'startDateTime <= ? AND endDateTime >= ?',
        whereArgs: [date.millisecondsSinceEpoch, date.millisecondsSinceEpoch]);
    final groupedResult = groupBy(result, (obj) => obj['id']);
    final models = groupedResult.entries.map((entry) {
      final id = entry.key as int;
      final title = entry.value[0]['title'] as String;
      final description = entry.value[0]['description'] as String;
      final coloring = entry.value[0]['coloring'] as int;
      final isCompleted = entry.value[0]['isCompleted'] as int;
      final dateRanges = entry.value
          .map((obj) => DateRange(
                startDate: DateTime.fromMillisecondsSinceEpoch(obj['startDateTime'] as int),
                endDate: DateTime.fromMillisecondsSinceEpoch(obj['endDateTime'] as int),
              ))
          .toList();
      return Promise(id: id, title: title, dates: dateRanges, description: description, coloring: coloring, isCompleted: isCompleted == 1 ? true : false);
    }).toList();
    return models;
  }


  Future<int> clearDB() async {
      final db = await instance.database;
      await db.delete("promises");
      return 1;
  }

  Future<int> deletePromise(int id) async {
      final db = await instance.database;
      await db.delete("promises", where: "id = ?", whereArgs: [id] );
      return 1;
  }


}


void setDark(bool theme) async {
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDark', theme);
}

Future<bool> getThemeMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool boolValue = prefs.getBool('isDark') ?? false;
  return boolValue;
}
