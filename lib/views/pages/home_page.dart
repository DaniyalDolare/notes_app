import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/database_service.dart';
import 'package:notes_app/views/pages/add_note_page.dart';
import 'package:notes_app/views/pages/auth/login_page.dart';
import 'package:notes_app/views/pages/note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  bool isSearching = false;
  List<Note> allNotes = [];

  @override
  void initState() {
    super.initState();
    // fetch the data from database
    DatabaseService.getNotes().then((value) {
      value.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
      allNotes = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Note> notes;
    if (isSearching) {
      notes = allNotes
          .where((note) =>
              note.title!
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              note.note!
                  .toLowerCase()
                  .contains(searchController.text..toLowerCase()))
          .toList();
    } else {
      notes = allNotes;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add note page
          // and wait for the data
          var result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNotePage()));
          // if result is not null, it means that save btn is clicked
          if (result != null) {
            // type cast result from dynamic to Note type
            Note note = result;
            // if one of title or note is not empty, add it to notes list
            if (note.title!.isNotEmpty || note.note!.isNotEmpty) {
              // Save note to database
              var id = DatabaseService.saveNote(note);
              note.id = id;
              notes.insert(0, result);
              setState(() {});
            }
          }
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    isSearching = true;
                  } else {
                    isSearching = false;
                  }
                  setState(() {});
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    hintText: "Search notes.",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                  onPressed: () {
                                    searchController.clear();
                                    searchFocusNode.unfocus();
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.close)),
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    fillColor: Colors.grey),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            notes.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        isSearching
                            ? "Note not found"
                            : " You haven't added a note yet,\nPress + to add a note.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          onTap: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotePage(
                                          note: notes[index],
                                        )));

                            if (result != null) {
                              // result is of type Map<String,dynamic>
                              if (result["note"] != null) {
                                Note updatedNote = result["note"];
                                if (updatedNote.title != notes[index].title ||
                                    updatedNote.note != notes[index].note) {
                                  // remove the old note
                                  allNotes.remove(notes[index]);
                                  // add the updated note into top
                                  allNotes.insert(0, updatedNote);
                                  DatabaseService.updateNote(updatedNote);
                                }
                              } else if (result["delete"] != null) {
                                // remove the note
                                DatabaseService.deleteNote(notes[index].id!);
                                allNotes.remove(notes[index]);
                              }
                              setState(() {});
                            }
                          },
                          minVerticalPadding: 10.0,
                          title: Text(notes[index].title ?? ""),
                          subtitle: Text(
                            notes[index].note ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

// STRUCTURE OF DATA IN REALTIME DB FIREBASE
// "dbname":{
//   "user1":{
//     // user1 data
//     "nkfyf6s786786":null{
//       "title":"Note 1",
//       "note":"Note 1",
//       "updatedAt":"Note 1"
//     },
//     "nkfyf6s2376434":{
//       "title":"Note 2",
//       "note":"Note 2",
//       "updatedAt":"Note 2"
//     }
//   },
//   "user2":{
//     //user 2 data
//     {
//     // user1 data
//     "nkfyf6s786786":{
//       "title":"Note 1",
//       "note":"Note 1",
//       "updatedAt":"Note 1"
//     },
//     "nkfyf6s2376434":{
//       "title":"Note 2",
//       "note":"Note 2",
//       "updatedAt":"Note 2"
//     }
//   }
// }
