import 'package:flutter/services.dart';
import 'package:flutter_editor_hub/editor_hub_widget.dart';

class EditorHubController {

  // 键盘的高度
  double keyboradBottomMargin = 0;

  // 操作面板的高度
  double panelBottomMargin = 0;

  // 禁止 panel 跟随 键盘滑入滑出
  bool disableFollowKeyboard = false;

  // disableKeyboard = false 时，panel 滑入滑出动画时长 0
  // disableKeyboard = true 时，panel 滑入滑出动画时长 200
  int bottomAnimatedMilliseconds = 0;

  // panel 最大高度
  final double maxPanelBottomMargin = 300;

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
          disableFollowKeyboard = true;
          panelBottomMargin = 0;
        });
      },
      // 面板 ✕ 键盘 ▤ -> 面板 ▤ 键盘 ━
      onPanelHideKbShow:(){
        hubState.setState((){
          disableFollowKeyboard = true;
        });
        hideTextInput();
      }
    );
  }

  void resetState() {
    hubState.setState((){
      disableFollowKeyboard = false;
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
    if (!disableFollowKeyboard && panelBottomMargin<bm) {
      hubState.setState((){
        bottomAnimatedMilliseconds = 0;
        panelBottomMargin = bm;
      });
    }
    keyboradBottomMargin = bm;
  }

  void keyboardHiding(double bm) {
    if (!disableFollowKeyboard && panelBottomMargin>bm) {
      hubState.setState((){
        bottomAnimatedMilliseconds = 0;
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
          bottomAnimatedMilliseconds = 130;
          disableFollowKeyboard = true;
          panelBottomMargin = maxPanelBottomMargin;
        });
      },
      // 面板 ▤ 键盘 ━ -> 面板 ━ 键盘 ━
      onPanelShowKbHide:(){
        hubState.setState((){
          bottomAnimatedMilliseconds = 130;
          disableFollowKeyboard = true;
          panelBottomMargin = 0;
        });
      },
      // 面板 ✕ 键盘 ▤ -> 面板 ▤ 键盘 ━
      onPanelHideKbShow:(){
        hubState.setState((){
          disableFollowKeyboard = true;
        });
        hideTextInput();
      }
    );
  }

  void statusDispatcher({Function? onPanelHideKbHide, Function? onPanelShowKbHide, Function? onPanelHideKbShow}) {
    // 导航栏在底部 -> 滑出导航栏，键盘不动
    if (panelBottomMargin<=0) {
      if (onPanelHideKbHide!=null) {
        onPanelHideKbHide();
      }
    }
    // 键盘弹出,导航栏在键盘上
    else if (panelBottomMargin>0 && keyboradBottomMargin>0) {
      if (onPanelShowKbHide!=null) {
        onPanelShowKbHide();
      }
    }
    // 操作栏已显示(键盘未弹出,导航栏弹出)
    else if (panelBottomMargin>0 && keyboradBottomMargin<=0) {
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
