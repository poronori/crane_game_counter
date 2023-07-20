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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
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
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              List<dynamic> person = data['dataList'] ?? [];
              String datetime = data['dateTime'] ?? "なし";
              return Column(
                children: [
                  Text(datetime),
                  Column(
                    children: person.map((dynamic unit) {
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            person.removeAt(unit);
                            deleteData(datetime, person);
                          });
                        },
                        child: ListTile(
                            title: Text(unit['name'] ?? ""),
                            subtitle: Text(unit['count'] ?? "0"),
                            leading: Text(unit['store'] ?? ""),
                            trailing: Text(unit['cost'] ?? "0")),
                      );
                    }).toList(),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
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
