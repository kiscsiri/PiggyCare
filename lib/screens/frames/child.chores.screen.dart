import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggycare/dtos/donation.dto.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/widgets/piggy.widgets.export.dart';

class BusinessDonationsPage extends StatefulWidget {
  BusinessDonationsPage({Key key}) : super(key: key);

  @override
  _BusinessDonationsPageState createState() =>
      new _BusinessDonationsPageState();
}

class _BusinessDonationsPageState extends State<BusinessDonationsPage> {
  Widget _getFinishedChores(AppState state) {
    var loc = PiggyLocalizations.of(context);
    List<DonationDto> donations = [
      DonationDto(
          index: 1, senderName: "Ákos", price: 20, donatedDate: DateTime.now()),
      DonationDto(
          index: 2, senderName: "Bea", price: 36, donatedDate: DateTime.now()),
      DonationDto(
          index: 3, senderName: "Ottó", price: 10, donatedDate: DateTime.now()),
      DonationDto(
          index: 4,
          senderName: "Béla",
          price: 150,
          donatedDate: DateTime.now()),
      DonationDto(
          index: 5, senderName: "Ákos", price: 5, donatedDate: DateTime.now())
    ];

    // Ezt majd ha lesz model szinten is
    // state.user.chores
    //     .where((d) => d.finishedDate != null)
    //     .where((element) => element.isDone && element.isValidated)
    //     .toList();
    var result;

    donations.toList().sort((a, b) {
      return a.donatedDate.compareTo(b.donatedDate);
    });

    if (donations.length != 0) {
      result = donations
          .take(10)
          .map(
            (e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ChildSavingInputWidget(
                      index: e.index,
                      name: e.senderName,
                      price: e.price.toString(),
                    )
                  ],
                ),
              ],
            ),
          )
          .toList();
    } else {
      result = [Text(loc.trans('no_finished_task'))];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: result,
    );
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return ListView(children: <Widget>[
      Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: coinBackground(context),
            ),
          ],
        ),
        Container(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: new Text(loc.trans('donations'),
                    style: Theme.of(context).textTheme.headline3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                ),
                child: Center(
                  child: StoreConnector<AppState, AppState>(
                      converter: (store) => store.state,
                      builder: (context, state) => _getFinishedChores(state)),
                ),
              )
            ],
          )),
        ),
      ])
    ]);
  }
}
