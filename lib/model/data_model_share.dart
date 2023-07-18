// DBに送る用
class DataModelShare {
  String dateTime;
  List<dynamic> dataList;

  DataModelShare(this.dateTime, this.dataList);

  toJson() {
    Map<String, dynamic> res = {
      'dateTime': dateTime,
      'person': dataList,
    };
    return res;
  }

  updateToJson() {
    Map<String, dynamic> data = {
      'person': dataList
    };
    return data;
  }
}

// それぞれのデータ
class UnitData {
  String age;
  String name;

  UnitData(this.age, this.name);

  toMap() {
    Map<String, dynamic> res = {
      'age': age,
      'name': name,
    };
    return res;
  }
}