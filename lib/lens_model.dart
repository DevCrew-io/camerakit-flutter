class LensModel {
  String? id;
  String? name;
  String? facePreference;
  String? groupId;
  List<String>? snapCodes;
  List<String>? previews;
  List<String>? thumbnail;

  LensModel(
      {this.id,
      this.name,
      this.facePreference,
      this.groupId,
      this.snapCodes,
      this.previews,
      this.thumbnail});

  LensModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    facePreference = json['facePreference'];
    groupId = json['groupId'];
    if (json['snapcodes'] != null) {
      snapCodes = <String>[];
      json['snapcodes'].forEach((v) {
        snapCodes!.add(v as String);
      });
    }
    if (json['previews'] != null) {
      previews = <String>[];
      json['previews'].forEach((v) {
        previews!.add(v as String);
      });
    }
    if (json['thumbnail'] != null) {
      thumbnail = <String>[];
      json['thumbnail'].forEach((v) {
        thumbnail!.add(v as String);
      });
    }
  }
}
