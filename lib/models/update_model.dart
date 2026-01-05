class UpdateModel {
  String? appName;
  int? appVersion;
  String? downloadUrl;
  String? description;
  String? versionCode;
  bool isForce = false;

  UpdateModel({
    this.appName,
    this.appVersion,
    this.downloadUrl,
    this.description,
    this.versionCode,
    this.isForce = false,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> map) {
    return UpdateModel(
      appName: map['appName'],
      appVersion: int.tryParse(map["appVersion"].toString()),
      downloadUrl: map['downloadUrl'],
      description: map['description'],
      versionCode: map['versionCode'],
      isForce: int.parse(map["isForce"].toString()) == 1,
    );
  }
}
