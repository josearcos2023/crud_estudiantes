import 'package:crud_estudiantes/modelEstudiante.dart';
import 'package:crud_estudiantes/databaseEstudiantes.dart';
import 'package:crud_estudiantes/detalles_estudiante.dart';
import 'package:flutter/material.dart';

class EstudiantesView extends StatefulWidget {
  const EstudiantesView({super.key});

  @override
  State<EstudiantesView> createState() => _EstudiantesViewState();
}

class _EstudiantesViewState extends State<EstudiantesView> {
  EstudianteDatabase estudianteDatabase = EstudianteDatabase.instance;

  List<EstudianteModel> estudiantes = [];

  @override
  void initState() {
    refreshStudents();
    super.initState();
  }

  @override
  dispose() {
    //close the database
    estudianteDatabase.close();
    super.dispose();
  }

  // Gets al the estudiantes from the database and updates the state
  refreshStudents() {
    estudianteDatabase.readAll().then((value) {
      setState(() {
        estudiantes = value;
      });
    });
  }

  //Navigates to the NoteDetailsView and refreshes the estudiantes after the nvaigation
  goToStudentDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EstudianteDetailsView(estudianteId: id)),
    );
    refreshStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: estudiantes.isEmpty
            ? const Text(
                'Aún no hay estudiantes',
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
                itemCount: estudiantes.length,
                itemBuilder: (context, index) {
                  final student = estudiantes[index];
                  return GestureDetector(
                    onTap: () => goToStudentDetailsView(id: student.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                student.fechaIngreso.toString().split('')[0],
                              ),
                              Text(
                                student.nombre,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                student.carrera,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                student.edad.toString(),
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToStudentDetailsView,
        tooltip: 'Create student',
        child: const Icon(Icons.add),
      ),
    );
  }
}
