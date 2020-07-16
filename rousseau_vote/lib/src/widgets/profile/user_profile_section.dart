import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rousseau_vote/src/l10n/rousseau_localizations.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection(this._titleKey, this._text);

  final String _titleKey;
  final String _text;

  @override
  Widget build(BuildContext context) {
    final String title = RousseauLocalizations.of(context).text(_titleKey);
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Card(
              child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(15),
                  child: Column(children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                    ),
                    Html(data: _text),
                  ]))),
        ]));
  }
}
