import 'package:flutter/material.dart';
import 'package:flutter_editor_hub/editor_hub_controller.dart';
import 'package:flutter_editor_hub/editor_hub_widget.dart';
import 'package:flutter_editor_hub/scroll_util.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/markdown_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:markdown/markdown.dart' as md;


class EditorDemoPage extends StatefulWidget {

  const EditorDemoPage({
    super.key
  });

  @override
  State<EditorDemoPage> createState() => EditorDemoPageState();

}

class EditorDemoPageState extends State<EditorDemoPage> {

  QuillController _controller = QuillController.basic();

  final EditorHubController ehController = EditorHubController();
  late double viewWidth;
  late double viewHeight;

  @override
  Widget build(BuildContext context) {
    Size viewSize = MediaQueryData.fromView(View.of(context)).size;
    viewWidth  = viewSize.width;
    viewHeight = viewSize.height;
    debugPrint("$viewWidth $viewHeight");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Container(
          color:Colors.black38,
          height: 45,
          width: viewWidth,
        ),
        Container(
          color:Colors.white,
          height: viewHeight - 45,
          width: viewWidth,
          child: EditorHubWidget(
            controller: ehController,
            editorChild: editor(),
            navbarChild: navbar(),
            panelChildren: panels(),
          )
        )
      ]
    );
  }

  Widget editor() {
    return QuillEditor.basic(
      configurations: QuillEditorConfigurations(
        controller: _controller,
        scrollPhysics: const FastBouncingScrollPhysics(),
        customStyles: const DefaultStyles(
          paragraph: DefaultTextBlockStyle(
            TextStyle(
              color: Colors.black,
              fontWeight:
              FontWeight.w900,
              fontSize: 35
            ),
            VerticalSpacing(16, 0),
            VerticalSpacing(0, 0),
            null
          ),
        ),

        onImagePaste: (u){
          return Future.value("");
        },
        scrollable: true,
        autoFocus: false,
        expands: true,
        padding: const EdgeInsets.all(20),
        placeholder: "",
        editorKey: GlobalKey<EditorState>(),
        showCursor: true,
        floatingCursorDisabled: false,
        paintCursorAboveText: true,
        sharedConfigurations: const QuillSharedConfigurations(
          locale: Locale('de'),
        ),
      ),
    );
    // return Container(
    //   width: viewWidth/2,
    //   alignment: Alignment.center,
    //   child: Row(
    //     children:[
    //       navbarItem(
    //         iconData: Icons.edit, 
    //         onPressed: (){
    //           EditorHubController.showTextInput();
    //         }
    //       ),
    //       navbarItem(
    //         iconData: Icons.edit_off, 
    //         onPressed: (){
    //           EditorHubController.hideTextInput();
    //         }
    //       )
    //     ]
    //   )
    // );
  }

  Widget navbar() {
    return Container(
      color:Colors.green,
      height: 60,
      width: viewWidth,
      child: Row(
        children: [
          navbarItem(iconData: Icons.face, onPressed: (){
            ehController.switchPanelBar(0);
          }),
          navbarItem(iconData: Icons.face, onPressed: (){
            ehController.switchPanelBar(1);
          }),
          navbarItem(iconData: Icons.face, onPressed: (){
            ehController.switchPanelBar(2);
          }),
          navbarItem(iconData: Icons.face, onPressed: (){
            ehController.switchPanelBar(3);
          })
        ],
      )
    );
  }

  List<Widget> panels() {
    return [
      QuillToolbar .simple(
        configurations: QuillSimpleToolbarConfigurations(
          controller: _controller,
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('de'),
          ),
        ),
      ),
      const SizedBox(child: Text("1")),
      const SizedBox(child: Text("2")),
      const SizedBox(child: Text("3"))
    ];
  }


  Widget navbarItem({IconData? iconData, Widget? child, Function? onPressed}) {
    return SizedBox(
      width: viewWidth / 4,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStateProperty.all(Size.zero),
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            )
          ),
        ),
        onPressed: onPressed==null ? null : ()=>onPressed(),
        child: Icon(iconData, color: Colors.black54, size: 30)
      )
    );
  }

  @override
  void initState() {
    super.initState();
    final mdStr = '''# 你好

## 前言

> 有朋友在 flutter 下开发富文本编辑器，遇到一些问题
> 下面的代码也许能帮到你

### controller

```dart
import 'package:flutter/services.dart';
import 'package:flutter_editor_hub/editor_hub_widget.dart';

class EditorHubController {

  // 键盘的高度
  double keyboradBottomMargin = 0;

  // 操作面板的高度
  double panelBottomMargin = 0;

  // 禁止 panel 跟随 键盘滑入滑出
  bool isPanelFollowKeyboard = true;

  // disableKeyboard = false 时，panel 滑入滑出动画时长 0
  // disableKeyboard = true 时，panel 滑入滑出动画时长 200
  int bottomAnimatedMilliseconds = 0;

  // panel 最大高度
  final double maxPanelBottomMargin = 300;

  // panel index
  int panelIndex = 0;

  // 记录锚定的状态 (面板 ▤ 键盘 ━ 前一个状态)
  // 前一个是 面板 ━ 键盘 ━  0，操作 switchPanelBar -> 面板 ━ 键盘 ━
  // 前一个是 面板 ✕ 键盘 ▤ ，操作 switchPanelBar -> 面板 ✕ 键盘 ▤
  // 0 -> 面板 ━ 键盘 ━ 
  // 1 -> 面板 ▤ 键盘 ━ 
  // 2 -> 面板 ✕ 键盘 ▤ 
  int anchoredState = 0;

  EditorHubController();

  late EditorHubWidgetState hubState;

  void initHubState(EditorHubWidgetState state) {
    hubState = state;
  }

  bool popScopeCanPop() {
    // 面板 ━ 键盘 ━
    if (panelBottomMargin<=0 && keyboradBottomMargin<=0) {
      return true;
    }
    return false;
  }

  void popScopePopInvoked(bool didPop) {
    statusDispatcher(
      // 面板 ━ 键盘 ━ -> 面板 ▤ 键盘 ━
      onPanelHideKbHide:(){
        return;
      },
      // 面板 ▤ 键盘 ━ -> 面板 ━ 键盘 ━
      onPanelShowKbHide:(){
        hubState.setState((){
          bottomAnimatedMilliseconds = 130;
          isPanelFollowKeyboard = false;
          panelBottomMargin = 0;
        });
      },
      // 面板 ✕ 键盘 ▤ -> 面板 ▤ 键盘 ━
      onPanelHideKbShow:(){
        hubState.setState((){
          bottomAnimatedMilliseconds = 0;
          isPanelFollowKeyboard = true;
          hideTextInput();
        });
      }
    );
  }

  void resetState() {
    hubState.setState((){
      isPanelFollowKeyboard = true;
      bottomAnimatedMilliseconds = 0;
    });
  }

  void panelSlideEnd() {
    resetState();
  }

  void keyboardSlideEnd(double bm) {
    resetState();
  }

  void keyboardShowing(double bm) {
    if (isPanelFollowKeyboard && panelBottomMargin<bm) {
      hubState.setState((){
        panelBottomMargin = bm;
      });
    }
    keyboradBottomMargin = bm;
  }

  void keyboardHiding(double bm) {
    if (isPanelFollowKeyboard && panelBottomMargin>bm) {
      hubState.setState((){
        panelBottomMargin = bm;
      });
    }
    keyboradBottomMargin = bm;
  }

  void switchPanelBar(int idx) {
    statusDispatcher(
      // 面板 ━ 键盘 ━ -> 面板 ▤ 键盘 ━
      onPanelHideKbHide:(){
        hubState.setState((){
          panelIndex = idx;
          bottomAnimatedMilliseconds = 130;
          isPanelFollowKeyboard = false;
          panelBottomMargin = maxPanelBottomMargin;
          anchoredState = 0;
        });
      },
      // 面板 ▤ 键盘 ━ -> 面板 ━ 键盘 ━
      onPanelShowKbHide:(){
        hubState.setState((){
          // panel 切换
          if (idx!=panelIndex) {
            panelIndex = idx;
            return;
          }
          // 上一次状态是 面板 ━ 键盘 ━
          if (anchoredState==0) {
            bottomAnimatedMilliseconds = 130;
            isPanelFollowKeyboard = false;
            panelBottomMargin = 0;
          }
          // 上一次状态是 面板 ✕ 键盘 ▤
          else {
            panelIndex = idx;
            isPanelFollowKeyboard = false;
            anchoredState = -1;
            showTextInput();
          }
        });
      },
      // 面板 ✕ 键盘 ▤ -> 面板 ▤ 键盘 ━
      onPanelHideKbShow:(){
        hubState.setState((){
          panelIndex = idx;
          isPanelFollowKeyboard = false;
          anchoredState = 2;
        });
        hideTextInput();
      }
    );
  }

  void statusDispatcher({Function? onPanelHideKbHide, Function? onPanelShowKbHide, Function? onPanelHideKbShow}) {
    // 面板 ━ 键盘 ━
    if (panelBottomMargin<=0) {
      if (onPanelHideKbHide!=null) {
        onPanelHideKbHide();
      }
    }
    // 面板 ▤ 键盘 ━
    else if (keyboradBottomMargin<=0) { // && panelBottomMargin>0
      if (onPanelShowKbHide!=null) {
        onPanelShowKbHide();
      }
    }
    // 面板 ✕ 键盘 ▤
    else { // if (panelBottomMargin>0 && keyboradBottomMargin>0) {
      if (onPanelHideKbShow!=null) {
        onPanelHideKbShow();
      }
    }
  }

  static void showTextInput() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }

  static void hideTextInput() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
  }
}
```


### widget

```dart
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
    return PopScope(
      canPop: widget.controller.popScopeCanPop(),
      onPopInvoked: widget.controller.popScopePopInvoked,
      child: KeyboardEventWidget(
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
      )
    );
  }

  Widget slidePanelBar() {
    return AnimatedContainer(
        onEnd: (){
          Future.delayed(const Duration(milliseconds: 50), () {
            widget.controller.panelSlideEnd();
          });
        },
        duration: Duration(milliseconds: widget.controller.bottomAnimatedMilliseconds),
        height: widget.controller.panelBottomMargin,
        child: IndexedStack(
          alignment: Alignment.center,
          index: widget.controller.panelIndex,
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
  void setState(Function fn) {
    if (mounted) {
      super.setState((){
        fn();
      });
    }
  }
}
```

''';
    final mdDocument = md.Document(encodeHtml: false);
    final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
    _controller.document = Document.fromDelta(mdToDelta.convert(mdStr));
  }
}
