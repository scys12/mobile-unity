import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:mobile_unity/src/models/wish.dart';
import 'package:mobile_unity/src/services/wish_database.dart';

class WishProvider extends ChangeNotifier{
  Wish selectedWish;
  List<Wish> wishes;

  Future<void> getWish({wishId: String}) async{
    var wish = await WishDatabase(uid: wishId).getWishById();
    selectedWish = wish;
    notifyListeners();
  }

  Future<void> getWishes({childId: String}) async {
    var wishes = await WishDatabase().getWishes(childId);
    this.wishes = wishes;
    notifyListeners();
  }
}