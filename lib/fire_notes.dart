import 'package:fire_notes/AppBar.dart';
import 'package:flutter/material.dart';
import 'Note_structure.dart';
import 'add.dart';
import 'Engine.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'delete.dart';
import 'Edit.dart';



class FireNote extends StatefulWidget {
  const FireNote({Key? key}) : super(key: key);

  @override
  State<FireNote> createState() => FireNoteState();
}

class FireNoteState extends State<FireNote> {
  List<Notes> Data = [];

  bool isLoading = true;

  void refresh() async {
    await get_all();
    setState(() {
      Data = List<Notes>.from(temp);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }



  @override
  Widget build(BuildContext context) {
    refresh();
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/8765.png"),
          fit: BoxFit.cover,
        ),

      ),
      child: Scaffold(
        drawer: My_Drawer(),
        appBar: AppBar(
          
          title: Center(child: Text('Fire Notes')),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  showForm(context);
                },
                icon: Icon(Icons.add)),
          ],
        ),
        backgroundColor: Colors.black12,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Data.isEmpty
                ? Center(
                    child: Container(
                      height: 65,
                      width: 235,
                      color: Colors.pinkAccent.withOpacity(0.7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('There is not any saved Note'),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Click on Add Icon to Create a Note')
                        ],
                      ),
                    ),
                  )
                : MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    itemCount: Data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: () {
                          alert(Data[index].id, context);
                        },
                        onTap: () {
                          Notes temp = Data[index];
                          Edit(temp, context);
                        },
                        child: Card(
                          elevation: 10,
                          color: HexColor(Data[index].color.substring(8, 16)),
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(3),
                                child: Center(
                                  child: Text(
                                    Data[index].date,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(6, 0, 6, 6),
                                child: Center(
                                  child: Text(
                                    Data[index].title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  Data[index].description,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
