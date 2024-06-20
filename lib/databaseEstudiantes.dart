import 'package:crud_estudiantes/modelEstudiante.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EstudianteDatabase {
  static final EstudianteDatabase instance = EstudianteDatabase._internal();
  static Database? _database;

  EstudianteDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'estudiantes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
    CREATE TABLE ${EstudianteCampos.tableName}(
      ${EstudianteCampos.id} ${EstudianteCampos.idType},
      ${EstudianteCampos.edad} ${EstudianteCampos.intType},
      ${EstudianteCampos.nombre} ${EstudianteCampos.textType},
      ${EstudianteCampos.carrera} ${EstudianteCampos.textType},
      ${EstudianteCampos.fechaIngreso} ${EstudianteCampos.textType},
    )
    ''');
  }

  Future<EstudianteModel> create(EstudianteModel note) async {
    final db = await instance.database;
    final id = await db.insert(EstudianteCampos.tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<EstudianteModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      EstudianteCampos.tableName,
      columns: EstudianteCampos.values,
      where: '${EstudianteCampos.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return EstudianteModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<EstudianteModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${EstudianteCampos.fechaIngreso} DESC';
    final result = await db.query(EstudianteCampos.tableName, orderBy: orderBy);
    return result.map((json) => EstudianteModel.fromJson(json)).toList();
  }

  Future<int> update(EstudianteModel note) async {
    final db = await instance.database;
    return db.update(
      EstudianteCampos.tableName,
      note.toJson(),
      where: '${EstudianteCampos.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      EstudianteCampos.tableName,
      where: '${EstudianteCampos.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
