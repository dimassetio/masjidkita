import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mosq/screens/widgets/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import 'MKConstant.dart';

// ignore: must_be_immutable
class EditText extends StatefulWidget {
  var isPassword;
  var isSecure;
  var isEnabled;
  var fontSize;
  var textColor;
  var fontFamily;
  var text;
  var hint;
  var label;
  var maxLine;
  var isBordered;
  var isReadOnly;
  String? Function(String?)? validator;
  TextEditingController? mController;
  AutovalidateMode? autovalidateMode;
  List<TextInputFormatter>? inputFormatters;
  TextInputAction? textInputAction;
  TextInputType? keyboardType;
  Icon? icon;
  FocusNode? focus;
  TextAlign textAlign;

  VoidCallback? onPressed;

  EditText({
    var this.fontSize = textSizeNormal,
    var this.textColor = mkTextColorSecondary,
    var this.fontFamily = fontRegular,
    var this.isPassword = false,
    var this.hint = "",
    var this.isSecure = false,
    var this.isEnabled = true,
    var this.text = "",
    var this.mController,
    var this.maxLine = 1,
    var this.validator,
    var this.icon,
    var this.focus,
    var this.textAlign = TextAlign.start,
    var this.label,
    var this.inputFormatters,
    var this.keyboardType,
    var this.autovalidateMode = AutovalidateMode.onUserInteraction,
    var this.isBordered = false,
    var this.textInputAction = TextInputAction.next,
    var this.isReadOnly = false,
  });

  @override
  State<StatefulWidget> createState() {
    return EditTextState();
  }
}

class EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focus,
      textAlign: widget.textAlign,
      readOnly: widget.isReadOnly,
      enabled: widget.isEnabled,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      controller: widget.mController,
      obscureText: widget.isPassword,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLine,
      style: TextStyle(
          color: appStore.textPrimaryColor,
          fontSize: textSizeMedium,
          fontFamily: fontRegular),
      decoration: InputDecoration(
        icon: widget.icon,
        suffixIcon: widget.isSecure
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isPassword = !widget.isPassword;
                  });
                },
                child: new Icon(
                  widget.isPassword ? Icons.visibility : Icons.visibility_off,
                  color: appStore.iconColor,
                ),
              )
            : null,
        contentPadding: widget.isBordered ? EdgeInsets.all(12) : null,
        hintText: widget.hint,
        hintStyle: secondaryTextStyle(color: mkColorPrimaryDark),
        labelText: widget.label,
        labelStyle: secondaryTextStyle(color: mkColorPrimaryDark),
        enabledBorder: widget.isBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: mkViewColor, width: 0.0),
              )
            : null,
        errorBorder: widget.isBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: mkViewColor, width: 0.0),
              )
            : null,
        focusedBorder: widget.isBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: mkViewColor, width: 0.0),
              )
            : null,
      ),
    );
  }
}

TextFormField editTextStyle(var hintText, {isPassword = true}) {
  return TextFormField(
    obscureText: isPassword,
    inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
    style: primaryTextStyle(color: appStore.textPrimaryColor),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
      hintText: hintText,
      hintStyle: TextStyle(color: mkTextColorThird),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: mkViewColor, width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: mkViewColor, width: 0.0),
      ),
    ),
  );
}

class TopBar extends StatefulWidget {
  var titleName;

  TopBar({var this.titleName = ""});

  @override
  State<StatefulWidget> createState() {
    return TopBarState();
  }
}

class TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        color: appStore.appBarColor,
        child: Stack(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.keyboard_arrow_left, size: 45),
              onPressed: () {
                finish(context);
              },
            ),
            Center(
                child: text(widget.titleName,
                    textColor: appStore.textPrimaryColor,
                    fontSize: textSizeNormal,
                    fontFamily: fontBold))
          ],
        ),
      ),
    );
  }
}

class PinEntryTextField extends StatefulWidget {
  final String? lastPin;
  final int fields;
  final onSubmit;
  final fieldWidth;
  final fontSize;
  final isTextObscure;
  final showFieldAsBox;

  PinEntryTextField(
      {this.lastPin,
      this.fields: 4,
      this.onSubmit,
      this.fieldWidth: 40.0,
      this.fontSize: 20.0,
      this.isTextObscure: false,
      this.showFieldAsBox: false})
      : assert(fields > 0);

  @override
  State createState() {
    return PinEntryTextFieldState();
  }
}

class PinEntryTextFieldState extends State<PinEntryTextField> {
  late List<String?> _pin;
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  Widget textfields = Container();

