import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Note_structure.dart';
import 'dart:convert';
import 'dart:math';
import 'package:hexcolor/hexcolor.dart';
import 'auth.dart';
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
  int index = random.nextInt(10);
  return index;
}

final List<Notes> temp = [];

  Future<void> add (Notes note1) async {
    String s = 'https://firenotes-5b657-default-rtdb.firebaseio.com/notes/$userId.json?auth=$authToken' ;
    final url = Uri.parse(s);
    await http.post(url,body: json.encode({
      'id': note1.id,
      'title': note1.title,
      'date': note1.date,
      'description': note1.description,
      'color': note1.color,
    }),
    );


  }

  Future<void> delete(String id) async {
    final int index = temp.indexWhere((element) => element.id == id);
    temp.removeAt(index);

    final url = Uri.parse('https://firenotes-5b657-default-rtdb.firebaseio.com/notes/$userId/$id.json?auth=$authToken');
    await http.delete(url);

  }


  Future<void> update(String id, Notes note2) async {

    final int index = temp.indexWhere((element) => element.id == id);
    temp[index] = note2;

    final url = Uri.parse('https://firenotes-5b657-default-rtdb.firebaseio.com/notes/$userId/$id.json?auth=$authToken');

    await http.patch(url,
        body: json.encode({
          'id': note2.id,
          'description': note2.description,
          'title' : note2.title,
          'color': note2.color,
        }));

  }

  Future<void> get_all() async {
    final url = Uri.parse('https://firenotes-5b657-default-rtdb.firebaseio.com/notes/$userId.json?auth=$authToken');

    final response = await http.get(url);
    final data = json.decode(response.body) ;
    if(data==null){return;}
    temp.clear();
    data.forEach((id, note) {
      temp.add(Notes(
          id: id,
          title: note['title'],
          date: note['date'],
          description: note['description'],
          color: note['color'],
      ));
    });

  }
