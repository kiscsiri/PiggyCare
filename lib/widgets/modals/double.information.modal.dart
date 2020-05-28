import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.modal.widget.dart';

class DoubleInformationModal extends StatefulWidget {
  @override
  _DoubleInformationModalState createState() => _DoubleInformationModalState();
}

class _DoubleInformationModalState extends State<DoubleInformationModal> {
  bool _isNotShownAgainChecked = false;

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return PiggyModal(
      vPadding: 0.0,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loc.trans('double_information'),
            textAlign: TextAlign.center,
          ),
          Row(
            children: <Widget>[
              Checkbox(
                value: _isNotShownAgainChecked,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(() {
                    _isNotShownAgainChecked = value;
                  });
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  loc.trans('dont_show_again'),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              )
            ],
          )
        ],
      ),
      actions: <Widget>[
        PiggyButton(
          onClick: () => Navigator.of(context).pop(_isNotShownAgainChecked),
          text: loc.trans('sure').toUpperCase(),
        )
      ],
    );
  }
}
