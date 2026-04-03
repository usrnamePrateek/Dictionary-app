import 'package:flutter/material.dart';
import 'api_service.dart';
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
      overlayTitle: "DictionaryOverlay",
      overlayContent: "$word: $meaning",
    );
  }

  String cleanWord(String word) {
    String cleanedWord = word.toLowerCase().trim().replaceAll(
      RegExp(r'[^a-z_]'),
      '',
    );

    return cleanedWord;
  } // remove punctuation

  void loadSelectedText() async {
    String? text = await TextReceiver.getSelectedText();

    if (text != null && text.isNotEmpty) {
      controller.text = text;

      setState(() {
        meaning = "Loading...";
      });

      String cleanedWord = cleanWord(text);
      List<String> meanings = await ApiService.getMeanings(cleanedWord);
      setState(() {
        meaning = meanings.isNotEmpty
            ? meanings
                  .take(3)
                  .join("\n\n") // limit to 3 meanings
            : "Word not found!!";
      });
    }
  }

  TextEditingController controller = TextEditingController();
  String meaning = "";

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
