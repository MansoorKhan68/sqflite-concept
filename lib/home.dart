// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:sqflite_note_app/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
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
        title: const Text("Notes"),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text("${index + 1}"),
                  title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                  trailing: SizedBox(
                    width: 100,
                    height: 50,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            titleController.text = allNotes[index]
                                [DBHelper.COLUMN_NOTE_TITLE];
                            descriptionController.text = allNotes[index]
                                [DBHelper.COLUMN_NOTE_DESC];
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (_) {
                                return getBottomSheetWidget(
                                  isUpdate: true,
                                  sNo: allNotes[index]
                                      [DBHelper.COLUMN_NOTE_SNO],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            await dbRef!.deleteNotes(
                                sNo: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                            getNotes();
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text("No Notes Yet!!")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          descriptionController.clear();
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return getBottomSheetWidget();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetWidget({bool isUpdate = false, int sNo = 0}) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isUpdate ? "Update Note" : "Add Note",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter title here",
                label: const Text("Title"),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter description here",
                label: const Text("Description"),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(width: 1),
                    ),
                    onPressed: () async {
                      var noteTitle = titleController.text;
                      var noteDesc = descriptionController.text;
                      if (noteTitle.isNotEmpty && noteDesc.isNotEmpty) {
                        bool check = isUpdate
                            ? await dbRef!.updateNotes(
                                title: noteTitle, desc: noteDesc, sNo: sNo)
                            : await dbRef!
                                .addNote(myTitle: noteTitle, myDesc: noteDesc);

                        if (check) {
                          getNotes();
                          Navigator.pop(context); // Close the modal sheet
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all the required fields"),
                          ),
                        );
                      }
                    },
                    child: Text(isUpdate ? "Update Note" : "Add Note"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(width: 1),
                    ),
                    onPressed: () {
                      Navigator.pop(context as BuildContext); // Close the modal sheet
                    },
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
