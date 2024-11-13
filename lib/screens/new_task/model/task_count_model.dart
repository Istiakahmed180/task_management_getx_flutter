class TaskCountModel {
  String? status;
  List<TaskCountData>? data;

  TaskCountModel({this.status, this.data});

  TaskCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TaskCountData>[];
      json['data'].forEach((v) {
        data!.add(TaskCountData.fromJson(v));
      });
    }
  }
}

class TaskCountData {
  String? sId;
  int? sum;

  TaskCountData({this.sId, this.sum});

  TaskCountData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }
}
