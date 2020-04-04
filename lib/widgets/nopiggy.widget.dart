import 'package:flutter/material.dart';
import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/widgets/piggy.button.dart';

class NoPiggyWidget extends StatefulWidget {
  NoPiggyWidget({Key key, this.navigateToCreateWidget, @required this.type})
      : super(key: key);

  final Function navigateToCreateWidget;
  final UserType type;
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
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
            new Text(
              loc.trans("if_you_dont_have"),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            new Text(
              loc.trans("lets_start"),
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1.2,
              height: MediaQuery.of(context).size.height * 0.25,
              child: widget.type == UserType.donator
                  ? Image.asset('assets/images/create_child.png')
                  : Image.asset('assets/images/adult_create.png'),
            ),
            PiggyButton(
              text: loc.trans('create_money_box'),
              onClick: () => _createPiggy(),
            ),
          ],
        ),
      ),
    );
  }
}
