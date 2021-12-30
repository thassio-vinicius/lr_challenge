import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lr_challenge/models/firestore_user.dart';
import 'package:lr_challenge/models/task.dart';

class FirestoreProvider {
  FirebaseFirestore firestore;
  FirebaseAuth firebaseAuth;

  FirestoreProvider(this.firestore, this.firebaseAuth);

  Future<FirestoreUser> currentUser({bool cache = true}) async {
    Map<String, dynamic>? doc = await fetchDocument(
      documentPath: firebaseAuth.currentUser!.uid,
      collectionPath: 'users',
      cache: cache,
    );

    print('uid from firestore ' + firebaseAuth.currentUser!.uid.toString());

    print("doc from firestore" + doc.toString());

    return FirestoreUser.fromMap(doc ?? {});
  }

  Stream<FirestoreUser>? currentUserStream() {
    Stream<DocumentSnapshot> stream =
        fetchDocumentStream(collectionPath: 'users', documentPath: firebaseAuth.currentUser!.uid);

    return stream.map((event) => FirestoreUser.fromSnapshot(event));
  }

  Future<void> addTask(Task task) async {
    FirestoreUser user = await currentUser();

    await firestore.collection('users').doc(user.uid).update({
      'tasks': FieldValue.arrayUnion([task.toJson()])
    });
  }

  Future<void> updateTask(Task task) async {
    FirestoreUser user = await currentUser();

    int taskIndex = user.tasks.indexWhere((element) => element.title == task.title);
    user.tasks[taskIndex] = task;

    List<Task> tasks = user.tasks;

    await firestore.collection('users').doc(user.uid).update({'tasks': tasks.map((e) => e.toJson()).toList()});
  }

  Future<void> setData({
    required String collectionPath,
    required String? documentPath,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = firestore.collection(collectionPath).doc(documentPath);
    print('$documentPath: $data');
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<void> updateData({
    required String collectionPath,
    required String? documentPath,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(collectionPath).doc(documentPath).update(data);
  }

  Future<Map<String, dynamic>?> fetchDocument<T>({
    required String collectionPath,
    required String? documentPath,
    bool cache = true,
  }) async {
    final DocumentReference reference = firestore.collection(collectionPath).doc(documentPath);
    final DocumentSnapshot snapshot =
        await reference.get(GetOptions(source: cache ? Source.serverAndCache : Source.server));
    return snapshot.data() as Map<String, dynamic>;
  }

  Stream<DocumentSnapshot> fetchDocumentStream<T>({
    required String collectionPath,
    required String documentPath,
  }) {
    final DocumentReference reference = firestore.collection(collectionPath).doc(documentPath);
    var snapshotStream = reference.snapshots();
    return snapshotStream;
  }
}
