import 'package:flutter/material.dart';
import 'package:crud_estudiantes/modelEstudiante.dart';
import 'package:crud_estudiantes/databaseEstudiantes.dart';

class EstudianteDetailsView extends StatefulWidget {
  const EstudianteDetailsView({super.key, this.estudianteId});
  final int? estudianteId;

  @override
  State<EstudianteDetailsView> createState() => _EstudianteDetailsViewState();
}

class _EstudianteDetailsViewState extends State<EstudianteDetailsView> {
  EstudianteDatabase estudianteDatabase = EstudianteDatabase.instance;

  TextEditingController nombreController = TextEditingController();
  TextEditingController carreraController = TextEditingController();
  TextEditingController edadController = TextEditingController();

  late EstudianteModel estudiante;
  bool isLoading = false;
  bool isNewStudent = false;

  @override
  void initState() {
    refreshStudent();
    super.initState();
  }

  /// Gets the student from the database and updates the state if the estudianteId is not null else it sets the isNewStudent to true
  refreshStudent() {
    if (widget.estudianteId == null) {
      setState(() {
        isNewStudent = true;
      });
      return;
    }
    estudianteDatabase.read(widget.estudianteId!).then((value) {
      setState(() {
        estudiante = value;
        nombreController.text = estudiante.nombre;
        carreraController.text = estudiante.carrera;
        edadController.text = estudiante.edad.toString();
      });
    });
  }

  /// Creates a new student if isNewStudent is true else it updates the existing student
  createStudent() {
    setState(() {
      isLoading = true;
    });
    final model = EstudianteModel(
      nombre: nombreController.text,
      edad: int.tryParse(edadController.text) ??
          0, // Convert the edad text to int
      carrera: carreraController.text,
      fechaIngreso: DateTime.now(),
    );
    if (isNewStudent) {
      estudianteDatabase.create(model);
    } else {
      model.id = estudiante.id;
      estudianteDatabase.update(model);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context); // Go back to the previous screen after saving
  }

  /// Deletes the student from the database and navigates back to the previous screen
  deleteStudent() {
    estudianteDatabase.delete(estudiante.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          Visibility(
            visible: !isNewStudent,
            child: IconButton(
              onPressed: deleteStudent,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            onPressed: createStudent,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  TextField(
                    controller: nombreController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Nombre',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: carreraController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Carrera',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: edadController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Edad',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ]),
        ),
      ),
    );
  }
}
