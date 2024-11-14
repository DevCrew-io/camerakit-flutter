# camerakit-flutter
[![pub package](https://img.shields.io/pub/v/camerakit_flutter.svg)](https://pub.dev/packages/camerakit_flutter)
[![license](https://img.shields.io/badge/license-MIT-green)](https://github.com/DevCrew-io/expandable-richtext/blob/main/LICENSE)
![](https://img.shields.io/badge/Code-Dart-informational?style=flat&logo=dart&color=29B1EE)
![](https://img.shields.io/badge/Code-Flutter-informational?style=flat&logo=flutter&color=0C459C)

An open-source SDK package for Flutter that provides developers with seamless integration and access to Snapchat's CameraKit features within their Flutter applications. Flutter developers now can access set configuration from Flutter for both platforms (IOS and Android), you can open CameraKit , get media results (Images and Videos) and get list of lenses against group ids.

## Obtaining CameraKit Keys

Your App ID and API Token can be found in the [Snap Kit Portal](https://devportal.snap.com/) and is used to provide authorized access to Camera Kit remote services.
For more information you can read the docs [Android](https://docs.snap.com/camera-kit/integrate-sdk/mobile/android#service-authorization), [IOS](https://docs.snap.com/camera-kit/integrate-sdk/mobile/ios#service-authorization).


#### CAUTION
**API Token** is different for **Production** and **Staging** Environment. A watermark will be applied to the camera view when using the Staging API token.

## Configuration 
Once you have access to the account, locate your **groupIds** and **cameraKitApiToken**.

Now that you have obtained all your credentials, you can use it to initialize the Configuration class in your Flutter application as mentioned in the below section.

```dart
class Constants {
    /// List of group IDs for Camera Kit
    static const List<String> groupIdList = ['your-group-ids']; // TODO: Fill group IDs here
}
```

#### Android Setup
The easiest way to include this, is to define a <meta-data> tag in AndroidManifest.xml with a Camera Kit application ID value under <application> tag:

```dart
<application ...>
    <meta-data android:name="com.snap.camerakit.app.id" android:value="" />
    <meta-data android:name="com.snap.camerakit.api.token" android:value="" />
</application>
```

#### iOS Setup
Add `SCCameraKitClientID` (string), and set it to your application's Snap Kit App ID in your application's `Info.plist` file.
Add `SCCameraKitAPIToken` (string), and set it to your application's API Token in your application's `Info.plist` file.

**Note:** To use production api token, your camerakit app should be approved and live on snapchat developer portal.
Otherwise the app may cause `unauthorized` exception. [Read more](https://docs.snap.com/camera-kit/app-review/release-app) about submitting app for review

## Installation
First, add `camerakit_flutter:` as a dependency in your pubspec.yaml file.
Then run ```flutter pub get``` to install the package.

Now in your Dart code, you can use:
```dart
import 'package:camerakit_flutter/camerakit_flutter.dart';
```
## iOS
Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:

* NSCameraUsageDescription - describe why your app needs permission for the camera library.  It's a privacy feature to ensure that apps don't access sensitive device features without the user's knowledge and consent.
* NSMicrophoneUsageDescription - used to explain to the user why the app needs access to the device's microphone.
```dart
<key>NSCameraUsageDescription</key>
<string>app need camera permission for showing camerakit lens</string>
<key>NSMicrophoneUsageDescription</key>
<string>app need microphone permission for recording a video</string>
```
* (Optional: To fix cocoapods installation error) Inside `Podfile` under `iOS` directory of your flutter project, uncomment the following line and set the iOS version 13
  ```
  platform :ios, '13.0'
  ```
## Android 
* CameraKit android SDK requires to use an AppCompat Theme for application, so make sure your application theme inherits an AppCompat theme.

* For example: in your `style.xml` define a new theme like this: 
```xml
<style name="AppTheme" parent="Theme.AppCompat.NoActionBar">
```
* and then in `AndroidManifest.xml` 
```xml
 <application
    ...
    android:theme="@style/AppTheme">
    ...
    ...
</application>
```
* Make sure in `build.gradle` under app module, the `minSdkVersion` version is `21`
```groovy
defaultConfig {
    minSdkVersion 21
}
```
* Make sure in `build.gradle` under android module, the minimum `kotlin_version` version is `1.8.10`
  ```
  ext.kotlin_version = '1.8.10'
  ```
## Demo

https://github.com/DevCrew-io/camerakit-flutter/assets/136708738/63eb485d-1998-43f1-90ae-64193fde262e


## Key Features

[Passing CameraKit's credentials in Flutter](#set-configuration)

[Access CameraKit in Flutter](#access-camerakit-in-flutter)

[Get List of lenses for given list of group ids](#get-group-lenses)

[Get media results](#get-media-results)

[Show list of lenses](#show-lens-list)

[Show camerakit's captured media](#show-media)



## Access Camerakit in Flutter
### Load all lenses
You can access camerakit by just calling openCameraKit function with only the list of groupIds to load all lenses of given groups.
You can hide or show close button on camerakit screen by setting isHideCloseButton to true or false respectively.
```dart
late final _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);
_cameraKitFlutterImpl.openCameraKit(
    groupIds: Constants.groupIdList,
    isHideCloseButton: false,
);
```
### Load single lens
You can access camerakit with single lens by just calling openCameraKitWithSingleLens function with the lensId and groupId of that lens.
You can hide or show close button on camerakit screen by setting isHideCloseButton to true or false respectively.
```dart
_cameraKitFlutterImpl.openCameraKitWithSingleLens(
    lensId: lensId!,
    groupId: groupId!,
    isHideCloseButton: false,
);
```
## Get group lenses

To get group lenses you need to pass concerned list of group ids to the function.

```dart
_cameraKitFlutterImpl.getGroupLenses(
    groupIds: Constants.groupIdList,
);
```

Implement the interface CameraKitFlutterEvents to overirde receivedLenses function.
you will get the List of Lens model.

```dart
class _MyAppState extends State<MyApp> implements CameraKitFlutterEvents {
    @override
    void receivedLenses(List<Lens> lensList) async {
        await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LensListView(lensList: lensList)));
    }
}
 ```

## Get media results
Call openCameraKit or openCameraKitWithSingleLens function to open Camerakit,
```dart
 _cameraKitFlutterImpl.openCameraKit(
    groupIds: Constants.groupIdList
);
```
```dart
 _cameraKitFlutterImpl.openCameraKitWithSingleLens(
    lensId: lensId!,
    groupId: groupId!
);
```
After capturing image or recording video you will get the results in onCameraKitResult method.

```dart
@override
void onCameraKitResult(Map<dynamic, dynamic> result) {
    setState(() {
        _filePath = result["path"] as String;
         _fileType = result["type"] as String;
    });
}
```
## Show media
Here is example to show the image taken by camerakit.
```dart
class MediaResultWidget extends StatefulWidget {
  final String filePath;
  final String fileType;

  const MediaResultWidget(
      {super.key, required this.filePath, required this.fileType});

  @override
  State<MediaResultWidget> createState() => _CameraResultWidgetState();
}

class _CameraResultWidgetState extends State<MediaResultWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.addListener(() {
      if (!_controller.value.isPlaying &&
          _controller.value.isInitialized &&
          (_controller.value.duration == _controller.value.position)) {
        //checking the duration and position every time
        setState(() {
          if (kDebugMode) {
            print(
                "*************** video paying  c o m p l e t e d *******************");
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CameraKit Result'),
        ),
        floatingActionButton: widget.filePath.isNotEmpty &&
                widget.fileType == "video"
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              )
            : Container(),
        body: widget.filePath.isNotEmpty
            ? widget.fileType == 'video'
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : widget.fileType == 'image'
                    ? Center( child: Image.file(File(widget.filePath)) )
                    : const Text("UnKnown File to show")
            : const Text("No File to show"));
  }
}
```
<img width="180" height="350" alt="2b" src="https://github.com/DevCrew-io/camerakit-flutter/assets/72248282/c2eea95f-aaa8-43f9-9982-8d51777fe870">


## Show lens list
Here is example to show list of lenses.
```dart
class LensListView extends StatefulWidget {
  final List<Lens> lensList;

  const LensListView({super.key, required this.lensList});

  @override
  State<LensListView> createState() => _LensListWidgetState();
}

class _LensListWidgetState extends State<LensListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lens List'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          widget.lensList.isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                      itemCount: widget.lensList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) => GestureDetector(
                        child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.network(
                                    widget.lensList[index].thumbnail?[0] ?? "",
                                    width: 70,
                                    height: 70,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    widget.lensList[index].name!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            ),
                        onTap: (){
                          final Map<String, dynamic> arguments = {
                            'lensId': widget.lensList[index].id ?? "",
                            'groupId': widget.lensList[index].groupId ?? ""
                          };
                          Navigator.of(context).pop(arguments);
                        },
                      )),
                )
              : Container()
        ],
      ),
    );
  }
}
```
<img width="180" height="350"  alt="1c" src="https://github.com/DevCrew-io/camerakit-flutter/assets/72248282/5eecc1e8-8d8a-4e3b-84f1-956038ebf0bc">


## Bugs and feature requests

Have a bug or a feature request? Please first search for existing and closed issues. If your problem
or idea is not addressed
yet, [please open a new issue](https://github.com/DevCrew-io/camerakit-flutter/issues/new).

## Author

[DevCrew I/O](https://devcrew.io/)
<h3 align=“left”>Connect with Us:</h3>
<p align="left">
<a href="https://devcrew.io" target="blank"><img align="center" src="https://devcrew.io/wp-content/uploads/2022/09/logo.svg" alt="devcrew.io" height="35" width="35" /></a>
<a href="https://www.linkedin.com/company/devcrew-io/mycompany/" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="mycompany" height="30" width="40" /></a>
<a href="https://github.com/DevCrew-io" target="blank"><img align="center" src="https://cdn-icons-png.flaticon.com/512/733/733553.png" alt="DevCrew-io" height="32" width="32" /></a>
</p>

## Contributing

Contributions, issues, and feature requests are welcome!

## Show your Support

Give a star if this project helped you.
