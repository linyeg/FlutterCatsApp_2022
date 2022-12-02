import 'package:flutter/material.dart';
import 'package:flutter_app_1/Screens/taken_picture_screen.dart';
import 'package:flutter_app_1/helpers/database_helper.dart';
import 'package:flutter_app_1/models/cat_model.dart';


class HomeScreen extends StatefulWidget{
  const HomeScreen ({Key? key}): super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int? catId;
  final textControllerRace = TextEditingController();
  final textControllerName = TextEditingController();

  @override
  Widget build(BuildContext context){
    
    /*final textControllerRace = TextEditingController();
    final textControllerName = TextEditingController(); */

    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Example with Cats'), 
        elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: textControllerRace, decoration: const InputDecoration(
                icon: Icon(Icons.view_comfortable),
                labelText: 'Input the race of cat'
              ) 
            ),
            TextFormField(
              controller: textControllerName, decoration: const InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText: 'Input the name of cat'
              ) 
            ),
            FloatingActionButton(onPressed:() {
              Navigator.pushNamed(context, 'picture');
            }),
            Center(
              child: (
                FutureBuilder<List<Cat>> (
                  future: DatabaseHelper.instance.getCats(),
                  builder: (BuildContext context, AsyncSnapshot<List<Cat>> snapshot) {
                    if(!snapshot.hasData){
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text('Loading...'),
                        ),
                      );
                    }
                    else {
                      return snapshot.data!.isEmpty ? Center(child: Container(child: const Text('No cats in the list'))) :
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data!.map((cat) {
                            return Center(
                              child: Card(
                                color: catId == cat.id ? Colors.amber : Colors.white,
                                child: ListTile(
                                  textColor: catId == cat.id ? Colors.white : Colors.black,
                                  title: Text('Name: ${cat.name} | Race: ${cat.race}'),
                                  onLongPress: () {
                                      setState(() {
                                        DatabaseHelper.instance.delete(cat.id!);
                                      }
                                    );
                                  },
                                  onTap: () {
                                    setState(() {
                                      if (catId == null){
                                        textControllerName.text = cat.name;
                                        textControllerRace.text = cat.race;
                                      } else {
                                        textControllerName.clear();
                                        textControllerRace.clear();
                                        catId = null;
                                      }
                                    });
                                  },
                                )
                              )
                            );
                          }
                        ).toList()
                      );
                    }
                  },
                )
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: 
          Icon(Icons.save),
          onPressed: () async {
            if (catId != null) {
              await DatabaseHelper.instance.update(
                Cat(
                  name: textControllerName.text,
                  race: textControllerRace.text,
                  id: catId,
                  )
              );
            }
            DatabaseHelper.instance.add(
              Cat(race: textControllerRace.text, name: textControllerName.text)
            );
            setState(() {
                textControllerName.clear();
                textControllerRace.clear();
              }
            );
          },
        ),
    );
      }
}