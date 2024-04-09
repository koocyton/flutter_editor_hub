import 'package:flutter/material.dart';
import 'package:flutter_editor_hub/editor_hub_controller.dart';
import 'package:flutter_editor_hub/editor_hub_widget.dart';

class EditorDemoPage extends StatefulWidget {

  const EditorDemoPage({
    super.key
  });

  @override
  State<EditorDemoPage> createState() => EditorDemoPageState();

}

class EditorDemoPageState extends State<EditorDemoPage> {

  final EditorHubController? ehController = const EditorHubController();
  late double viewWidth;
  late double viewHeight;

  @override
  Widget build(BuildContext context) {
    Size viewSize = MediaQueryData.fromView(View.of(context)).size;
    viewWidth  = viewSize.width;
    viewHeight = viewSize.height;

    return EditorHubWidget(
      controller: ehController,
      navbarChild: navbar(),
      optboardChildren: optboards(),
    );
  }

  Widget navbar() {
    return Container(
      height:100,
      width: viewWidth,
      child: Row(
        children: [],
      ),
    );
  }

  List<Widget> optboards() {
    return [];
  }

}
