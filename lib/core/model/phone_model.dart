
class PhonePeModel {
  PhonePeModel({
    this.status,
    this.error,
  });
  PhonePeModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    error = json["error"];
  }
  String? status;
  String? error;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["error"] = error;
    return data;
  }
}
