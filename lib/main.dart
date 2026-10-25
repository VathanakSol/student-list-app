import 'package:flutter/material.dart';

void main() => runApp(const StudentListApp());

class Student {
  final String name;
  final int age;
  final String course;

  const Student({
    required this.name,
    required this.age,
    required this.course,
  });

  String get summary => '$name, $age years old - $course';
}

class StudentListApp extends StatelessWidget {
  const StudentListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();

  final List<Student> _students = [
    const Student(
      name: 'Amina',
      age: 19,
      course: 'Computer Science',
    ),
    const Student(
      name: 'Ben',
      age: 21,
      course: 'Mathematics',
    ),
    const Student(
      name: 'Chidi',
      age: 20,
      course: 'Computer Science',
    ),
  ];

  String _message = '';

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _addStudent() {
    final String name = _nameController.text.trim();
    final String ageText = _ageController.text.trim();
    final String course = _courseController.text.trim();

    if(name.isEmpty || course.isEmpty) {
      setState((){
        _message = 'Name and course are required.';
      });
      return;
    }

    final int? age = int.tryParse(ageText);

    if(age == null || age <=0 || age > 120) {
      setState((){
        _message = 'Enter a valid age between 1 and 120.';
      });
      return;
    }

    setState((){
      _students.add(
        Student(
          name: name,
          age: age,
          course: course,
        ),
      );

      _message = 'Added $name to $course.';

      _nameController.clear();
      _ageController.clear();
      _courseController.clear();
    });
  }

  void _removeStudent(Student student) {
    setState((){
      _students.remove(student);
      _message = 'Removed ${student.name}.';
    });
  }

  Map<String, Object> _getStats(){
    if(_students.isEmpty) {
      return {
        'total': 0,
        'averageAge': 0.0,
        'courses': <String>[],
      };
    }

    int totalAge = 0;
    final Set<String> courses = {};

    for(final Student student in _students){
      totalAge += student.age;
      courses.add(student.course);
    }

    final double averageAge = totalAge / _students.length;

    return {
      'total': _students.length,
      'averageAge': averageAge,
      'courses': courses.toList(),
    };
  }

  @override
  Widget build(BuildContext context){
    final Map<String, Object> stats = _getStats();
    final int total = stats['total'] as int;
    final double averageAge = stats['averageAge'] as double;
    final List<String> courses = stats['courses'] as List<String>; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List App'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Student',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),

                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 8),

                      TextField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),

                      TextField(
                        controller: _courseController,
                        decoration: const InputDecoration(
                          labelText: 'Course',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                    
                      ElevatedButton.icon(
                        onPressed: _addStudent,
                        icon: const Icon(Icons.person_add),
                        label: const Text('Add Student'),
                      ),

                      if(_message.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _message,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],   
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.groups),
                  title: Text('Total students: $total'),
                  subtitle: Text(
                    'Average age: ${averageAge.toStringAsFixed(1)} • '
                    'Courses: ${courses.isEmpty ? 'None' : courses.join(', ')}',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _students.isEmpty
                    ? const Center(
                        child: Text('No students yet. Add one above!'),
                      )
                    : ListView.builder(
                        itemCount: _students.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Student student = _students[index];

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  student.name.substring(0, 1).toUpperCase(),
                                ),
                              ),
                              title: Text(student.name),
                              subtitle: Text(
                                '${student.age} years old • ${student.course}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _removeStudent(student),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

