import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdb_flutter/components/dbcard.dart';
import 'package:pdb_flutter/services/fetchdatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String token;
  String projectName = "";
  String projectDesc = "";
  String type = "Project";
  late FetchDatabase fetchDatabase;

  Future<void> getToken() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("token") ?? "";
    });
  }

  void reBuildDialog(BuildContext context) {
    Navigator.pop(context);
    var nameCtrl = TextEditingController(text: projectName);
    var descCtrl = TextEditingController(text: projectDesc);
    showAddProjectDialog(nameCtrl, descCtrl);
  }

  void showAddProjectDialog(TextEditingController? nameTextController,
      TextEditingController? descTextController) {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Text("Create New Project"),
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (String e) {
                      setState(() {
                        projectName = e;
                      });
                    },
                    controller: nameTextController,
                    decoration: InputDecoration(
                      hintText: "Enter Project Name",
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    onChanged: (String e) {
                      setState(() {
                        projectDesc = e;
                      });
                    },
                    controller: descTextController,
                    decoration: InputDecoration(
                      hintText: "Enter Project Description",
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  DropdownButton<String>(
                    value: type,
                    hint: Text("Select the Project type"),
                    items:
                        ["Project", "List"].map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        type = val!;
                      });
                      reBuildDialog(ctx);
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => fetchDatabase.addProject(
                      type, projectName, projectDesc, context),
                  child: Text("Create Project"),
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getToken().then((_) {
      setState(() {
        fetchDatabase = FetchDatabase(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Database",
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddProjectDialog(null, null),
        child: Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 100,
                margin: EdgeInsets.all(5.0),
                child: StreamBuilder(
                  stream: fetchDatabase.databaseStream,
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = snapshot.data![index];
                          return DbCard(
                            name: item['name'],
                            desc: item['description'],
                            id: item['id'],
                            type: item['type'],
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7C3AED),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fetchDatabase.dispose();
    super.dispose();
  }
}
