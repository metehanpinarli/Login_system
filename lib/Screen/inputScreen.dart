import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imza_app/Context_extention.dart';
import 'package:flutter/services.dart';
import 'package:imza_app/Utils/networkCheck.dart';
import 'package:imza_app/Utils/userLogin.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  var tfUserPass = TextEditingController();
  final player = AudioCache();
  late var pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.dstATop),
            image: AssetImage('assets/isco-logo.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Expanded(flex: 2, child: logo(context)),
                Spacer(),
                Expanded(flex: 1, child: loginText(context)),
                Expanded(flex: 1, child: textFieldButton(context)),
                Spacer(),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: context.dynamicWidth(0.3),
                    child: ElevatedButton(
                      onPressed: () async {
                        player.play("click.mp3");
                        FocusScope.of(context).unfocus();
                        final scaffold = ScaffoldMessenger.of(context);
                        scaffold.hideCurrentSnackBar();
                        setState(() {});
                        var resultNet = await network();
                        if (resultNet.netAnswer == true) {
                          String date = DateFormat('yyyy.MM.dd').format(DateTime.now());
                          String time = DateFormat('kk:mm').format(DateTime.now());
                          if (tfUserPass.text.isEmpty) {
                            nullValueSnackBar(scaffold);
                            tfUserPass.clear();
                          } else {
                            var result = await Login().userLogin(tfUserPass.text);
                            pass = tfUserPass.text;
                            if (result.answer == false) {
                              falseValueSnackBar(scaffold, result);
                              tfUserPass.clear();
                            } else {
                              trueValueSnackBar(scaffold, result, date, time);
                              tfUserPass.clear();
                            }
                          }
                        } else {
                          netAnswerFalseValueSnackBar(scaffold);
                        }
                      },
                      child: loginButtonText(context),
                      style: ElevatedButton.styleFrom(primary: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))), elevation: 5),
                    ),
                  ),
                ),
                Spacer(),
                iscoText(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text iscoText() {
    return Text(
      "Created BY IscoSoftware",
      style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 24)),
    );
  }

  Text loginButtonText(BuildContext context) {
    return Text(
      "Giriş",
      style: Theme.of(context).textTheme.headline5!.copyWith(
            color: Colors.white,
          ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> trueValueSnackBar(ScaffoldMessengerState scaffold, CustomMessage result, String date, String time) {
    return scaffold.showSnackBar(
      SnackBar(
        backgroundColor: result.colorName,
        content: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                result.text,
                style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: context.dynamicWidth(0.2),
                    height: context.dynamicHeight(0.1),
                    child: ElevatedButton(
                        onPressed: () async {
                          scaffold.hideCurrentSnackBar();
                          print(pass);
                          var userVerificationRest = await Login().userVerificationLogin(pass);
                          if (userVerificationRest.answer == true) {
                            player.play('okSong.mp3');
                            scaffold.showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Center(
                                    child: Text(
                                  "Geçiş Başarılı Tarih: $date Saat: $time",
                                  style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                )),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            player.play('noSong.wav');
                            scaffold.showSnackBar(
                              SnackBar(
                                backgroundColor: userVerificationRest.colorName,
                                content: Center(
                                    child: Text(
                                  userVerificationRest.text,
                                  style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                )),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Evet",
                          style: TextStyle(color: Colors.green, fontSize: 25),
                        )),
                  ),
                  SizedBox(
                    width: context.dynamicWidth(0.2),
                    height: context.dynamicHeight(0.1),
                    child: ElevatedButton(
                        onPressed: () {
                          scaffold.hideCurrentSnackBar();
                        },
                        child: Text(
                          "Hayır",
                          style: TextStyle(color: Colors.red, fontSize: 25),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
        duration: Duration(minutes: 1),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> falseValueSnackBar(ScaffoldMessengerState scaffold, CustomMessage result) {
    player.play('noSong.wav');
    return scaffold.showSnackBar(
      SnackBar(
        backgroundColor: result.colorName,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(result.text),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> netAnswerFalseValueSnackBar(ScaffoldMessengerState scaffold) {
    player.play('noSong.wav');
    return scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Lütfen İnternete Bağlanıp Tekrar Deneyiniz"),
          ],
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> nullValueSnackBar(ScaffoldMessengerState scaffold) {
    player.play('noSong.wav');
    return scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Lütfen Şifre Giriniz"),
          ],
        ),
      ),
    );
  }

  SizedBox textFieldButton(BuildContext context) {
    return SizedBox(
      width: context.dynamicWidth(0.3),
      child: ElevatedButton(
        onPressed: () {},
        child: TextField(
          cursorColor: Colors.black,
          controller: tfUserPass,
          autofocus: true,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: 'Şifre',
            hintStyle: TextStyle(fontSize: 20),
            contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))), elevation: 5),
      ),
    );
  }

  Text loginText(BuildContext context) {
    return Text(
      "Giriş Yapmak İçin Lütfen Şifrenizi Giriniz",
      style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Image logo(BuildContext context) {
    return Image.asset(
      'assets/kozmos-logo.png',
      height: context.dynamicHeight(0.2),
      scale: 0.5,
    );
  }
}
