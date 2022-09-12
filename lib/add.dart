import 'package:flutter/material.dart';
import 'Note_structure.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'Engine.dart';
import 'fire_notes.dart';

var Color = [
  ColorToHex(Colors.lightBlue).toString(),
  ColorToHex(Colors.red.shade300).toString(),
  ColorToHex(Colors.purple.shade200).toString(),
  ColorToHex(Colors.greenAccent).toString(),
  ColorToHex(Colors.lightBlueAccent).toString(),
  ColorToHex(Colors.pinkAccent).toString(),
  ColorToHex(Colors.orange.shade300).toString(),
  ColorToHex(Colors.limeAccent.shade200).toString(),
  ColorToHex(Colors.purpleAccent).toString(),
  ColorToHex(Colors.tealAccent).toString(),
];

Random random = new Random();

int changeIndex() {
  var index = random.nextInt(10);
  return index;
}

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();



  Future<void> pressed() async {
    Notes note = Notes(
        id: '..',
        title: _titleController.text,
        date: DateFormat.yMEd().format(DateTime.now()),
        description: _descriptionController.text,
        color: Color[changeIndex()]
    );

      temp.add(note);
     await add(note);
  }

  void showForm(BuildContext context) async {
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
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
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
                    onPressed: () {
                      pressed();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return FireNote();},),(route) => false);
                      _titleController.text = '';
                      _descriptionController.text = '';
                      },
                    child: Text('Add'),
                  ),
                ],
              ),
            ));
  }
