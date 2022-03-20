import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/views/pages/add_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  List<Note> notes = [
    Note(title: "Note 1", note: "This is note 1", updatedAt: DateTime.now()),
    Note(title: "Note 2", note: "This is note 2", updatedAt: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
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
              notes.add(result);
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
                        " You haven't added a note yet,\nPress + to add a note.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          onTap: () {},
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
