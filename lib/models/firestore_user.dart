import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lr_challenge/models/task.dart';

class FirestoreUser {
  String name, email, uid;
  bool privacyPolicy, termsNConditions;
  List<Task> tasks;

  FirestoreUser({
    this.name = '',
    this.tasks = const [],
    required this.email,
    required this.uid,
    required this.privacyPolicy,
    required this.termsNConditions,
  });

  FirestoreUser copyWith({
    String? name,
    String? email,
    String? uid,
    List<Task>? tasks,
    bool? onboarding,
    bool? privacy,
    bool? terms,
  }) {
    return FirestoreUser(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      privacyPolicy: privacy ?? this.privacyPolicy,
      termsNConditions: terms ?? this.termsNConditions,
      tasks: tasks ?? this.tasks,
    );
  }

  FirestoreUser.fromMap(Map<String, dynamic> map, {DocumentReference? reference})
      : name = map['name'],
        uid = map['uid'],
        email = map['email'],
        tasks = _userTasks(List.from(map['tasks'])),
        termsNConditions = map['termsNConditions'],
        privacyPolicy = map['privacyPolicy'];

  static List<Task> _userTasks(List tasks) {
    List<Task> list = [];
    if (tasks.isNotEmpty) {
      list = tasks.map((e) => Task.fromMap(e)).toList();
    }

    return list;
  }

  FirestoreUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'email': this.email,
        'uid': this.uid,
        'tasks': this.tasks.map((e) => e.toJson()),
        'privacyPolicy': this.privacyPolicy,
        'termsNConditions': this.termsNConditions
      };

  @override
  String toString() {
    return 'FirestoreUser{name: $name, email: $email, uid: $uid, privacyPolicy: $privacyPolicy, termsNConditions: $termsNConditions, tasks: $tasks}';
  }
}
