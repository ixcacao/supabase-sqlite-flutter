
import '../names.dart';

class Money {
  late int id;
  late String userId;
  late String amount;


  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnAmount: amount,
      columnUserId: userId
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }


  Money.fromMap(Map map) {
    id = map[columnId];
    userId = map[columnUserId];
    amount = map[columnAmount];
  }
}



