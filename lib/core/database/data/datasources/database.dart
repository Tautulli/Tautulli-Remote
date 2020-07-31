import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/server_model.dart';

class DBProvider {
  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    // Get the location of the app directory
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'tautulli_remote.db');

    return await openDatabase(path, version: 1, onOpen: (db) async {},
        onCreate: (Database db, int version) async {
      // Create the servers table
      await db.execute('''
                CREATE TABLE servers(
                    id INTEGER PRIMARY KEY,
                    plex_name TEXT,
                    tautulli_id TEXT,
                    primary_connection_address TEXT,
                    primary_connection_protocol TEXT,
                    primary_connection_domain TEXT,
                    primary_connection_path TEXT,
                    secondary_connection_address TEXT,
                    secondary_connection_protocol TEXT,
                    secondary_connection_domain TEXT,
                    secondary_connection_path TEXT,
                    device_token TEXT
                )
            ''');
    });
  }

  addServer(ServerModel server) async {
    final db = await database;
    var result = await db.insert('servers', server.toJson());

    return result;
  }

  deleteServer(int id) async {
    final db = await database;

    db.delete('servers', where: 'id = ?', whereArgs: [id]);
  }

  updateServer(ServerModel server) async {
    final db = await database;
    var result = await db.update('servers', server.toJson(),
        where: 'id = ?', whereArgs: [server.id]);

    return result;
  }

  updateServerById(ServerModel server) async {
    final db = await database;
    var result = await db.update('servers', server.toJson(),
        where: 'id = ?', whereArgs: [server.id]);

    return result;
  }

  getAllServers() async {
    final db = await database;
    var result = await db.query('servers');
    List<ServerModel> serverList = result.isNotEmpty
        ? result.map((settings) => ServerModel.fromJson(settings)).toList()
        : [];

    return serverList;
  }

  getServer(int id) async {
    final db = await database;
    var result = await db.query(
      'servers',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? ServerModel.fromJson(result.first) : null;
  }

  Future getServerByTautulliId(String tautulliId) async {
    final db = await database;
    var result = await db.query(
      'servers',
      where: 'tautulli_id = ?',
      whereArgs: [tautulliId],
    );

    return result.isNotEmpty ? ServerModel.fromJson(result.first) : null;
  }

  updateConnection({
    @required int id,
    @required Map<String, dynamic> dbConnectionAddressMap,
  }) async {
    final db = await database;
    var result = await db.update(
      'servers',
      dbConnectionAddressMap,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  updateDeviceToken({
    @required int id,
    @required String deviceToken,
  }) async {
    final db = await database;
    var result = await db.update(
      'servers',
      {'device_token': deviceToken},
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }
}