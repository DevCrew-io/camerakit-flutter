import 'package:camerakit_flutter/lens_model.dart';
import 'package:flutter/material.dart';

class LensListWidget extends StatefulWidget {
  final List<LensModel> lensList;

  const LensListWidget({super.key, required this.lensList});

  @override
  State<LensListWidget> createState() => _LensListWidgetState();
}

class _LensListWidgetState extends State<LensListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title:  const Text('Lens List'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          widget.lensList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: widget.lensList.length,
                      itemBuilder: (context, index) => Row(
                            children: [Text(widget.lensList[index].name)],
                          )),
                )
              : Container()
        ],
      ),
    );
  }
}
