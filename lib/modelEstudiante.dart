class EstudianteCampos {
  static const List<String> values = [id, nombre, carrera, edad, fechaIngreso];

  static const String tableName = 'estudiantes';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String id = '_id';
  static const String nombre = 'nombre';
  static const String carrera = 'carrera';
  static const String edad = 'edad';
  static const String fechaIngreso = 'fechaIngreso';
}

class EstudianteModel {
  int? id;
  final int? edad;
  final String nombre;
  final String carrera;
  final DateTime? fechaIngreso;
  EstudianteModel({
    this.id,
    required this.edad,
    required this.nombre,
    required this.carrera,
    this.fechaIngreso,
  });

  Map<String, Object?> toJson() => {
        EstudianteCampos.id: id,
        EstudianteCampos.edad: edad,
        EstudianteCampos.nombre: nombre,
        EstudianteCampos.carrera: carrera,
        EstudianteCampos.fechaIngreso: fechaIngreso?.toIso8601String(),
      };

  factory EstudianteModel.fromJson(Map<String, Object?> json) =>
      EstudianteModel(
        id: json[EstudianteCampos.id] as int?,
        edad: json[EstudianteCampos.edad] as int?,
        nombre: json[EstudianteCampos.nombre] as String,
        carrera: json[EstudianteCampos.carrera] as String,
        fechaIngreso: DateTime.tryParse(
            json[EstudianteCampos.fechaIngreso] as String? ?? ''),
      );

  EstudianteModel copy({
    int? id,
    int? edad,
    String? nombre,
    String? carrera,
    DateTime? fechaIngreso,
  }) =>
      EstudianteModel(
        id: id ?? this.id,
        edad: edad ?? this.edad,
        nombre: nombre ?? this.nombre,
        carrera: carrera ?? this.carrera,
        fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      );
}
