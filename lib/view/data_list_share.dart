import 'package:flutter/cupertino.dart';
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
  // 表示項目
  String _name = ''; // 景品名
  String _cost = ''; // プレイ料金
  String _count = ''; // プレイ回数
  String _amount = ''; // 合計金額
  String _store = ''; // 店名

  List<DocumentSnapshot> documentList = [];

  // DBの監視用ストリーム
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection(Const.collectionName).snapshots();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5),
      child: StreamBuilder<QuerySnapshot>(
        stream: _userStream, // DB監視用のストリーム
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }
          // 新しい順に並び替え
          List<DocumentSnapshot> documents = List.from(snapshot.data!.docs.reversed);
          return Column(
            // DBのドキュメントを全て読み込む
            children: documents.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              List<dynamic> items = data['dataList'] ?? []; // 日付毎のデータリスト（データ操作用）
              if (items.isEmpty) {
                print('データなし');
                return const SizedBox();
              }
              // 新しい順に並び替え(表示用)
              List<dynamic> item = List.from(items.reversed);
              String date = data['dateTime'] ?? "なし"; // 日付
              return Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 3, bottom: 4, left: 18, right: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[800]!.withOpacity(0.35),
                          ),
                          child: Text(
                            date,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                  Column(
                    // 日付毎のデータリストをループして表示する
                    children: item.map((dynamic unit) {
                      _name = unit['name'] ?? '名前なし';
                      _cost = unit['cost'] ?? '0';
                      _count = unit['count'] ?? '0';
                      _store = unit['store'] ?? '不明';
                      _count = _count.isEmpty ? '0' : _count;
                      _cost = _cost.isEmpty ? '0' : _cost;
                      _amount =
                          (int.parse(_cost) * int.parse(_count)).toString();
                      // スライドで削除
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            items.remove(unit);
                            deleteData(date, items);
                          });
                        },

                        // 削除時の確認ダイアログ
                        confirmDismiss: (direction) async {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                  title: const Text("確認"),
                                  content: const Text("スワイプしたデータを削除します"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('キャンセル'),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ]);
                            },
                          );
                        },

                        // 表示項目
                        child: Card(
                          child: ListTile(
                            // 景品名
                            title: Text(
                              _name, // nullの場合は空文字
                              style: const TextStyle(fontSize: 30),
                              overflow: TextOverflow.ellipsis, // 名前が長すぎる場合は切る
                            ),

                            // 店名、プレイ料金、手数
                            subtitle: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Text(_store,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Container(
                                  width: 40,
                                  alignment: Alignment.centerRight,
                                  child: Text('$_cost円',
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Container(
                                  width: 40,
                                  alignment: Alignment.centerRight,
                                  child: Text('$_count手',
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),

                            // 合計金額
                            trailing: Container(
                              width: 100,
                              alignment: Alignment.centerRight, // 右寄せ
                              child: Text(
                                '$_amount円',
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                        ),
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

  // データ削除処理
  deleteData(String date, List<dynamic> person) {
    // 最後の一つだった場合はドキュメントごと削除
    if (person.isEmpty) {
      FirebaseFirestore.instance
        .collection(Const.collectionName)
        .doc(date)
        .delete();
    } else {
      DataModelShare updateData = DataModelShare(date, person);
      FirebaseFirestore.instance
        .collection(Const.collectionName)
        .doc(date)
        .update(updateData.updateToJson());
    }
  }
}
