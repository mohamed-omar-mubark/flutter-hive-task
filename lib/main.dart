import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/person.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  await Hive.openBox<Person>('personBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohamed Omar Mubark - Hive Task',
      theme: ThemeData(
        primarySwatch: Colors.green,
        hintColor: Colors.greenAccent,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color.fromARGB(255, 0, 50, 0)),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.green),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          hintStyle: TextStyle(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _boxName = 'personBox';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  Box<Person>? _box;

  @override
  void initState() {
    super.initState();
    Hive.openBox<Person>(_boxName).then((box) {
      setState(() {
        _box = box;
      });
    });
  }

  void _addPerson() {
    final name = _nameController.text;
    final email = _emailController.text;
    final person = Person(name: name, email: email);

    _box?.add(person);
    _nameController.clear();
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mohamed Omar Mubark - Hive Task'),
      ),
      body: _box == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      '/logo.jpg',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addPerson,
                    child: const Text('Add Person'),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _box!.listenable(),
                      builder: (context, Box<Person> box, _) {
                        if (box.values.isEmpty) {
                          return const Center(
                              child: Text('No people added yet.'));
                        }
                        return ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            final person = box.getAt(index);
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 1,
                              child: ListTile(
                                title: Text('Name: ${person!.name}'),
                                subtitle: Text('Email: ${person.email}'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
