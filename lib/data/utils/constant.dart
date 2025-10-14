class Urls {
  static const String baseUrl = "http://35.73.30.144:2005/api/v1";
  static const String login = "${baseUrl}/Login";
  static const String registration = "${baseUrl}/Registration";
  static const String createTask = "${baseUrl}/createTask";
  static const String allTaskStatusCount = "${baseUrl}/taskStatusCount";
  static const String newTasks = "${baseUrl}/listTaskByStatus/New";
  static const String cancelledTasks = "${baseUrl}/listTaskByStatus/Cancelled";
  static const String completedTasks = "${baseUrl}/listTaskByStatus/Completed";
  static const String progressTasks = "${baseUrl}/listTaskByStatus/Progress";
  static  String changeTaskStatus(String taskId,String status) => "${baseUrl}/updateTaskStatus/${taskId}/${status}";
  static  String  deleteTask(String taskId) => "${baseUrl}/deleteTask/${taskId}";
}
