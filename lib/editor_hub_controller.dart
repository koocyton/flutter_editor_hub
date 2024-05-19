import 'package:flutter_editor_hub/editor_hub_widget.dart';

class EditorHubController {

  double bottomMargin = 0;

  int bottomAnimatedMilliseconds = 0;

  EditorHubController();

  late EditorHubWidgetState state;

  void setState(EditorHubWidgetState state) {
    this.state = state;
  }

  void hideOptboardAndKb(double bm) {
    state.setState(() {
      bottomAnimatedMilliseconds = 0;
      bottomMargin = bm;
    });
  }

  void hideOptboard() {
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
