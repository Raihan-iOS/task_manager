class Urls {
  static const String baseUrl = "http://35.73.30.144:2005/api/v1";
  static const String login = "${baseUrl}/Login";
  static const String registration = "${baseUrl}/Registration";
  static const String createTask = "${baseUrl}/createTask";
  static const String allTaskStatusCount = "${baseUrl}/taskStatusCount";
  static const String newTasks = "${baseUrl}/listTaskByStatus/New";
  static  String changeTaskStatus(String taskId,String status) => "${baseUrl}/updateTaskStatus/${taskId}/${status}";
}
