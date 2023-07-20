/*
DB構成
[collection] - [document] - [data]
prise_collection - {datetime} - datetime
                              - datalist
                                - datetime
                                - name
                                - cost
                                - count
                                - store
*/
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/constants.dart';
// DBに送る用
class DataModelShare {
  String dateTime;
  List<dynamic> dataList;

  DataModelShare(this.dateTime, this.dataList);

  toJson() {
    Map<String, dynamic> res = {
      'dateTime': dateTime,
      'dataList': dataList,
    };
    return res;
  }

  updateToJson() {
    Map<String, dynamic> data = {
      'dataList': dataList
    };
    return data;
  }
}

// それぞれのデータ
class UnitData {
  String datetime;
  String name;
  String cost;
  String count;
  String store;

  UnitData({
    required this.datetime, 
    required this.name, 
    this.cost = "100", 
    this.count = "0", 
    this.store = "",
  });

  toMap() {
    Map<String, dynamic> res = {
      'datetime': datetime,
      'name': name,
      'cost': cost,
      'count': count,
      'store': store,
    };
    return res;
  }

  insertData() async {
    // 当日のドキュメントを取得
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(Const.collectionName).doc(datetime).get();

    // その日のデータが存在していればドキュメントを更新
    if (snapshot.exists) {
      Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
      List<dynamic> dataList = map['dataList'];
      dataList.add(toMap());
      
      DataModelShare updateData = DataModelShare(datetime,dataList);
      FirebaseFirestore.instance
        .collection(Const.collectionName)
        .doc(datetime)
        .update(updateData.updateToJson());
    // その日の初めてのデータなら新規登録
    } else {
      List<dynamic> dataList = [toMap()];
      DataModelShare newData = DataModelShare(datetime, dataList);
      FirebaseFirestore.instance
        .collection(Const.collectionName)
        .doc(datetime)
        .set(newData.toJson());
    }
  }
}