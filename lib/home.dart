import 'package:flutter/material.dart';
import 'package:sqflite_note_app/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // create list of all notes
  List<Map<String, dynamic>> allNotes = [];
  // create instance of dbhelper class
  DBHelper? dbRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text(allNotes[index][DBHelper.COLUMN_NOTE_SNO].toString()),
                  title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                );
              })
          : Text("No Notes Yet!!"),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool check = await dbRef!.addNote(
              myTitle: "personal Fav Note",
              myDesc: "this is my personal favouite note");
          if (check) {
            getNotes();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