  @override
  void initState() {
    super.initState();
    _pin = List<String?>.filled(widget.fields, null, growable: false);
    _focusNodes = List<FocusNode?>.filled(widget.fields, null, growable: false);
    _textControllers = List<TextEditingController?>.filled(widget.fields, null,
        growable: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        if (widget.lastPin != null) {
          for (var i = 0; i < widget.lastPin!.length; i++) {
            _pin[i] = widget.lastPin![i];
          }
        }
        textfields = generateTextFields(context);
      });
    });
  }

  @override
  void dispose() {
    _textControllers.forEach((TextEditingController? t) => t!.dispose());
    super.dispose();
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    if (_pin.first != null) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  void clearTextFields() {
    _textControllers.forEach(
        (TextEditingController? tEditController) => tEditController!.clear());
    _pin.clear();
  }

  Widget buildTextField(int i, BuildContext context) {
    if (_focusNodes[i] == null) {
      _focusNodes[i] = FocusNode();
    }
    if (_textControllers[i] == null) {
      _textControllers[i] = TextEditingController();
      if (widget.lastPin != null) {
        _textControllers[i]!.text = widget.lastPin![i];
      }
    }

    _focusNodes[i]!.addListener(() {
      if (_focusNodes[i]!.hasFocus) {}
    });

    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(right: 10.0),
      child: TextField(
        controller: _textControllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appStore.textPrimaryColor,
            fontFamily: fontMedium,
            fontSize: widget.fontSize),
        focusNode: _focusNodes[i],
        obscureText: widget.isTextObscure,
        decoration: InputDecoration(
          counterText: "",
          border: widget.showFieldAsBox
              ? OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 2.0, color: appStore.iconColor!),
                )
              : null,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: appStore.iconColor!),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: mkColorPrimary),
          ),
        ),
        onChanged: (String str) {
          setState(() {
            _pin[i] = str;
          });
          if (i + 1 != widget.fields) {
            _focusNodes[i]!.unfocus();
            if (_pin[i] == '') {
              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
            } else {
              FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
            }
          } else {
            _focusNodes[i]!.unfocus();
            if (_pin[i] == '') {
              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
            }
          }
          if (_pin.every((String? digit) => digit != null && digit != '')) {
            widget.onSubmit(_pin.join());
          }
        },
        onSubmitted: (String str) {
          if (_pin.every((String? digit) => digit != null && digit != '')) {
            widget.onSubmit(_pin.join());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return textfields;
  }
}

Text profile(var label) {
  return Text(label,
      style:
          TextStyle(color: mkColorPrimary, fontSize: 18, fontFamily: 'Medium'),
      textAlign: TextAlign.center);
}

Divider view() {
  return Divider(color: mk_view_color, height: 0.5);
}

Row profileText(var label, {var maxline = 1}) {
  return Row(
    children: <Widget>[
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
          child: text(label,
              fontSize: textSizeLargeMedium,
              textColor: appStore.textPrimaryColor,
              maxLine: maxline)),
    ],
  );
}

Row rowHeading(var label) {
  return Row(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Text(label,
            style: TextStyle(
                color: appStore.textPrimaryColor,
                fontSize: 18,
                fontFamily: 'Bold'),
            textAlign: TextAlign.left),
      ),
    ],
  );
}

// Widget checkbox(String title, bool? boolValue) {
//   return Row(
//     children: <Widget>[
//       Text(title),
//       Checkbox(
//         activeColor: mkColorPrimary,
//         value: boolValue,
//         onChanged: (bool? value) {
//           boolValue = value;
//         },
//       )
//     ],
//   );
// }

// // ignore: must_be_immutable
// class TopBar extends StatefulWidget {
//   var titleName;

//   TopBar({var this.titleName = ""});

//   @override
//   State<StatefulWidget> createState() {
//     return TopBarState();
//   }
// }

// class TopBarState extends State<TopBar> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: 60,
//         color: appStore.appBarColor,
//         child: Stack(
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.keyboard_arrow_left, size: 45),
//               onPressed: () {
//                 finish(context);
//               },
//             ),
//             Center(
//                 child: text(widget.titleName,
//                     textColor: appStore.textPrimaryColor,
//                     fontSize: textSizeNormal,
//                     fontFamily: fontBold))
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ignore: must_be_immutable
// class HorizontalTab extends StatefulWidget {
//   final List<String> images;
//   var currentIndexPage = 0;

//   HorizontalTab(this.images);

//   @override
//   State<StatefulWidget> createState() {
//     return HorizontalTabState();
//   }
// }

// class HorizontalTabState extends State<HorizontalTab> {
//   //final VoidCallback loadMore;

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     width = width - 40;
//     return Column(
//       children: <Widget>[
//         Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.width / 2,
//           // TODO Without NullSafety SnapList
//           /*child: SnapList(
//             padding: EdgeInsets.only(left: 16),
//             sizeProvider: (index, data) => cardSize,
//             separatorProvider: (index, data) => Size(12, 12),
//             positionUpdate: (int index) {
//               widget.currentIndexPage = index;
//             },
//             builder: (context, index, data) {
//               return ClipRRect(
//                 borderRadius: new BorderRadius.circular(12.0),
//                 child: Image.network(
//                   widget.images[index],
//                   fit: BoxFit.fill,
//                 ),
//               );
//             },
//             count: widget.images.length,
//           ),*/
//         ),
//         DotsIndicator(
//             dotsCount: 3,
//             position: widget.currentIndexPage,
//             decorator: DotsDecorator(
//               color: t5ViewColor,
//               activeColor: t5ColorPrimary,
//             ))
//       ],
//     );
//   }
// }

