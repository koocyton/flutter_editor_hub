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
              fontWeight: FontWeight.normal,
              fontSize: 16
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
    String mdStr = '''
Hi, this is a test of markdown_quill.

| Syntax      | Description | Test Text     |
| :---        |    :----:   |          ---: |
| Header      | Title       | Here's this   |
| Paragraph   | Text        | And more      |

# H1
ok
# H2
# H3
done
# H4
''';

    // Configure the markdown parser
    final mdDocument = md.Document(
      encodeHtml: false,
      extensionSet: md.ExtensionSet.gitHubFlavored,

      // you can add custom syntax.
      blockSyntaxes: [const EmbeddableTableSyntax()],
    );

    final mdToDelta = MarkdownToDelta(
      markdownDocument: mdDocument,

      // you can add custom attributes based on tags
      customElementToBlockAttribute: {
        'h4': (element) => [HeaderAttribute(level: 4)],
      },
      // custom embed
      customElementToEmbeddable: {
        EmbeddableTable.tableType: EmbeddableTable.fromMdSyntax,
      },
    );


    // final mdDocument = md.Document(encodeHtml: false);
    // final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
    _controller.document = Document.fromDelta(mdToDelta.convert(mdStr));
  }
}
