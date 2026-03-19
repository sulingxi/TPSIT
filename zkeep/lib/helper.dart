import 'model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // inizializzo il database
  static Future<Database> init() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');

    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  // qui creo le tabelle la prima volta
  static Future<void> _createTable(Database db, int version) async {
    // tabella per le note
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL
    );
    ''');

    // tabella per i todo
    // uso due tabelle perché una nota può avere più promemoria
    await db.execute('''
    CREATE TABLE todos (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      note_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      checked INTEGER NOT NULL
    );
    ''');
  }

  // prendere tutte le note dal database
  static Future<List<Note>> getNotes() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    final List<Map<String, dynamic>> result = await db.query(
      'notes',
      orderBy: 'id DESC',
    );

    if (result.isEmpty) {
      return <Note>[];
    }

    return result.map((row) => Note.fromMap(row)).toList();
  }

  // salvo una nuova nota
  static Future<void> insertNote(Note note) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    await db.insert('notes', note.toMap());
  }

  // cancello una nota e anche i suoi todo
  static Future<void> deleteNote(Note note) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    await db.delete('todos', where: 'note_id = ?', whereArgs: [note.id]);
    await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);
  }

  // prendere tutti i todo di una nota
  static Future<List<Todo>> getTodosByNote(int noteId) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    final List<Map<String, dynamic>> result = await db.query(
      'todos',
      where: 'note_id = ?',
      whereArgs: [noteId],
      orderBy: 'id DESC',
    );

    if (result.isEmpty) {
      return <Todo>[];
    }

    return result.map((row) => Todo.fromMap(row)).toList();
  }

  // prendo solo pochi todo per vedere nella card
  static Future<List<Todo>> getPreviewTodos(int noteId) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    final List<Map<String, dynamic>> result = await db.query(
      'todos',
      where: 'note_id = ?',
      whereArgs: [noteId],
      orderBy: 'id DESC',
      limit: 3,
    );

    if (result.isEmpty) {
      return <Todo>[];
    }

    return result.map((row) => Todo.fromMap(row)).toList();
  }

  // salvo un nuovo todo
  static Future<void> insertTodo(Todo todo) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    await db.insert('todos', todo.toMap());
  }

  // aggiorno stato del todo
  static Future<void> updateTodo(Todo todo) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  // cancello un todo
  static Future<void> deleteTodo(Todo todo) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);

    await db.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
  }
}