import 'package:flutter/material.dart';
import 'package:flutter_editor_hub/editor_hub_controller.dart';
import 'package:flutter_editor_hub/resize_widget.dart';

class EditorHubWidget extends StatefulWidget {

  final EditorHubController? controller;

  final Widget? navbarWidget;

  final List<Widget>? optboardWidgets;

  const EditorHubWidget({
    this.controller,
    this.navbarWidget,
    this.optboardWidgets,
    super.key
  });

  @override
  EditorHubWidgetState createState() => EditorHubWidgetState();

}

class EditorHubWidgetState extends State<EditorHubWidget> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResizeWidget();
  }

}
