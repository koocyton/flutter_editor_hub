import 'package:flutter_editor_hub/editor_hub_widget.dart';

class EditorHubController {

  double bottomMargin = 0;

  int bottomAnimatedMilliseconds = 0;

  EditorHubController();

  late EditorHubWidgetState state;

  void setState(EditorHubWidgetState state) {
    this.state = state;
  }

  void kbSliding(double bm) {
    state.setState(() {
      bottomMargin = bm;
    });
  }

  void hideOptboard() {
    // 导航栏在底部
    if (bottomMargin==0) {

    }
    // 键盘弹出,导航栏在键盘上
    // 操作栏已显示(键盘未弹出,导航栏弹出)
    state.setState(() {
      bottomAnimatedMilliseconds = 200;
      bottomMargin = 0.00;
      Future.delayed(const Duration(milliseconds: 200), (){
        bottomAnimatedMilliseconds = 0;
        bottomMargin = 0.00;
      });
    });
  }

  void showOptboard(int idx) {
    // 导航栏在底部
    if (bottomMargin==0) {
      
    }
    // 键盘弹出,导航栏在键盘上
    // 操作栏已显示(键盘未弹出,导航栏弹出)
    state.setState(() {
      bottomAnimatedMilliseconds = 200;
      bottomMargin = 322.00;
      Future.delayed(const Duration(milliseconds: 200), (){
        bottomAnimatedMilliseconds = 0;
        bottomMargin = 322.00;
      });
    });
  }

  void hideNavbar() {
  }

}
