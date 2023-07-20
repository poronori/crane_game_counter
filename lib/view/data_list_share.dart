import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/constants.dart';
import '../model/data_model_share.dart';

class DataListShare extends StatefulWidget {

  const DataListShare({Key? key}) : super(key: key);

  @override
  State<DataListShare> createState() => _DataListShare();
}

class _DataListShare extends State<DataListShare> {

  List<DocumentSnapshot> documentList = [];

  // DBの監視用ストリーム
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection(Const.collectionName).snapshots();

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
              List<dynamic> person = data['dataList'];
              String datetime = data['dateTime'];
              return ListView.builder(
                shrinkWrap: true,
                itemCount: person.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Text(datetime);
                  }
                  return Dismissible(
                    key: Key(person.toString()),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        person.removeAt(index - 1);
                        deleteData(datetime, person);
                      });
                    },
                    child: ListTile(
                      title: Text(person[index - 1]['name']),
                      subtitle: Text(person[index - 1]['count']),
                      leading: Text(person[index - 1]['store'])
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
      ],
    );
  }

  Future getDataList(String date) async {
    final document = await FirebaseFirestore.instance
        .collection(Const.collectionName)
        .doc(date)
        .get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    List<dynamic> person = data['dataList'];

    return person;
  }

  deleteData(String date, List<dynamic> person) {
    DataModelShare updateData = DataModelShare(date, person);
    FirebaseFirestore.instance
        .collection(Const.collectionName)
        .doc(date)
        .update(updateData.updateToJson());
  }
}
