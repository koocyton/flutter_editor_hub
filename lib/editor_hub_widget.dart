import 'package:flutter/material.dart';
import 'package:flutter_editor_hub/editor_hub_controller.dart';
import 'package:flutter_editor_hub/keyboard_event_widget.dart';

class EditorHubWidget extends StatefulWidget {

  final EditorHubController controller;

  final Widget editorChild;

  final Widget navbarChild;

  final List<Widget> oprationChilren;

  const EditorHubWidget({
    required this.controller,
    required this.editorChild,
    required this.navbarChild,
    required this.oprationChilren,
    super.key
  });

  @override
  State<EditorHubWidget> createState() => EditorHubWidgetState();

}

class EditorHubWidgetState extends State<EditorHubWidget> {

  double bottomMargin = 0;

  int bottomAnimatedMilliseconds = 0;

  @override
  Widget build(BuildContext context) {
    return KeyboardEventWidget(
      onKbShowing: (bm){
        setState(() {
          bottomMargin = bm;
        });
      },
      onKbHiding: (bm){
        setState(() {
          bottomMargin = bm;
        });
      },
      child:Column(
        children:[
          Expanded(
            child: widget.editorChild
          ),
          widget.navbarChild,
          AnimatedContainer(
            duration: Duration(milliseconds: bottomAnimatedMilliseconds),
            height: bottomMargin,
            child: IndexedStack(
              alignment: Alignment.center,
              index: 0,
              children: widget.oprationChilren.map((e){
                return SingleChildScrollView(
                  child: e
                );
              }).toList()
            )
          )
        ]
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

}
