import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
