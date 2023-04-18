import 'package:flutter/material.dart';
import 'package:sale_manager/model/data_model.dart';
import 'package:sale_manager/view/add_item_page.dart';
import 'package:sale_manager/view/data_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<DataModel> dataList = List<DataModel>.empty();

  @override
  void initState() {
    super.initState();

    Future(() async {
      dataList = await DataModel.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DataList(dataList: dataList),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ), 
            builder: (context) => const AddItemPage(),
          );
          if (result == true) {
            dataList = await DataModel.getData();
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ), 
    );
  }
}
