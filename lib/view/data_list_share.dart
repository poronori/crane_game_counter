import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/data_model_share.dart';

class DataListShare extends StatefulWidget {
  final List<DataModelShare> dataList;

  const DataListShare({Key? key, required this.dataList}) : super(key: key);

  @override
  State<DataListShare> createState() => _DataListShare();
}

class _DataListShare extends State<DataListShare> {

  List<DocumentSnapshot> documentList = [];

  // DBの監視用ストリーム
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('test_collection').snapshots();

  int id = 0;
  String text = '';
  String datetime = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        StreamBuilder<QuerySnapshot>(
        stream: _userStream, // DB監視用のストリーム
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }
          return Column(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              List<dynamic> person = data['person'];
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Text(data['dateTime']);
                  }
                  return Dismissible(
                    key: Key(person.toString()),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        person.removeAt(index);
                        deleteData(person);
                      });
                    },
                    child: ListTile(
                      title: Text(person[index]['age']),
                      subtitle: Text(person[index]['name']),
                    ),
                  );
                },
              );
            }).toList());
        },
      ),
      ],
    );
  }

  Future getDataList(String date) async {
    final document = await FirebaseFirestore.instance
        .collection('test_collection')
        .doc('testDoc')
        .get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    List<dynamic> person = data['person'];

    return person;
  }

  deleteData(List<dynamic> person) {
    DataModelShare updateData = DataModelShare("2022-08-18", person);
    FirebaseFirestore.instance
        .collection('test_collection')
        .doc('testDoc')
        .update(updateData.updateToJson());
  }
}
