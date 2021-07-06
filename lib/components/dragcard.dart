import 'package:flutter/material.dart';

class DragCard extends StatelessWidget {
  final String task;
  final removeItem;
  const DragCard({Key? key, required this.task, required this.removeItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      child: Card(
        child: ListTile(
          title: Text(this.task),
          trailing: IconButton(
            onPressed: removeItem,
            icon: Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
