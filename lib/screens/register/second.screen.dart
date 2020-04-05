// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:piggycare/localization/Localizations.dart';
// import 'package:piggycare/models/appState.dart';
// import 'package:piggycare/models/registration/registration.actions.dart';
// import 'package:piggycare/screens/register/third.screen.dart';
// import 'package:piggycare/widgets/piggy.button.dart';
// import 'package:piggycare/widgets/piggy.input.dart';

// @deprecated
// class SecondRegisterPage extends StatefulWidget {
//   SecondRegisterPage({Key key}) : super(key: key);

//   @override
//   _SecondRegisterPageState createState() => new _SecondRegisterPageState();
// }

// @deprecated
// class _SecondRegisterPageState extends State<SecondRegisterPage> {
//   TextEditingController textEditingController = new TextEditingController();

//   final _itemFormKey = new GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     var loc = PiggyLocalizations.of(context);
//     var store = StoreProvider.of<AppState>(context);
//     var isAlreadyRegistered = store.state.user.id != null;

//     return new Scaffold(
//       appBar: new AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           color: Colors.pink,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Form(
//         key: _itemFormKey,
//         child: new Center(
//           child: new ListView(
//             children: <Widget>[
//               !isAlreadyRegistered
//                   ? Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 14.0),
//                       child: new Text(
//                         loc.trans("welcome"),
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.headline6,
//                       ),
//                     )
//                   : Container(
//                       height: MediaQuery.of(context).size.height * 0.2,
//                     ),
//               !isAlreadyRegistered
//                   ? Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: new Text(
//                         loc.trans("3_easy_steps"),
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.headline2,
//                       ),
//                     )
//                   : Container(),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: new Text(
//                   loc.trans("register_saving_for"),
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.headline2,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 80.0),
//                 child: PiggyInput(
//                   hintText: loc.trans("your_wish_hint"),
//                   height: MediaQuery.of(context).size.height * 0.15,
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   textController: textEditingController,
//                   onErrorMessage: (error) {
//                     setState(() {});
//                   },
//                   onValidate: (value) {
//                     if (value.isEmpty) {
//                       return loc.trans("required_field");
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               PiggyButton(
//                   text: loc.trans("next_step"),
//                   onClick: () {
//                     if (_itemFormKey.currentState.validate()) {
//                       var action = SetItem(textEditingController.text);

//                       store.dispatch(action);
//                       Navigator.push(
//                           context,
//                           new MaterialPageRoute(
//                               builder: (context) => new ThirdRegisterPage()));
//                     }
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
