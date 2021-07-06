import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdb_flutter/components/dbcard.dart';
import 'package:pdb_flutter/screens/list.dart';
import 'package:pdb_flutter/services/fetchdatabase.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final fetchDatabase = FetchDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Select Database",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
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
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    fetchDatabase.dispose();
  }
}
