import 'package:flutter/material.dart';
import 'package:piggycare/widgets/piggy.modal.widget.dart';

import 'piggy.button.dart';

class DoubleInformationModal extends StatefulWidget {
  @override
  _DoubleInformationModalState createState() => _DoubleInformationModalState();
}

class _DoubleInformationModalState extends State<DoubleInformationModal> {
  bool _isNotShownAgainChecked = false;

  @override
  Widget build(BuildContext context) {
    return PiggyModal(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '''A Duplázás lényege, hogy a szüleid által meghatározott feladatok közül egyet végezz el és ezért cserébe kapsz egy extra Piggy Érmét. Ezt bármelyik Malacperselyedbe belerakhatod. Ha feladatokat végzel el, akkor gyorsabban el fogod érni a megtakarítási céljaidat.''',
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
                  "Ne jelenjen meg többé ez az üzenet!",
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
          text: "Rendben",
        )
      ],
    );
  }
}
