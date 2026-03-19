import 'package:flutter/material.dart';

import 'helper.dart';
import 'model.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zkeep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MyHomePage(title: 'zkeep'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _todoTextFieldController =
  TextEditingController();

  final List<Note> _notes = <Note>[];
  final List<Todo> _todos = <Todo>[];

  Note? _selectedNote;

  @override
  void initState() {
    super.initState();
    _init();
  }

  // qui inizio app e carico dati
  Future<void> _init() async {
    await DatabaseHelper.init();
    _updateNotes();
  }

  // aggiornare la lista delle note
  void _updateNotes() {
    DatabaseHelper.getNotes().then((notes) {
      setState(() {
        _notes.clear();
        _notes.addAll(notes);
      });
    });
  }

  // aggiornare i todo della nota scelta
  void _updateTodos(int noteId) {
    DatabaseHelper.getTodosByNote(noteId).then((todos) {
      setState(() {
        _todos.clear();
        _todos.addAll(todos);
      });
    });
  }

  // cambio stato del todo da fatto a non fatto
  void _handleTodoChange(Todo todo) {
    todo.checked = !todo.checked;
    setState(() {
      _todos.remove(todo);
      if (!todo.checked) {
        _todos.add(todo);
      } else {
        _todos.insert(0, todo);
      }
    });
    DatabaseHelper.updateTodo(todo);
  }

  // cancello un promemoria con pressione lunga
  void _handleTodoDelete(Todo todo) {
    setState(() {
      _todos.remove(todo);
    });
    DatabaseHelper.deleteTodo(todo);
  }

  // apro una finestra per aggiungere una nota
  Future<void> _displayAddNoteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('add note'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'note title'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addNoteItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  // apro una finestra per aggiungere un todo
  Future<void> _displayAddTodoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('add todo item'),
          content: TextField(
            controller: _todoTextFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_todoTextFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  // aggiungo una nuova nota
  void _addNoteItem(String title) {
    // se il testo è vuoto non faccio niente
    if (title.trim().isEmpty) return;

    Note note = Note(id: null, title: title);
    DatabaseHelper.insertNote(note);
    _textFieldController.clear();
    _updateNotes();
  }

  // aggiungo un promemoria nella nota scelta
  void _addTodoItem(String name) {
    // controllo se c'è una nota scelta
    if (_selectedNote == null) return;

    // se testo è vuoto non salvo
    if (name.trim().isEmpty) return;

    Todo todo = Todo(
      id: null,
      noteId: _selectedNote!.id!,
      name: name,
      checked: false,
    );

    DatabaseHelper.insertTodo(todo);
    _todoTextFieldController.clear();
    _updateTodos(_selectedNote!.id!);
  }

  // entro dentro la nota scelta
  void _openNote(Note note) {
    setState(() {
      _selectedNote = note;
    });
    _updateTodos(note.id!);
  }

  // cancello la nota scelta
  void _deleteNote(Note note) {
    if (_selectedNote?.id == note.id) {
      setState(() {
        _selectedNote = null;
        _todos.clear();
      });
    }

    DatabaseHelper.deleteNote(note);
    _updateNotes();
  }

  // qui costruisco la pagina con tutte le note
  Widget _buildNotesPage() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];

        return FutureBuilder<List<Todo>>(
          future: DatabaseHelper.getPreviewTodos(note.id!),
          builder: (context, snapshot) {
            final previewTodos = snapshot.data ?? <Todo>[];

            return NoteCard(
              note: note,
              previewTodos: previewTodos,
              onTap: () => _openNote(note),
              onDelete: () => _deleteNote(note),
            );
          },
        );
      },
    );
  }

  // qui costruisco la pagina dettaglio dei todo
  Widget _buildTodosPage() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: Colors.orange.shade100,
          child: Text(
            _selectedNote!.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              return TodoItem(
                todo: _todos[index],
                onTodoChanged: _handleTodoChange,
                onTodoDelete: _handleTodoDelete,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool inDetailPage = _selectedNote != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(inDetailPage ? _selectedNote!.title : widget.title),
        leading: inDetailPage
            ? IconButton(
          onPressed: () {
            setState(() {
              _selectedNote = null;
              _todos.clear();
            });
            _updateNotes();
          },
          icon: const Icon(Icons.arrow_back),
        )
            : null,
      ),
      body: Center(
        child: inDetailPage ? _buildTodosPage() : _buildNotesPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (inDetailPage) {
            _displayAddTodoDialog();
          } else {
            _displayAddNoteDialog();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _todoTextFieldController.dispose();
    super.dispose();
  }
}
