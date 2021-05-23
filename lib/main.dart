import 'package:avalant_exam/class/rotation_y.dart';
import 'package:avalant_exam/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'class/input_format.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        scaffoldBackgroundColor: bgColor,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  FocusNode _focusCvv = new FocusNode();
  FocusNode _focusCardNumb = new FocusNode();
  FocusNode _focusCardName = new FocusNode();
  FocusNode _focusExpire = new FocusNode();

  TextEditingController cvvTextController = new TextEditingController();
  TextEditingController cardNameTextController = new TextEditingController();
  TextEditingController cardNumbController = new TextEditingController();
  TextEditingController monthController = new TextEditingController();
  TextEditingController yearController = new TextEditingController();

  String month = 'MM', year = 'YY';
  List<String> arrCardNumber = [];
  List<String> arrCardName = [];
  DateTime dateNow = DateTime.now();
  List<String> cardLiftTimeArray = [];
  bool _isFlipped = false;
  bool _cardNumbIsFocus = false;
  bool _cardNameIsFocus = false;
  bool _expireIsFocus = false;

  AnimationController _animationController;

  String dropdownDateValue = '01';
  String dropdownYearValue = DateTime.now().year.toString();

  @override
  void initState() {
    _focusCvv.addListener(_onFocusCvvChange);

    _focusCardNumb.addListener(_onFocusCardNumbChange);
    _focusCardName.addListener(_onFocusCardNameChange);
    monthController.text = 'Month';
    yearController.text = 'Year';
    getYear();

    super.initState();
  }

  getYear() {
    // อายุบัตรเครดิตไม่เกิน 5 ปี
    for (int i = 0; i < 6; i++) {
      int year = dateNow.year + i;
      cardLiftTimeArray.add(year.toString());
      print(cardLiftTimeArray);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusCvv.dispose();
    _focusCardNumb.dispose();
    _focusCardName.dispose();
    _focusCardName.dispose();
    _focusExpire.dispose();

    super.dispose();
  }

  void _onFocusCvvChange() {
    setState(() {
      if (_focusCvv.hasFocus) {
        _isFlipped = true;
        _expireIsFocus = false;
      } else {
        _isFlipped = false;
      }
    });
  }

  void _onFocusCardNumbChange() {
    setState(() {
      if (_focusCardNumb.hasFocus) {
        _cardNumbIsFocus = true;
        _expireIsFocus = false;
      } else {
        _cardNumbIsFocus = false;
      }
    });
  }

  void _onFocusCardNameChange() {
    setState(() {
      if (_focusCardName.hasFocus) {
        _cardNameIsFocus = true;
        _expireIsFocus = false;
      } else {
        _cardNameIsFocus = false;
      }
    });
  }

  // void _onFocusExpire() {
  //   setState(() {
  //     _focusExpire.hasFocus ? _expireIsFocus = true : _expireIsFocus = false;
  //     print('eee $_expireIsFocus');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        _focusCvv.unfocus();
        _focusCardNumb.unfocus();
        _focusCardName.unfocus();
        // _focusExpire.unfocus();
        setState(() {
          _expireIsFocus = false;
        });
      },
      child: Container(color: Colors.transparent, child: _buildBody(context)),
    ));
  }

  _buildBody(context) {
    Size mediaSize = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        width: mediaSize.width * 0.3,
        height: mediaSize.width * 0.43,
        child: Stack(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white),
                width: mediaSize.width * 0.3,
                height: mediaSize.width * 0.3,
              ),
            ),
            Column(
              children: [
                //cardView
                _buildFlipAnimation(context),
                _formView(context),
                _buildButton(context)
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildFlipAnimation(context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      tween: Tween(begin: 0.0, end: _isFlipped ? 180.0 : 0.0),
      builder: (context, value, child) {
        Widget content = value >= 90 ? _backView(context) : _frontView(context);
        return RotationY(
          rotationY: value,
          child: RotationY(rotationY: value >= 90 ? 180 : 0, child: content),
        );
      },
    );
  }

  _frontView(context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(mediaSize.width * 0.01),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image(
                  image: NetworkImage(cardUrl),
                  width: mediaSize.width * 0.3 / 1.5,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: mediaSize.width * 0.3 * 2 / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: mediaSize.width * 0.015),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Image(
                                image: NetworkImage(chipUrl),
                                width: mediaSize.width * 0.3 / 10,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(right: mediaSize.width * 0.015),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Image(
                                image: NetworkImage(visaUrl),
                                width: mediaSize.width * 0.3 / 10,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: mediaSize.width * 0.015,
                            right: mediaSize.width * 0.015,
                            top: mediaSize.width * 0.015),
                        child: Container(
                            width: mediaSize.width * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    mediaSize.width * 0.002),
                                border: Border.all(
                                    color: _cardNumbIsFocus
                                        ? Colors.grey
                                        : Colors.transparent)),
                            child: Padding(
                                padding:
                                    EdgeInsets.all(mediaSize.width * 0.005),
                                child: numberView(context))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: mediaSize.width * 0.015,
                          right: mediaSize.width * 0.015,
                          top: mediaSize.width * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: mediaSize.width * 0.11,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      mediaSize.width * 0.002),
                                  border: Border.all(
                                      color: _cardNameIsFocus
                                          ? Colors.grey
                                          : Colors.transparent)),
                              child: Padding(
                                padding:
                                    EdgeInsets.all(mediaSize.width * 0.004),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Card  Holder',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: mediaSize.width * 0.008)),
                                    Text(
                                        cardNameTextController.text == ''
                                            ? 'AD SOYAT'
                                            : cardNameTextController.text,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: mediaSize.width * 0.01)),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      mediaSize.width * 0.002),
                                  border: Border.all(
                                      color: _expireIsFocus
                                          ? Colors.grey
                                          : Colors.transparent)),
                              child: Padding(
                                padding:
                                    EdgeInsets.all(mediaSize.width * 0.004),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Expires',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: mediaSize.width * 0.008)),
                                    Row(
                                      children: [
                                        Container(
                                            width: mediaSize.width * 0.02,
                                            child: _animateMonthYear(
                                                month, context)),
                                        Text('/',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    mediaSize.width * 0.01)),
                                        Container(
                                            width: mediaSize.width * 0.02,
                                            child: _animateMonthYear(
                                                year, context)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  numberView(context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Container(
        child: Row(children: [
          arrCardNumber.length > 0
              ? _animateLabel(arrCardNumber[0], context)
              : _animateLabel('#', context),
          arrCardNumber.length > 1
              ? _animateLabel(arrCardNumber[1], context)
              : _animateLabel('#', context),
          arrCardNumber.length > 2
              ? _animateLabel(arrCardNumber[2], context)
              : _animateLabel('#', context),
          arrCardNumber.length > 3
              ? _animateLabel(arrCardNumber[3], context)
              : _animateLabel('#', context),
        ]),
      ),
      Row(children: [
        arrCardNumber.length > 5
            ? _animateLabel(arrCardNumber[5], context)
            : _animateLabel('#', context),
        arrCardNumber.length > 6
            ? _animateLabel(arrCardNumber[6], context)
            : _animateLabel('#', context),
        arrCardNumber.length > 7
            ? _animateLabel(arrCardNumber[7], context)
            : _animateLabel('#', context),
        arrCardNumber.length > 8
            ? _animateLabel(arrCardNumber[8], context)
            : _animateLabel('#', context),
      ]),
      Row(children: [
        arrCardNumber.length > 10
            ? _animateLabel(arrCardNumber[10], context)
            : _animateLabel('#', context),
        arrCardNumber.length > 11
            ? _animateLabel(arrCardNumber[11], context)
            : _animateLabel('#', context),
        arrCardNumber.length > 12
            ? _animateLabel(arrCardNumber[12], context)
            : _animateLabel('#', context),
        arrCardNumber.length > 13
            ? _animateLabel(arrCardNumber[13], context)
            : _animateLabel('#', context),
      ]),
      Row(children: [
        arrCardNumber.length > 15
            ? _animateLabel(arrCardNumber[15], context)
            : _animateLabel('#', context),
        arrCardNumber.length > 16
            ? _animateLabel(arrCardNumber[16], context)
            : _animateLabel('#', context),
        arrCardNumber.length > 17
            ? _animateLabel(arrCardNumber[17], context)
            : _animateLabel('#', context),
        arrCardNumber.length > 18
            ? _animateLabel(arrCardNumber[18], context)
            : _animateLabel('#', context),
      ]),
    ]);
  }

  _animateLabel(String text, context) {
    Size mediaSize = MediaQuery.of(context).size;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 250),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          child: child,
          position: text == '#'
              ? Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset(0.0, 0.0))
                  .animate(animation)
              : Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset(0.0, 0.0))
                  .animate(animation),
        );
      },
      child: Text(
        text,
        key: ValueKey<String>(text),
        style: TextStyle(
          fontSize: mediaSize.width * 0.012,
          color: Colors.white,
        ),
      ),
    );
  }

  _animateMonthYear(String text, context) {
    Size mediaSize = MediaQuery.of(context).size;
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          child: child,
          position:
              Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                  .animate(animation),
        );
      },
      child: Text(
        text,
        key: ValueKey<String>(text),
        style: TextStyle(fontSize: mediaSize.width * 0.01, color: Colors.white),
      ),
    );
  }

  _formView(context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
          left: mediaSize.width * 0.02,
          right: mediaSize.width * 0.02,
          top: mediaSize.width * 0.02,
          bottom: mediaSize.width * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //card number
          Text('Card Number',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black, fontSize: mediaSize.width * 0.008)),
          Container(
            height: mediaSize.width * 0.03,
            child: TextField(
              onChanged: (str) {
                setState(() {
                  arrCardNumber = str.split("");
                  if (str.length > 0) {
                    print('arr $arrCardNumber');
                  }
                });
              },
              controller: cardNumbController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(19),
                FilteringTextInputFormatter.digitsOnly,
                InputFormatter()
              ],
              focusNode: _focusCardNumb,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 0.0),
                ),
              ),
            ),
          ),
          //card name
          Padding(
            padding: EdgeInsets.only(top: mediaSize.width * 0.012),
            child: Text('Card Name',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontSize: mediaSize.width * 0.008)),
          ),
          Container(
            height: mediaSize.width * 0.03,
            child: TextField(
              focusNode: _focusCardName,
              controller: cardNameTextController,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (str) {
                setState(() {
                  arrCardName = str.split("");
                  if (str.length > 0) {
                    print('arr $arrCardName');
                  }
                });
              },
            ),
          ),
          //expire date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //month
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: mediaSize.width * 0.006),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: mediaSize.width * 0.012),
                        child: Text('Expiration Date',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: mediaSize.width * 0.008)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(mediaSize.width * 0.003),
                          border: Border.all(color: Colors.grey),
                        ),
                        height: mediaSize.width * 0.03,
                        width: mediaSize.width * 0.1,
                        child: DropdownButton<String>(
                            underline: Container(),
                            value: dropdownDateValue,
                            isExpanded: true,
                            style: TextStyle(color: Colors.grey),
                            iconEnabledColor: Colors.black,
                            items: <String>[
                              '01',
                              '02',
                              '03',
                              '04',
                              '05',
                              '06',
                              '07',
                              '08',
                              '09',
                              '10',
                              '11',
                              '12'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    monthController.text,
                                    style: TextStyle(
                                        fontSize: mediaSize.width * 0.01,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                dropdownDateValue = value;
                                monthController.text = value;
                                month = value;
                              });
                            },
                            onTap: () {
                              setState(() {
                                _expireIsFocus = true;
                                _isFlipped = false;
                                _focusCvv.unfocus();
                                _focusCardNumb.unfocus();
                                _focusCardName.unfocus();
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              //year
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: mediaSize.width * 0.006,
                      right: mediaSize.width * 0.006),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: mediaSize.width * 0.012),
                        child: Text('',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: mediaSize.width * 0.008)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(mediaSize.width * 0.003),
                          border: Border.all(color: Colors.grey),
                        ),
                        height: mediaSize.width * 0.03,
                        width: mediaSize.width * 0.1,
                        child: DropdownButton<String>(
                            underline: Container(),
                            value: dropdownYearValue,
                            isExpanded: true,
                            style: TextStyle(color: Colors.grey),
                            iconEnabledColor: Colors.black,
                            items: cardLiftTimeArray
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    yearController.text,
                                    style: TextStyle(
                                        fontSize: mediaSize.width * 0.01,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                dropdownYearValue = value;
                                yearController.text = value;
                                year = value.substring(2);
                              });
                            },
                            onTap: () {
                              setState(() {
                                _focusCvv.unfocus();
                                _focusCardNumb.unfocus();
                                _focusCardName.unfocus();
                                _expireIsFocus = true;
                                _isFlipped = false;
                                _focusCvv.unfocus();
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              //cvv
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: mediaSize.width * 0.006),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: mediaSize.width * 0.012),
                        child: Text('cvv',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: mediaSize.width * 0.008)),
                      ),
                      Container(
                        height: mediaSize.width * 0.03,
                        child: TextField(
                          controller: cvvTextController,
                          focusNode: _focusCvv,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _backView(context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(mediaSize.width * 0.01),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: NetworkImage(cardUrl),
              width: mediaSize.width * 0.3 / 1.5,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mediaSize.width * 0.01),
              ),
              width: mediaSize.width * 0.3 * 2 / 3,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: mediaSize.width * 0.3,
                    height: mediaSize.height * 0.05,
                    color: Colors.black54,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: mediaSize.width * 0.015,
                        left: mediaSize.width * 0.015,
                        right: mediaSize.width * 0.015),
                    child: Text('cvv',
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white)),
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: mediaSize.width * 0.01,
                            right: mediaSize.width * 0.01),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(mediaSize.width * 0.002),
                            color: Colors.white,
                          ),
                          width: mediaSize.width * 0.3,
                          height: mediaSize.height * 0.04,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: mediaSize.width * 0.015,
                              right: mediaSize.width * 0.015),
                          child: Text(
                            cvvTextController.text,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: mediaSize.width * 0.01),
                          ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: mediaSize.width * 0.015,
                        right: mediaSize.width * 0.015),
                    child: Container(
                      child: Image(
                        image: NetworkImage(visaUrl),
                        width: mediaSize.width * 0.3 / 10,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildButton(context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
          left: mediaSize.width * 0.02,
          right: mediaSize.width * 0.02,
          top: mediaSize.width * 0.01),
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(
            mediaSize.width * 0.004,
          ),
        ),
        width: mediaSize.width * 0.3,
        height: mediaSize.width * 0.03,
        child: TextButton(
          onPressed: () {},
          child: Text('Submit',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white, fontSize: mediaSize.width * 0.01)),
        ),
      ),
    );
  }
}
