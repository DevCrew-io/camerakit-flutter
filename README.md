# camerakit-flutter

[![license](https://img.shields.io/badge/license-MIT-green)](https://github.com/DevCrew-io/expandable-richtext/blob/main/LICENSE)
![](https://img.shields.io/badge/Code-Dart-informational?style=flat&logo=dart&color=29B1EE)
![](https://img.shields.io/badge/Code-Flutter-informational?style=flat&logo=flutter&color=0C459C)

An open-source SDK package for Flutter that provides developers with seamless integration and access to Snapchat's CameraKit features within their Flutter applications. Flutter developer now can access set configuration from Flutter for both platforms (ios and android), you can open camera kit , get media results and get list of lenses against group ids.

## Installation
First, add image_editor_plus: as a dependency in your pubspec.yaml file.

```dart
import 'package:fhoto_editor/fhoto_editor.dart';
```
Then run ```flutter pub get``` to install the package.
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
## Demo

https://github.com/DevCrew-io/camerakit-flutter/assets/72248282/062ba5cb-553f-43da-8058-9b5d0e53d68b

## Key Features

[Passing credentials from Flutter](#set-configuration)

[Access Camerakit from Flutter](#access-camerakit-from-flutter)

[Get List of lenses for given list of group ids](#get-group-lenses)

[Get media results](#get-media-results)

[Example to show lens list](#example-show-lens-list)

[Example to show camerakit captured media](#example-show-media)



# Set Configuration

Configuration class is used to pass all credentials required for Camerakit. you can pass list of Group ids to show all group lenses. you don't need to set separate credentials for iOS and android.

```dart

final config = Configuration(
      Constants.cameraKitAppId,
      Constants.groupIdList,
      Constants.cameraKitApiTokenStaging,
      Constants.cameraKitLensId,
    );
    _cameraKitFlutterImpl.setCredentials(config);
```
# Access Camerakit from Flutter
You can access camerakit by just calling openCameraKit function. Before calling you need and instance of CameraKitFlutterImpl to get required function
```dart
  late final _cameraKitFlutterImpl =
      CameraKitFlutterImpl(cameraKitFlutterEvents: this);
  await _cameraKitFlutterImpl.openCameraKit();
```
# Get group lenses

to get group lenses you need to pass concerned list of group ids to the function.

```dart

 _cameraKitFlutterImpl.getGroupLenses(Constants.groupIdList);

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

# Get media results
call openCamerakit function to open Camerakit,
```dart
  await _cameraKitFlutterImpl.openCameraKit();
```
After capturing image or recording video you will get the results in onCameraKitResult method

```dart
  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    setState(() {
      _filePath = result["path"] as String;
      _fileType = result["type"] as String;
    });
  }
```
# Example show media
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
          print(
              "*************** video paying  c o m p l e t e d *******************");
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
            ? Image.file(File(widget.filePath))
            : const Text("UnKnown File to show")
            : const Text("No File to show"));
  }
}


```
# Example show lens list
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
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(2.0),
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
                )),
          )
              : Container()
        ],
      ),
    );
  }
}

```
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

## Copyright & License

Code copyright 2023 DevCrew I/O. Code released under
the [MIT license](https://github.com/DevCrew-io/expandable-richtext/blob/main/LICENSE).