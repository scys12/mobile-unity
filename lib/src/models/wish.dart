class Wish{
  final String uid;
  final int currentMoney;
  final String title;
  final DateTime deadline;
  final bool isDone;
  final int target;
  final String childId;
  final DateTime createdAt;
  final int point;
  final int frekuensi;
  final int expectedMoney;

  Wish({this.uid, this.expectedMoney,this.currentMoney, this.title, this.deadline, this.isDone, this.target, this.childId, this.createdAt, this.point, this.frekuensi});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wish && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
