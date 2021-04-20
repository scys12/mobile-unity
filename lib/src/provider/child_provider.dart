import 'package:flutter/cupertino.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/services/child_database.dart';

class ChildProvider extends ChangeNotifier{
  Child selectedChild;

  Future<void> getCurrentChild({parentId: String}) async {
    var resp = await ChildDatabase().getOneChild(parentId);
    var child = resp[0];
    this.selectedChild = child;
    notifyListeners();
  }

  Future<void> getChild({childId: String}) async{
    var resp = await ChildDatabase(uid: childId).getChild();
    this.selectedChild = resp;
    notifyListeners();
  }

  updateCurrentChild({child: Child}) {
    selectedChild = child;
    notifyListeners();
  }
}