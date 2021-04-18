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
  Wish({this.uid, this.currentMoney, this.title, this.deadline, this.isDone, this.target, this.childId, this.createdAt, this.point});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wish && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
