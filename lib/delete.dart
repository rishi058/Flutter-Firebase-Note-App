import 'package:flutter/material.dart';
import 'fire_notes.dart';
import 'Engine.dart';

void alert(String id, BuildContext ctx){
  showDialog(
    context: ctx,
    builder: (ctx) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text(
        'Do you want to remove this Note entry ?',
      ),
      actions: <Widget>[
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () async {
            await delete(id);
            Navigator.pushAndRemoveUntil(ctx, MaterialPageRoute(builder: (context) {return FireNote();},),(route) => false);
          },
        ),
      ],
    ),
  );
}
