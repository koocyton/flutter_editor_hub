import 'package:flutter/material.dart';
import 'package:flutter_editor_hub/editor_hub_controller.dart';
import 'package:flutter_editor_hub/keyboard_event_widget.dart';

class EditorHubWidget extends StatefulWidget {

  final EditorHubController controller;

  final Widget editorChild;

  final Widget navbarChild;

  final List<Widget> panelChildren;

  const EditorHubWidget({
    required this.controller,
    required this.editorChild,
    required this.navbarChild,
    required this.panelChildren,
    super.key
  });

  @override
  State<EditorHubWidget> createState() => EditorHubWidgetState();

}

class EditorHubWidgetState extends State<EditorHubWidget> {

  @override
  Widget build(BuildContext context) {
    return KeyboardEventWidget(
      onKbHiding: (bm){
        widget.controller.keyboardHiding(bm);
      },
      onKbShowing: (bm){
        widget.controller.keyboardShowing(bm);
      },
      onKbHideEnd: (bm) {
        widget.controller.resetState();
      },
      onKbShowEnd: (bm) {
        widget.controller.resetState();
      },
      child: Column(
        children:[
          Expanded(
            child: widget.editorChild
          ),
          widget.navbarChild,
          slidePanelBar()
        ]
      )
    );
  }

  Widget slidePanelBar() {
    return AnimatedContainer(
        onEnd: (){
          widget.controller.panelSlideEnd();
        },
        duration: Duration(milliseconds: widget.controller.bottomAnimatedMilliseconds),
        height: widget.controller.panelBottomMargin,
        child: IndexedStack(
          alignment: Alignment.center,
          index: 0,
          children: widget.panelChildren.map((e){
            return SingleChildScrollView(
              child: e
            );
          }).toList()
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
    widget.controller.initHubState(this);
  }

  @override
  void setState(Function() fn) {
    super.setState((){
      fn();
    });
  }
}
