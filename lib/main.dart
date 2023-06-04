import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: "My App",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List? data;

  Future getData() async {
    try {
      var request = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));
      // print(request.body);
      setState(() {
        data = json.decode(request.body);
      });
    } catch (e) {
      print(e);
    }
  }

  void remoteData(id) {
    data!.removeWhere((element) => element['id'] == id);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Title'),
      // ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                "Todo List App",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              data != null && data!.length > 0
                  ? Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                    "${data![index]['title'].toString().toUpperCase().substring(data![index]['title'].length - 1)}"),
                              ),
                              title: Text(data![index]['title']),
                              subtitle: data![index]['completed']
                                  ? Text("Task: Complete")
                                  : Text("Task: Pending"),
                              trailing: data![index]['completed']
                                  ? IconButton(
                                      color: Colors.green,
                                      icon: Icon(Icons.done),
                                      onPressed: () {
                                        showBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              width: double.infinity,
                                              height: 300,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    data![index]['title'],
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.white),
                                                  ),
                                                  data![index]['completed']
                                                      ? Text(
                                                          "Task: Complete",
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      : Text(
                                                          "Task: Pending",
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Close"))
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                        // showAboutDialog(
                                        //     context: context,
                                        //     children: [
                                        //       Text(data![index]['title']),
                                        //       data![index]['completed']
                                        //           ? Text("Task: Complete")
                                        //           : Text("Task: Pending")
                                        //     ]);
                                      },
                                    )
                                  : IconButton(
                                      color: Colors.red,
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        remoteData(data![index]['id']);
                                      },
                                    ),
                            ),
                          );
                        },
                        itemCount: data!.length,
                      ),
                    )
                  : Text("Loading...")
            ],
          ),
        ),
      ),
    );
  }
}
