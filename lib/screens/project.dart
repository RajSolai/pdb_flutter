import 'package:dio/dio.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/non_secure.dart';
import 'package:pdb_flutter/components/dragcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectScreen extends StatefulWidget {
  final String id;
  ProjectScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List _completed = [];
  List _notStarted = [];
  List _progress = [];
  List<List> _ofLists = [];

  List<DragAndDropItem> uiCompleted = [];
  List<DragAndDropItem> uiNstart = [];
  List<DragAndDropItem> uiProgress = [];
  List<List<DragAndDropItem>> ofUiLists = [];
  late BaseOptions _baseOptions;
  late String token;

  String newTaskText = "";
  String databaseName = "Loading...";

  Future<void> getToken() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("token") ?? "";
    });
  }

  void removeTask(idItem, listIndex) {
    var thatTask =
        _ofLists.elementAt(listIndex).firstWhere((e) => e['id'] == idItem);
    var index = _ofLists.elementAt(listIndex).indexOf(thatTask);
    setState(() {
      _ofLists.elementAt(listIndex).removeAt(index);
      genUI();
    });
  }

  void genUI() {
    uiCompleted = _completed
        .map(
          (e) => DragAndDropItem(
            child: DragCard(
              task: e['task']!,
              removeItem: () => removeTask(e['id'], 2),
            ),
          ),
        )
        .toList();
    uiNstart = _notStarted
        .map(
          (e) => DragAndDropItem(
            child: DragCard(
              task: e['task']!,
              removeItem: () => removeTask(e['id'], 0),
            ),
          ),
        )
        .toList();
    uiProgress = _progress
        .map(
          (e) => DragAndDropItem(
            child: DragCard(
              task: e['task']!,
              removeItem: () => removeTask(e['id'], 1),
            ),
          ),
        )
        .toList();
    ofUiLists.addAll([uiNstart, uiProgress, uiCompleted]);
  }

  void fetchProjectBody() async {
    var res = await Dio(_baseOptions).get(
      "https://fast-savannah-26464.herokuapp.com/database/${widget.id}",
    );
    if (res.statusCode == 200) {
      setState(() {
        databaseName = res.data['name'];
        _notStarted = res.data['body']['notStarted'];
        _completed = res.data['body']['completed'];
        _progress = res.data['body']['progress'];
        genUI();
        _ofLists.addAll([_notStarted, _progress, _completed]);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getToken().then(
      (_) => {
        _baseOptions = BaseOptions(headers: {"auth-token": token}),
        fetchProjectBody()
      },
    );
  }

  void saveChanges() async {
    var newBody = {
      "notStarted": _notStarted,
      "completed": _completed,
      "progress": _progress
    };
    var res = await Dio(_baseOptions).put(
        "https://fast-savannah-26464.herokuapp.com/project/${widget.id}",
        data: newBody);
    if (res.statusCode == 200) {
      fetchProjectBody();
    }
  }

  void addTask() {
    Map<String, String> newTaskObj = {"id": nanoid(8), "task": newTaskText};
    var newTask = DragAndDropItem(
      child: DragCard(
        task: newTaskObj['task']!,
        removeItem: () => removeTask(newTaskObj['id'], 0),
      ),
    );
    _notStarted.add(newTaskObj);
    setState(() {
      uiNstart.add(newTask);
    });
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
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.10),
              child: DragAndDropLists(
                verticalAlignment: CrossAxisAlignment.center,
                children: [
                  DragAndDropList(
                    children: uiNstart,
                    header: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Not Started",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  DragAndDropList(
                    children: uiProgress,
                    header: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Progress",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  DragAndDropList(
                    children: uiCompleted,
                    header: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
                onItemReorder:
                    (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
                  var e =
                      ofUiLists.elementAt(oldListIndex).removeAt(oldItemIndex);
                  var task =
                      _ofLists.elementAt(oldListIndex).removeAt(oldItemIndex);
                  _ofLists.elementAt(newListIndex).add(task);
                  setState(() {
                    ofUiLists.elementAt(newListIndex).add(e);
                  });
                },
                onListReorder: (oldIndex, newIndex) {
                  print("lo");
                },
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
                          ),
                        ),
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
                            onPressed: () => addTask(),
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

  @override
  void dispose() {
    super.dispose();
  }
}
