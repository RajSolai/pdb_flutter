import 'package:flutter/material.dart';

class DragCard extends StatelessWidget {
  final String task;
  const DragCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      child: Card(
        child: ListTile(
          title: Text(this.task),
          trailing: IconButton(
            onPressed: () => {},
            icon: Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
