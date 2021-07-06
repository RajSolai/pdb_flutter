import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdb_flutter/screens/list.dart';
import 'package:pdb_flutter/screens/project.dart';

class DbCard extends StatelessWidget {
  final String name, desc, type, id;
  const DbCard(
      {Key? key,
      required String this.name,
      required String this.desc,
      required String this.id,
      required String this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Widget screen;
          type == "project"
              ? screen = ProjectScreen(id: id,)
              : screen = ListScreen(id: id);
          Navigator.push(context, CupertinoPageRoute(builder: (ctx) => screen));
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  this.name,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(this.desc),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
