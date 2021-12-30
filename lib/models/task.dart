import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String title;
  int priority;
  bool completed;

  Task({required this.priority, required this.title, this.completed = false});

  Task.fromMap(Map<String, dynamic> map, {DocumentReference? reference})
      : title = map['title'],
        completed = map['completed'],
        priority = map['priority'];

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);

  Map<String, dynamic> toJson() => {'title': this.title, 'completed': this.completed, 'priority': this.priority};

  @override
  String toString() {
    return 'Task{title: $title, completed: $completed, priority: $priority}';
  }
}