// Widget ring(String description) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: <Widget>[
//       Container(
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(150.0),
//           border: Border.all(
//             width: 16.0,
//             color: t5ColorPrimary,
//           ),
//         ),
//       ),
//       SizedBox(height: 16),
//       text(description,
//           textColor: appStore.textPrimaryColor,
//           fontSize: textSizeNormal,
//           fontFamily: fontSemibold,
//           isCentered: true,
//           maxLine: 2)
//     ],
//   );
// }

// Widget shareIcon(String iconPath) {
//   return Padding(
//     padding: const EdgeInsets.only(left: 20, right: 20),
//     child: Image.asset(iconPath, width: 28, height: 28, fit: BoxFit.fill),
//   );
// }

// class Slider extends StatelessWidget {
//   final String file;

//   Slider({Key? key, required this.file}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left: 16, right: 16, top: 16),
//       child: Card(
//         semanticContainer: true,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         elevation: 0,
//         margin: EdgeInsets.all(0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Image.asset(file, fit: BoxFit.fill),
//       ),
//     );
//   }
// }

// class PinEntryTextField extends StatefulWidget {
//   final String? lastPin;
//   final int fields;
//   final onSubmit;
//   final fieldWidth;
//   final fontSize;
//   final isTextObscure;
//   final showFieldAsBox;

//   PinEntryTextField(
//       {this.lastPin,
//       this.fields: 4,
//       this.onSubmit,
//       this.fieldWidth: 40.0,
//       this.fontSize: 20.0,
//       this.isTextObscure: false,
//       this.showFieldAsBox: false})
//       : assert(fields > 0);

//   @override
//   State createState() {
//     return PinEntryTextFieldState();
//   }
// }

// class PinEntryTextFieldState extends State<PinEntryTextField> {
//   late List<String?> _pin;
//   late List<FocusNode?> _focusNodes;
//   late List<TextEditingController?> _textControllers;

//   Widget textfields = Container();

//   @override
//   void initState() {
//     super.initState();
//     _pin = List<String?>.filled(widget.fields, null, growable: false);
//     _focusNodes = List<FocusNode?>.filled(widget.fields, null, growable: false);
//     _textControllers = List<TextEditingController?>.filled(widget.fields, null,
//         growable: false);
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       setState(() {
//         if (widget.lastPin != null) {
//           for (var i = 0; i < widget.lastPin!.length; i++) {
//             _pin[i] = widget.lastPin![i];
//           }
//         }
//         textfields = generateTextFields(context);
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _textControllers.forEach((TextEditingController? t) => t!.dispose());
//     super.dispose();
//   }

//   Widget generateTextFields(BuildContext context) {
//     List<Widget> textFields = List.generate(widget.fields, (int i) {
//       return buildTextField(i, context);
//     });

//     if (_pin.first != null) {
//       FocusScope.of(context).requestFocus(_focusNodes[0]);
//     }

//     return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         verticalDirection: VerticalDirection.down,
//         children: textFields);
//   }

//   void clearTextFields() {
//     _textControllers.forEach(
//         (TextEditingController? tEditController) => tEditController!.clear());
//     _pin.clear();
//   }

//   Widget buildTextField(int i, BuildContext context) {
//     if (_focusNodes[i] == null) {
//       _focusNodes[i] = FocusNode();
//     }
//     if (_textControllers[i] == null) {
//       _textControllers[i] = TextEditingController();
//       if (widget.lastPin != null) {
//         _textControllers[i]!.text = widget.lastPin![i];
//       }
//     }

//     _focusNodes[i]!.addListener(() {
//       if (_focusNodes[i]!.hasFocus) {}
//     });

//     return Container(
//       width: widget.fieldWidth,
//       margin: EdgeInsets.only(right: 10.0),
//       child: TextField(
//         controller: _textControllers[i],
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 1,
//         style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: appStore.textPrimaryColor,
//             fontFamily: fontMedium,
//             fontSize: widget.fontSize),
//         focusNode: _focusNodes[i],
//         obscureText: widget.isTextObscure,
//         decoration: InputDecoration(
//           counterText: "",
//           border: widget.showFieldAsBox
//               ? OutlineInputBorder(
//                   borderSide:
//                       BorderSide(width: 2.0, color: appStore.iconColor!),
//                 )
//               : null,
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: appStore.iconColor!),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: t5ColorPrimary),
//           ),
//         ),
//         onChanged: (String str) {
//           setState(() {
//             _pin[i] = str;
//           });
//           if (i + 1 != widget.fields) {
//             _focusNodes[i]!.unfocus();
//             if (_pin[i] == '') {
//               FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
//             } else {
//               FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
//             }
//           } else {
//             _focusNodes[i]!.unfocus();
//             if (_pin[i] == '') {
//               FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
//             }
//           }
//           if (_pin.every((String? digit) => digit != null && digit != '')) {
//             widget.onSubmit(_pin.join());
//           }
//         },
//         onSubmitted: (String str) {
//           if (_pin.every((String? digit) => digit != null && digit != '')) {
//             widget.onSubmit(_pin.join());
//           }
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return textfields;
//   }
// }

// Widget divider() {
//   return Divider(
//     height: 0.5,
//     color: t5ViewColor,
//   );
// }
