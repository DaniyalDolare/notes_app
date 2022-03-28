import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/models/note.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static FirebaseDatabase database = FirebaseDatabase.instance;

  static String saveNote(Note note) {
    var ref = database.ref(FirebaseAuth.instance.currentUser!.uid);
    var id = ref.push();
    id.set({
      "title": note.title,
      "note": note.note,
      "updatedAt": note.updatedAt.toString(),
    });
    return id.key!;
  }

  static updateNote(Note note) {
    var ref = database.ref(FirebaseAuth.instance.currentUser!.uid);
    ref.child(note.id!).update({
      "title": note.title,
      "note": note.note,
      "updatedAt": note.updatedAt.toString(),
    });
  }

  static deleteNote(String id) {
    var ref = database.ref(FirebaseAuth.instance.currentUser!.uid);
    ref.child(id).remove();
  }

  static Future<List<Note>> getNotes() async {
    var ref = database.ref(FirebaseAuth.instance.currentUser!.uid);
    var data = await ref.get();
    List<Note> notes = [];
    if (data.value != null) {
      var map = data.value as Map;
      map.forEach((key, value) {
        var note = Note(
          id: key,
          title: value["title"],
          note: value["note"],
          updatedAt: DateTime.parse(value["updatedAt"]),
        );
        notes.add(note);
      });
    }
    return notes;
  }
}
