import 'package:camerakit_flutter/lens_model.dart';
import 'package:flutter/material.dart';

/// A widget for displaying a list of lenses.

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
                                  widget.lensList[index].thumbnail?[0] ??
                                      "",
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
