// classe per una nota
class Note {
  Note({required this.id, required this.title});

  final int? id;
  final String title;

  // trasformo oggetto in mappa per database
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }

  // prendo una mappa e faccio oggetto note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(id: map['id'], title: map['title']);
  }
}

// classe per un promemoria dentro una nota
class Todo {
  Todo({
    required this.id,
    required this.noteId,
    required this.name,
    this.checked = false,
  });

  final int? id;
  final int noteId;
  final String name;
  bool checked;

  // trasformo oggetto in mappa per database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note_id': noteId,
      'name': name,
      'checked': checked ? 1 : 0,
    };
  }

  // prendo una mappa e faccio oggetto todo
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      noteId: map['note_id'],
      name: map['name'],
      checked: map['checked'] == 1,
    );
  }
}
