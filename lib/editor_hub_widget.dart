import 'package:flutter/material.dart';
import 'package:flutter_editor_hub/editor_hub_controller.dart';
import 'package:flutter_editor_hub/keyboard_event_widget.dart';

class EditorHubWidget extends StatefulWidget {

  final EditorHubController? controller;

  final Widget? navbarChild;

  final List<Widget>? optboardChildren;

  const EditorHubWidget({
    this.controller,
    this.navbarChild,
    this.optboardChildren,
    super.key
  });

  @override
  State<EditorHubWidget> createState() => EditorHubWidgetState();

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
    return const KeyboardEventWidget();
  }

}
