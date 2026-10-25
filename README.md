# Student List App

A beginner Flutter app for managing a student list and practicing Dart syntax.

## Features

- View, add, and remove students.
- Validate names, courses, and ages (1–120).
- Display the total number of students, average age, and unique courses.

Student data is stored in memory. Changes reset when the app restarts.

## Requirements

- Flutter SDK with Dart compatible with `sdk: ^3.13.5` in `pubspec.yaml`.
- A supported device, emulator, or browser.
- VS Code or Android Studio (optional).

## Run the app

Open a terminal in the project folder, then run:

```sh
flutter doctor
flutter pub get
flutter run
```

To select a specific device:

```sh
flutter devices
flutter run -d <device-id>
```

Replace `<device-id>` with an ID printed by `flutter devices`.

## Project structure

```text
student_list_app/
├── lib/
│   └── main.dart          # Student model, app, form, list, and statistics
├── test/                  # Automated tests
├── android/               # Android platform files
├── ios/                   # iOS platform files
├── linux/                 # Linux platform files
├── macos/                 # macOS platform files
├── web/                   # Web platform files
├── windows/               # Windows platform files
├── analysis_options.yaml  # Dart analyzer and lint settings
├── pubspec.yaml           # Dependencies and app configuration
└── pubspec.lock           # Locked dependency versions
```

## Dart syntax examples

These examples explain patterns used in `lib/main.dart`. They are snippets, not a replacement for the complete app.

### Define a model with a constructor

Use `final` for fields that cannot be reassigned and named parameters to make object creation readable.

```dart
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

const student = Student(
  name: 'Amina',
  age: 19,
  course: 'Computer Science',
);
```

### Validate input with conditions

`int.tryParse` returns `null` when the text is not a valid integer. The `||` operator means “or”; short-circuit evaluation makes the null check safe.

```dart
final String name = _nameController.text.trim();
final String course = _courseController.text.trim();
final int? age = int.tryParse(_ageController.text.trim());

if (name.isEmpty || course.isEmpty) {
  return;
}

if (age == null || age <= 0 || age > 120) {
  return;
}
```

### Update a list and rebuild the UI

Inside the widget's `State` class, use `setState` when changing data displayed by the UI.

```dart
void _removeStudent(Student student) {
  setState(() {
    _students.remove(student);
    _message = 'Removed ${student.name}.';
  });
}
```

### Loop over students and collect unique courses

A `List` holds the students. A `Set` keeps each course only once.

```dart
int totalAge = 0;
final Set<String> courses = {};

for (final Student student in _students) {
  totalAge += student.age;
  courses.add(student.course);
}

final double averageAge =
    _students.isEmpty ? 0.0 : totalAge / _students.length;
```

### Build list items on demand

Use `ListView.builder` to build student rows as needed. Place it in an `Expanded` widget when it is a child of a `Column`.

```dart
ListView.builder(
  itemCount: _students.length,
  itemBuilder: (BuildContext context, int index) {
    final Student student = _students[index];

    return ListTile(
      title: Text(student.name),
      subtitle: Text(student.summary),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => _removeStudent(student),
      ),
    );
  },
)
```

## Format and check code

Run these commands from the project folder:

```sh
dart format lib test
flutter analyze
flutter test
```

## Version control

Commit source code, platform folders, assets, `.metadata`, `pubspec.yaml`, and `pubspec.lock`.

The `.gitignore` files exclude generated build output, local caches, editor files, environment files, and signing keys. Use `.env.example` for a shareable configuration template containing placeholder values.
