import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'text_receiver.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DictionaryScreen(),
    );
  }
}

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  @override
  void initState() {
    super.initState();
    loadSelectedText();
  }

  Future<void> showOverlay(String word, String meaning) async {
    bool granted = await FlutterOverlayWindow.isPermissionGranted();

    if (!granted) {
      await FlutterOverlayWindow.requestPermission();
    }

    await FlutterOverlayWindow.showOverlay(
      height: 200,
      width: 300,
      alignment: OverlayAlignment.topCenter,
      enableDrag: true,
      overlayTitle: "Dictionary",
      overlayContent: "$word: $meaning",
    );
  }

  void loadSelectedText() async {
    String? text = await TextReceiver.getSelectedText();

    if (text != null && text.isNotEmpty) {
      controller.text = text;

      String? result = await DBHelper.getMeaning(text);

      setState(() {
        meaning = result ?? "Word not found";
      });
    }
  }

  TextEditingController controller = TextEditingController();
  String meaning = "";

  void searchWord() async {
    String word = controller.text.toLowerCase();

    String? result = await DBHelper.getMeaning(word);

    setState(() {
      meaning = result ?? "Word not found";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // subtle dim background
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // WORD
              Text(
                controller.text,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              Divider(),

              SizedBox(height: 8),

              // MEANING
              Text(meaning, style: TextStyle(fontSize: 16, height: 1.4)),

              SizedBox(height: 16),

              // BUTTON ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text("Close"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
