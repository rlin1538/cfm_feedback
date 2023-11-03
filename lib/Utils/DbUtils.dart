import 'package:sqflite/sqflite.dart';

import '../Common/Globals.dart';
import '../Common/Mission.dart';

Future<void> insertMission(Mission m) async {
  // Get a reference to the database.
  final db = await Globals.database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'missions',
    m.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateMission(Mission m) async {
  // Get a reference to the database.
  final db = await Globals.database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.update(
    'missions',
    m.toMap(),
    where: 'id=?',
    whereArgs: [m.id],
  );
}

Future<void> deleteMission(int id) async {
  // Get a reference to the database (获得数据库引用)
  final db = await Globals.database;

  // Remove the Dog from the database.
  await db.delete(
    'missions',
    // Use a `where` clause to delete a specific dog.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

Future<List<Mission>> getMissions(String version) async {
  // Get a reference to the database.
  final db = await Globals.database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('missions',
      where: "version=?",
      whereArgs: [version],
      orderBy: 'isFinished asc, deadline asc');
  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return Mission(
      id: maps[i]['id'],
      name: maps[i]['name'],
      content: maps[i]['content'],
      pay: maps[i]['pay'],
      version: maps[i]['version'],
      isFinished: maps[i]['isFinished'],
      claim: maps[i]['claim'],
      url: maps[i]['url'],
      deadline: maps[i]['deadline'],
    );
  });
}

Future<bool> containMissions(int id) async {
  final db = await Globals.database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query(
    'missions',
    where: "id = ?",
    whereArgs: [id],
  );
  if (maps.length == 0) {
    return false;
  } else {
    return true;
  }
}
