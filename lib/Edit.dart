import 'package:fire_notes/Engine.dart';
import 'package:flutter/material.dart';
import 'fire_notes.dart';
import 'package:intl/intl.dart';
import 'Note_structure.dart';

void Edit(Notes note, BuildContext context) async {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  _titleController.text = note.title;
  _descriptionController.text = note.description;

   showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          // this will prevent the soft keyboard from covering the text fields
          bottom: MediaQuery.of(context).viewInsets.bottom + 300,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              autofocus: true,
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                Notes temp = Notes(
                    id: note.id,
                    title: _titleController.text,
                    date: DateFormat.yMEd().format(DateTime.now()),
                    description: _descriptionController.text,
                    color: note.color,
                );
                await update(note.id, temp);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return FireNote();},),(route) => false);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ));
}