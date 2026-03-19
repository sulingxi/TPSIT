import 'package:flutter/material.dart';
import 'model.dart';

class NoteCard extends StatelessWidget {
  NoteCard({
    required this.note,
    required this.previewTodos,
    required this.onTap,
    required this.onDelete,
  }) : super(key: ObjectKey(note));

  final Note note;
  final List<Todo> previewTodos;
  final Function onTap;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    // questa card mostra una nota nella pagina principale
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          onTap();
        },
        onLongPress: () {
          onDelete();
        },
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: previewTodos.isEmpty
            ? const Text('nessun promemoria')
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: previewTodos.map((todo) {
            return Text(
              '- ${todo.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                decoration:
                todo.checked ? TextDecoration.lineThrough : null,
                color: todo.checked ? Colors.black45 : Colors.black87,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
    required this.onTodoDelete,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final Function onTodoChanged;
  final Function onTodoDelete;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black45,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    // questo widget mostra un todo nella pagina dettaglio
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      onLongPress: () {
        onTodoDelete(todo);
      },
      leading: CircleAvatar(child: Text(todo.name[0])),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}
