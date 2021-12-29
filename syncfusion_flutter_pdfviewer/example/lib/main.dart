import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  List<TextLine>? textLineAll = [];
  PdfDocument? document;

  void _incrementCounter() async{
    document = PdfDocument(
        inputBytes: await _readDocumentData('gis_succinctly.pdf'));

    //Extracts the text line collection from the document
    textLineAll = PdfTextExtractor(document!).extractTextLines(startPageIndex: 2);

    // List<MatchedItem> textCollection = PdfTextExtractor(document).findText(
    //     ['So', 'So'],
    //     startPageIndex: 1,
    //     endPageIndex: 2,
    //     searchOption: TextSearchOption.caseSensitive);

    //Gets specific line from the collection
    // TextLine? line = textLineAll![1];

    //Gets bounds of the line
    // Rect bounds = line!.bounds;

    //Dispose the document.
    document!.dispose();
  }
  PdfViewerController pdfViewerController = PdfViewerController();
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    late PdfTextSearchResult _searchResult;



    @override
    void initState() {
      _searchResult = PdfTextSearchResult();
      pdfViewerController = PdfViewerController();

      super.initState();
    }

    OverlayEntry _overlayEntry;
    void _showContextMenu(BuildContext context,PdfTextSelectionChangedDetails details) {
      final OverlayState? _overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: details.globalSelectedRegion!.center.dy - 55,
          left: details.globalSelectedRegion!.bottomLeft.dx,
          child:
          RaisedButton(child: Text('Copy',style: TextStyle(fontSize: 17)),onPressed: (){
            Clipboard.setData(ClipboardData(text: details.selectedText));
            // _pdfViewerController.clearSelection();
          },color: Colors.red,elevation: 10,),
        ),
      );
      // _overlayState.insert(_overlayEntry);
    }

    late OverlayEntry overlayEntry ;
    bool flog;

    return Scaffold(
      appBar: AppBar(
        title: Text('Syncfusion Flutter PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.red,
            ),
            onPressed: () async {
              _searchResult = await pdfViewerController.searchText('exactly',
                  searchOption: TextSearchOption.caseSensitive);
              print(
                  'Total instance count: ${_searchResult.totalInstanceCount}');
              // _searchResult.clear();
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Stack(
          children: [
            Container(
                child: SfPdfViewer.asset("assets/pdf/gis_succinctly.pdf",
                  onTextSelectionChanged:
                      (PdfTextSelectionChangedDetails details) {

                    if (details.selectedText == null ) {
                      // _overlayEntry.remove();
                      // _overlayEntry = null;
                    } else if (details.selectedText != null ) {
                      _showContextMenu(context, details);
                    }
                  },
                  onSelectionText:(PdfSelectionTextDetails details){

                    // pdfViewerController.setTextLinesList(textLineAll);

                    for (int textLineIndex = 0; textLineIndex < textLineAll!.length; textLineIndex++) {
                      final TextLine? line = textLineAll![textLineIndex];
                      final List<TextWord> textWordCollection = line!.wordCollection;
                      for (int wordIndex = 0; wordIndex < textWordCollection.length; wordIndex++) {
                        final TextWord textWord = textWordCollection[wordIndex];

                        final Rect wordBounds = textWord.bounds;
                        if (details.offset != null && wordBounds.contains(details.offset! * details.heightPercentage!)) {
                          print("点击的文字是： " + textWord.text);
                          pdfViewerController.setTextInfomation('exactly',textWord.bounds,details.pageNum!);
                          pdfViewerController.setTextInfomationHighLight('exactly',line.bounds,2);
                          // setState(() {});
                          // pdfViewerController.setHighLightText(textWord);
                          var nowTime1 = DateTime.now();//获取当前时间
                          print("AAAA---paint font" +nowTime1.toString());
                        }
                      }
                    }
                    setState(() {
                      var nowTime1 = DateTime.now();//获取当前时间
                      print("AAAA---paint callback " +nowTime1.toString());
                      flog = true;});
                  },
                  controller: pdfViewerController,

                  // controller: _pdfViewerController,
                )),
                  ElevatedButton(
                    child: Text("点击高亮显示文字"),
                    onPressed: () async{

                      PdfDocument document = PdfDocument(inputBytes: await _readDocumentData('gis_succinctly.pdf'));
                      final List<TextLine> textLine = PdfTextExtractor(document).extractTextLines(startPageIndex: 2);
                      TextLine line = textLine[3];
                      Rect bounds = line.bounds;
                      String text = line.text;
                      print(text);
                      List<TextWord> textWordCollection = line.wordCollection;
                      document.dispose();
                      pdfViewerController.setTextInfomationHighLight('exactly',textLine[3].bounds,2);
                      pdfViewerController.setTextInfomation('exactly',textWordCollection[0].bounds,2);
                      Future.delayed(Duration(milliseconds: 500), () {
                        // pdfViewerController.setTextInfomationHighLight('exactly',textLine[4].bounds,2);
                        pdfViewerController.setTextInfomation('exactly',textWordCollection[1].bounds,2);
                        Future.delayed(Duration(milliseconds: 500), () {
                          pdfViewerController.setTextInfomation('exactly', textWordCollection[2].bounds,2);
                          Future.delayed(Duration(milliseconds: 500), () {
                            pdfViewerController.setTextInfomation('exactly', textWordCollection[3].bounds,2);
                            pdfViewerController.setTextInfomationHighLight('exactly',textLine[4].bounds,2);
                            Future.delayed(Duration(milliseconds: 500), () {
                              pdfViewerController.setTextInfomation('exactly', textWordCollection[4].bounds,2);
                            });
                          });
                        });
                      });
                      // _searchResult = await pdfViewerController.searchText('exactly',
                      //     searchOption: TextSearchOption.caseSensitive,);
                    },
                  ),
          ],
        ),



      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), );
  }

  void setHighLightText(){

  }
}
