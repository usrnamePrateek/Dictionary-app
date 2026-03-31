import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OverlayScreen extends StatelessWidget {
  final String word;
  final String meaning;

  const OverlayScreen({required this.word, required this.meaning});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 100),
          padding: EdgeInsets.all(16),
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                word,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(meaning),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
