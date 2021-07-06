import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListScreen extends StatefulWidget {
  final id;
  const ListScreen({Key? key, @required this.id}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<dynamic> todoList = [];
  List<dynamic> completedList = [];
  String databaseName = "Loading...";
  String newTaskText = "";
  late String token;
  late BaseOptions _baseOptions;

  Future<void> getToken() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("token") ?? "";
    });
  }

  void makeApiCall() async {
    var res = await Dio(_baseOptions).get(
      "https://fast-savannah-26464.herokuapp.com/database/${widget.id}",
    );
    if (res.statusCode == 200) {
      setState(() {
        todoList = res.data['body']['todoList'];
        completedList = res.data['body']['completedList'];
        databaseName = res.data['name'];
      });
      print(todoList);
    } else {
      print(res.statusCode);
    }
  }

  void handleTask(bool val, String id) {
    if (!val) {
      print("move to todolist");
      var item = completedList.firstWhere(
          (element) => (element['id'].toString() == id),
          orElse: () => "nothign");
      var remaining = completedList
          .where((element) => (element['id'].toString() != id))
          .toList();
      setState(() {
        todoList.add(item);
        completedList = remaining;
      });
    } else {
      print("move to completed");
      var item = todoList.firstWhere(
          (element) => (element['id'].toString() == id),
          orElse: () => "nothign");
      var remaining = todoList
          .where((element) => (element['id'].toString() != id))
          .toList();
      setState(() {
        completedList.insert(0, item);
        todoList = remaining;
      });
    }
  }

  void addnewTask() {
    Map<String, dynamic> task = {
      "id": nanoid(8),
      "task": newTaskText,
      "checked": false
    };
    setState(() {
      todoList.insert(0, task);
    });
  }

  void saveChanges() async {
    var newBody = {"todoList": todoList, "completedList": completedList};
    print(newBody);
    var res = await Dio(_baseOptions).put(
      "https://fast-savannah-26464.herokuapp.com/list/${widget.id}",
      data: newBody,
    );
    print(res.data);
  }

  @override
  void initState() {
    super.initState();
    getToken().then(
      (_) => {
        _baseOptions = BaseOptions(
          headers: {"auth-token": token},
        ),
        makeApiCall()
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          databaseName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 1.9,
                      minHeight: 0.0,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: todoList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var task = todoList[index];
                        return ListTile(
                          leading: Checkbox(
                            onChanged: (val) {
                              handleTask(val!, task['id']);
                            },
                            value: false,
                          ),
                          title: Text(task['task']),
                        );
                      },
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 1.9,
                      minHeight: 0.0,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: completedList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var task = completedList[index];
                        return ListTile(
                          leading: Checkbox(
                            onChanged: (val) {
                              handleTask(val!, task['id']);
                            },
                            value: true,
                          ),
                          title: Text(task['task']),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.12,
            minChildSize: 0.12,
            maxChildSize: 0.50,
            builder: (context, ctrl) {
              return ListView(
                controller: ctrl,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 1.0)
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              height: 5.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          child: ElevatedButton(
                            onPressed: () => {saveChanges()},
                            child: Text("Save Changes to DataBase"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          child: TextField(
                            onChanged: (val) => {
                              setState(() {
                                newTaskText = val;
                              })
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.task_alt_rounded),
                              hintText: "Enter Task Name",
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          child: ElevatedButton(
                            onPressed: () => addnewTask(),
                            child: Text("Add to Task List"),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
