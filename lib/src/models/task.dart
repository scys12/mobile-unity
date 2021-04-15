class Task{
  final String uid;
  final String category;
  final String title;
  final DateTime createdAt;
  final DateTime deadline;
  final bool isDone;
  final int point;

  Task({this.uid, this.title, this.category, this.createdAt, this.isDone, this.point, this.deadline});
}
