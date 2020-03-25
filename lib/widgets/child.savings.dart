import 'package:flutter/material.dart';

import 'piggy.saving.types.dart';

class ChildSavingsWidget extends StatefulWidget {
  const ChildSavingsWidget({Key key, this.savingPerFeed}) : super(key: key);
  final int savingPerFeed;
  @override
  _ChildSavingsWidgetState createState() => _ChildSavingsWidgetState();
}

class _ChildSavingsWidgetState extends State<ChildSavingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SavingForWidget(
        savingPerFeed: widget.savingPerFeed,
      ),
    );
  }
}
