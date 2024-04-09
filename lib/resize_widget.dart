
import 'package:flutter/material.dart';

class ResizeWidget extends StatefulWidget {

  final Widget Function(double bottomMargin)? childBuild;

  final Widget? child;

  final Function(double bottomMargin)? onKbShowBegin;

  final Function(double bottomMargin)? onKbShowEnd;

  final Function(double bottomMargin)? onKbShowing;

  final Function(double bottomMargin)? onKbHideBegin;

  final Function(double bottomMargin)? onKbHideEnd;

  final Function(double bottomMargin)? onKbHiding;

  const ResizeWidget({
    // build child
    this.childBuild,
    this.child,
    // show
    this.onKbShowBegin,
    this.onKbShowing,
    this.onKbShowEnd,
    // hide
    this.onKbHideBegin,
    this.onKbHiding,
    this.onKbHideEnd,
    Key? key
  }) : super(key: key);

  @override
  State<ResizeWidget> createState() => ResizeWidgetState();
}

class ResizeWidgetState extends State<ResizeWidget> with WidgetsBindingObserver {

  double bottomMargin = 0;

  bool isKbHiding = false;

  bool isKbShowing = false;

  @override
  Widget build(BuildContext context) {
    if (widget.child!=null) {
      return widget.child!;
    }
    else if (widget.childBuild!=null) {
      return widget.childBuild!(bottomMargin);
    }
    return SizedBox();
  }

  @override
  void initState() {
    super.initState();
    // debugPrint(">>> initState");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 监听
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    double newBottomMargin = MediaQuery.of(context).viewInsets.bottom;
    // show begin
    if (newBottomMargin > 0 && bottomMargin == 0) {
      // debugPrint(">>> show begin ${newInsetsBottom} ${insetsBottom}");
      isKbHiding = false;
      isKbShowing = true;
      if (widget.onKbShowBegin!=null) {
        widget.onKbShowBegin!(0);
      }
    }
    // show end
    else if (newBottomMargin == bottomMargin && bottomMargin>0 && isKbShowing) {
      // debugPrint(">>> show end");
      isKbHiding = false;
      isKbShowing = false;
      if (widget.onKbShowEnd!=null) {
        widget.onKbShowEnd!(newBottomMargin);
      }
    }
    // hide begin
    else if (newBottomMargin == bottomMargin && bottomMargin>0 && !isKbHiding) {
      // debugPrint(">>> hide begin");
      isKbHiding = true;
      isKbShowing = false;
      if (widget.onKbHideBegin!=null) {
        widget.onKbHideBegin!(newBottomMargin);
      }
    }
    // hide end
    else if (newBottomMargin == 0 && bottomMargin > 0) {
      // debugPrint(">>> hide end ${newInsetsBottom} ${insetsBottom}");
      isKbHiding = false;
      isKbShowing = false;
      if (widget.onKbHideEnd!=null) {
        widget.onKbHideEnd!(0);
      }
    }
    // on showing
    else if (isKbShowing) {
      if (widget.onKbShowing!=null) {
        widget.onKbShowing!(newBottomMargin);
      }
    }
    // on hiding
    else if (isKbHiding) {
      if (widget.onKbHiding!=null) {
        widget.onKbHiding!(newBottomMargin);
      }
    }
    bottomMargin = newBottomMargin;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // if(mounted){
    //   setState(() {
    //   });
    // }
    // });
  }
}
