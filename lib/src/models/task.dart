class Task{
  final String uid;
  final String category;
  final String title;
  final DateTime createdAt;
  final DateTime deadline;
  final bool isDone;
  final int point;
  final String parentId;
  final String childId;

  Task({this.uid, this.title, this.category, this.createdAt, this.isDone, this.point, this.deadline, this.childId, this.parentId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
