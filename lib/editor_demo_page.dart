import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_editor_hub/editor_hub_controller.dart';
import 'package:flutter_editor_hub/editor_hub_widget.dart';

class EditorDemoPage extends StatefulWidget {

  const EditorDemoPage({
    super.key
  });

  @override
  State<EditorDemoPage> createState() => EditorDemoPageState();

}

class EditorDemoPageState extends State<EditorDemoPage> {

  final EditorHubController ehController = EditorHubController();
  late double viewWidth;
  late double viewHeight;

  @override
  Widget build(BuildContext context) {
    Size viewSize = MediaQueryData.fromView(View.of(context)).size;
    viewWidth  = viewSize.width;
    viewHeight = viewSize.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Container(
          color:Colors.black38,
          height:45,
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
    return Container(
      width: viewWidth/2,
      alignment: Alignment.center,
      child: Row(
        children:[
          navbarItem(
            iconData: Icons.edit, 
            onPressed: (){
              SystemChannels.textInput.invokeMethod<void>('TextInput.show');
            }
          ),
          navbarItem(
            iconData: Icons.edit_off, 
            onPressed: (){
              SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
            }
          )
        ]
      )
    );
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
      Container(child:Text("a")),
      Container(child:Text("a")),
      Container(child:Text("a")),
      Container(child:Text("a"))
    ];
  }


  Widget navbarItem({IconData? iconData, Widget? child, Function? onPressed}) {
    return SizedBox(
      width: viewWidth / 4,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(Size.zero),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(
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
}
