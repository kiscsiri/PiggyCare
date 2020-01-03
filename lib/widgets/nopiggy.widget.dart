import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/widgets/piggy.button.dart';

class NoPiggyWidget extends StatefulWidget {
  NoPiggyWidget({Key key, this.navigateToCreateWidget}) : super(key: key);

  final Function navigateToCreateWidget;

  @override
  _NoPiggyWidgetState createState() => new _NoPiggyWidgetState();
}

class _NoPiggyWidgetState extends State<NoPiggyWidget> {
  _createPiggy() {
    widget.navigateToCreateWidget();
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 52.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(
              loc.trans("welcome_on_board"),
              style: Theme.of(context).textTheme.display3,
              textAlign: TextAlign.center,
            ),
            new Text(
              loc.trans("if_you_dont_have"),
              textAlign: TextAlign.center,
            ),
            new Text(
              loc.trans("you_can_create"),
              textAlign: TextAlign.center,
            ),
            new Text(
              loc.trans("lets_start"),
              style: Theme.of(context).textTheme.display4,
              textAlign: TextAlign.center,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.25,
              color: Theme.of(context).primaryColor,
            ),
            PiggyButton(
              text: "Create money box",
              onClick: () => _createPiggy(),
            ),
          ],
        ),
      ),
    );
  }
}
