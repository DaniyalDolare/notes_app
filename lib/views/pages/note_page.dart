import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';

class NotePage extends StatelessWidget {
  NotePage({Key? key, required this.note}) : super(key: key);

  final Note note;

  final titleController = TextEditingController();
  final noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title!;
    noteController.text = note.note!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            var result = await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Do you want to delete this note?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  );
                });
            if (result != null) {
              if (result) {
                // delete this note
                Navigator.pop(context, {"note": null, "delete": true});
              }
            }
          },
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.grey,
        actions: [
          TextButton(
            onPressed: () {
              var note = Note(
                  title: titleController.text,
                  note: noteController.text,
                  updatedAt: DateTime.now());
              Navigator.pop(context, {"note": note, "delete": null});
            },
            child: Text("Save"),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle: Theme.of(context).textTheme.titleLarge),
            ),
            TextField(
              controller: noteController,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context).textTheme.subtitle1,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Note",
                  hintStyle: Theme.of(context).textTheme.subtitle1),
            ),
          ],
        ),
      ),
    );
  }
}
