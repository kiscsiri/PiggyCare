import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.modal.widget.dart';

class AutomaticShareAskModal extends StatefulWidget {
  AutomaticShareAskModal({Key key}) : super(key: key);

  @override
  _AutomaticShareAskModalState createState() => _AutomaticShareAskModalState();
}

class _AutomaticShareAskModalState extends State<AutomaticShareAskModal> {
  var _isAutomaticShare = false;

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return PiggyModal(
      title: Text(loc.trans('autmatic_share_ask')),
      actions: [
        PiggyButton(
          text: loc.trans('yes'),
          onClick: () => Navigator.of(context).pop(true),
        ),
        PiggyButton(
          text: loc.trans('no'),
          onClick: () => Navigator.of(context).pop(false),
        )
      ],
      content: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: <Widget>[
              Text(loc.trans('automatic_share_modal')),
            ],
          ),
        ),
      ),
    );
  }
}
