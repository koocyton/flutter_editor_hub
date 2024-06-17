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

  void keyboardSliding(double bm) {
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
