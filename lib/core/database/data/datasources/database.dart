// @dart=2.9

import 'dart:io';

import 'package:app_group_directory/app_group_directory.dart';
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
    Directory documentsDir = Platform.isIOS
        ? await AppGroupDirectory.getAppGroupDirectory(
            'group.com.tautulli.tautulliRemote.onesignal')
        : await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'tautulli_remote.db');

    return await openDatabase(
      path,
      version: 7,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        var batch = db.batch();
        _createTableServerV7(batch);
        await batch.commit();
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        var batch = db.batch();
        if (oldVersion == 1) {
          _updateTableServerV1toV7(batch);
          await _addInitialIndexValue(db, batch);
        }
        if (oldVersion == 2) {
          _updateTableServerV2toV7(batch);
          await _addInitialIndexValue(db, batch);
        }
        if (oldVersion == 3) {
          _updateTableServerV3toV7(batch);
          await _addInitialIndexValue(db, batch);
        }
        if (oldVersion == 4) {
          _updateTableServerV4toV7(batch);
          await _addInitialIndexValue(db, batch);
        }
        if (oldVersion == 5) {
          _updateTableServerV5toV7(batch);
          await _addInitialIndexValue(db, batch);
        }
        if (oldVersion == 6) {
          _updateTableServerV6toV7(batch);
        }
        await batch.commit();
      },
    );
  }

  void _createTableServerV7(Batch batch) {
    batch.execute('''CREATE TABLE servers(
                    id INTEGER PRIMARY KEY,
                    sort_index INTEGER,
                    plex_name TEXT,
                    plex_identifier TEXT,
                    tautulli_id TEXT,
                    primary_connection_address TEXT,
                    primary_connection_protocol TEXT,
                    primary_connection_domain TEXT,
                    primary_connection_path TEXT,
                    secondary_connection_address TEXT,
                    secondary_connection_protocol TEXT,
                    secondary_connection_domain TEXT,
                    secondary_connection_path TEXT,
                    device_token TEXT,
                    primary_active INTEGER,
                    onesignal_registered INTEGER,
                    plex_pass INTEGER,
                    date_format TEXT,
                    time_format TEXT,
                    custom_headers TEXT
                )''');
  }

  void _updateTableServerV1toV7(Batch batch) {
    batch.execute('ALTER TABLE servers ADD plex_pass INTEGER');
    batch.execute('ALTER TABLE servers ADD date_format TEXT');
    batch.execute('ALTER TABLE servers ADD time_format TEXT');
    batch.execute('ALTER TABLE servers ADD plex_identifier TEXT');
    batch.execute('ALTER TABLE servers ADD sort_index INTEGER');
    batch.execute('ALTER TABLE servers ADD onesignal_registered INTEGER');
    batch.execute('ALTER TABLE servers ADD custom_headers TEXT');
  }

  void _updateTableServerV2toV7(Batch batch) {
    batch.execute('ALTER TABLE servers ADD date_format TEXT');
    batch.execute('ALTER TABLE servers ADD time_format TEXT');
    batch.execute('ALTER TABLE servers ADD plex_identifier TEXT');
    batch.execute('ALTER TABLE servers ADD sort_index INTEGER');
    batch.execute('ALTER TABLE servers ADD onesignal_registered INTEGER');
    batch.execute('ALTER TABLE servers ADD custom_headers TEXT');
  }

  void _updateTableServerV3toV7(Batch batch) {
    batch.execute('ALTER TABLE servers ADD plex_identifier TEXT');
    batch.execute('ALTER TABLE servers ADD sort_index INTEGER');
    batch.execute('ALTER TABLE servers ADD onesignal_registered INTEGER');
    batch.execute('ALTER TABLE servers ADD custom_headers TEXT');
  }

  void _updateTableServerV4toV7(Batch batch) {
    batch.execute('ALTER TABLE servers ADD sort_index INTEGER');
    batch.execute('ALTER TABLE servers ADD onesignal_registered INTEGER');
    batch.execute('ALTER TABLE servers ADD custom_headers TEXT');
  }

  void _updateTableServerV5toV7(Batch batch) {
    batch.execute('ALTER TABLE servers ADD onesignal_registered INTEGER');
    batch.execute('ALTER TABLE servers ADD custom_headers TEXT');
  }

  void _updateTableServerV6toV7(Batch batch) {
    batch.execute('ALTER TABLE servers ADD custom_headers TEXT');
  }

  Future<void> _addInitialIndexValue(Database db, Batch batch) async {
    var servers = await db.query('servers');
    for (var i = 0; i <= servers.length - 1; i++) {
      batch.update(
        'servers',
        {'sort_index': i},
        where: 'id = ?',
        whereArgs: [servers[i]['id']],
      );
    }
  }

  addServer(ServerModel server) async {
    final db = await database;
    var result = await db.insert('servers', server.toJson());

    return result;
  }

  deleteServer(int id) async {
    final db = await database;
    var batch = db.batch();

    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM servers'));

    batch.delete('servers', where: 'id = ?', whereArgs: [id]);

    if (count > 1) {
      int sortIndex = await db
          .query(
            'servers',
            columns: ['sort_index'],
            where: 'id = ?',
            whereArgs: [id],
          )
          .then((value) => value.first['sort_index']);

      for (var i = count - 1; i > sortIndex; i--) {
        batch.update(
          'servers',
          {'sort_index': i - 1},
          where: 'sort_index = ?',
          whereArgs: [i],
        );
      }
    }
    await batch.commit();
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

  updateServerSort(int serverId, int oldIndex, int newIndex) async {
    final db = await database;
    var batch = db.batch();
    // Change moved item sort index to -1 to avoid 'where' conflicts
    batch.update(
      'servers',
      {'sort_index': -1},
      where: 'id = ?',
      whereArgs: [serverId],
    );
    // If item moved higher in list
    if (oldIndex < newIndex) {
      for (var i = oldIndex; i < newIndex; i++) {
        batch.update(
          'servers',
          {'sort_index': i},
          where: 'sort_index = ?',
          whereArgs: [oldIndex + 1],
        );
      }
    }
    // If item moved lower in list
    if (newIndex < oldIndex) {
      for (var i = newIndex; i < oldIndex; i++) {
        batch.update(
          'servers',
          {'sort_index': i + 1},
          where: 'sort_index = ?',
          whereArgs: [newIndex],
        );
      }
    }
    // Change sort index of moved item to new index
    batch.update(
      'servers',
      {'sort_index': newIndex},
      where: 'id = ?',
      whereArgs: [serverId],
    );

    var result = batch.commit();

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

  getAllServersWithoutOnesignalRegistered() async {
    final db = await database;
    var result = await db.query(
      'servers',
      where: 'onesignal_registered != ?',
      whereArgs: [1],
    );
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

  getServerByTautulliId(String tautulliId) async {
    final db = await database;
    var result = await db.query(
      'servers',
      where: 'tautulli_id = ?',
      whereArgs: [tautulliId],
    );

    return result.isNotEmpty ? ServerModel.fromJson(result.first) : null;
  }

  getCustomHeadersByTautulliId(String tautulliId) async {
    final db = await database;
    var result = await db.query(
      'servers',
      columns: ['custom_headers'],
      where: 'tautulli_id = ?',
      whereArgs: [tautulliId],
    );

    return result.isNotEmpty ? result.first['custom_headers'] : null;
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

  updatePrimaryActive({
    @required String tautulliId,
    @required int primaryActive,
  }) async {
    final db = await database;
    var result = await db.update(
      'servers',
      {'primary_active': primaryActive},
      where: 'tautulli_id = ?',
      whereArgs: [tautulliId],
    );

    return result;
  }

  updateCustomHeaders({
    @required String tautulliId,
    @required String encodedCustomHeaders,
  }) async {
    final db = await database;
    var result = await db.update(
      'servers',
      {'custom_headers': encodedCustomHeaders},
      where: 'tautulli_id = ?',
      whereArgs: [tautulliId],
    );

    return result;
  }
}
