import 'package:flutter_editor_hub/editor_hub_widget.dart';

class EditorHubController {

  double keyboradBottomMargin = 0;

  double panelBottomMargin = 0;

  bool disableKeyboard = false;

  int bottomAnimatedMilliseconds = 0;

  final double maxPanelBottomMargin = 300;

  EditorHubController();

  late EditorHubWidgetState hubState;

  void initHubState(EditorHubWidgetState state) {
    hubState = state;
  }

  void keyboardShowing(double bm) {
    if (panelBottomMargin<bm) {
      hubState.setState((){
        bottomAnimatedMilliseconds = 0;
        panelBottomMargin = bm;
      });
    }
    keyboradBottomMargin = bm;
  }

  void keyboardHiding(double bm) {
    if (panelBottomMargin>bm) {
      hubState.setState((){
        bottomAnimatedMilliseconds = 200;
        panelBottomMargin = bm;
      });
    }
    keyboradBottomMargin = bm;
  }

  void switchPanelBar(int idx) {
    statusDispatcher(
      onPanelHideKbHide:(){
        hubState.setState((){
          bottomAnimatedMilliseconds = 200;
          disableKeyboard = true;
          panelBottomMargin = maxPanelBottomMargin;
        });
      },
      onPanelShowKbHide:(){
      },
      onPanelHideKbShow:(){
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
}
