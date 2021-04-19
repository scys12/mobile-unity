import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/task_database.dart';

class TaskProvider extends ChangeNotifier{
  Task selectedTask;
  List<Task> tasks;
  List<Task> educations;
  List<Task> twoTasks;

  Future<void> getTask({taskId: String}) async{
    var task = await TaskDatabase(uid: taskId).getTask();
    selectedTask = task;
    notifyListeners();
  }

  Future<void> getChildTaskFromParent({childId: String, parentId: String}) async{
    var tasks = await TaskDatabase().getChildTaskFromParent(childId, parentId);
    this.tasks = tasks.where((element) => element.category != 'Edukasi Finansial').toList();
    notifyListeners();
  }

  Future<void> getFinishTasks({childId: String, parentId: String}) async{
    var tasks = await TaskDatabase().getFinishedTasks(childId, parentId);
    this.tasks = tasks;
    notifyListeners();
  }

  Future<void> getTasksNearDeadlineAndNotDone({childId: String, parentId: String}) async{
    var tasks = await TaskDatabase().getChildTaskNearDeadline(childId, parentId);
    this.tasks = tasks;
    notifyListeners();
  }

  Future<void> getTwoChildTasksNearDeadline({childId: String, parentId: String}) async{
    var tasks = await TaskDatabase().getTwoTasksNotFinished(childId, parentId);
    this.twoTasks = tasks.take(2).toList();
    notifyListeners();
  }

  Future<void> getChildEducationFromParent({childId: String, parentId: String}) async{
    var educations = await TaskDatabase().getChildEducationFromParent(childId, parentId);
    this.educations = educations;
    notifyListeners();
  }
}