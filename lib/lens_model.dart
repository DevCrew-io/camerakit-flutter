//
//  lens_model.dart
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//

class Lens {
  String? id;
  String? name;
  String? facePreference;
  String? groupId;
  List<String>? snapCodes;
  List<String>? previews;
  List<String>? thumbnail;

  Lens(
      {this.id,
      this.name,
      this.facePreference,
      this.groupId,
      this.snapCodes,
      this.previews,
      this.thumbnail});

  Lens.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    facePreference = json['facePreference'];
    groupId = json['groupId'];
    snapCodes = json['snapcodes'].cast<String>();
    previews = json['previews'].cast<String>();
    thumbnail = json['thumbnail'].cast<String>();
  }
}
