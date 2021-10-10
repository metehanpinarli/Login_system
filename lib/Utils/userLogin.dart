import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class CustomMessage {
  late String text;
  late Color colorName;
  late bool answer;
  late String formattedDate;

  CustomMessage(this.text, this.colorName, this.answer);
}

class Login {
  String verification = "A54U8sd-*237aHTR";
  late String name;
  late String surname;
  late bool answer;

  String formattedDate = DateFormat('yyyy-MM-dd kk:mm:s').format(DateTime.now());

  Future<CustomMessage> userLogin(String userPass) async {
    print(formattedDate);
    //Bu url değişecek
    var url = Uri.parse("https://security.kozmossinavmerkezi.com/take_data.php");
    var data = {
      "verification": verification,
      "password": userPass,
      "data_type": "user_info",
      "login_date": formattedDate,
    };
    Response response = await post(url, body: data);
    if (response.statusCode == 200) {
      String responseData = response.body;
      try {
        var userData = jsonDecode(responseData);
        answer = userData['answer'];
        if (answer == true) {
          name = userData['name'];
          surname = userData['surname'];
          return CustomMessage("$name $surname olarak giriş yapıyorsunuz bunu onaylıyormusunuz ?", Colors.green, true);
        } else {
          return CustomMessage("Bu şifreye sahip kullanıcı bulunamamaktadır lütfen tekrar deneyin", Colors.red, false);
        }
      } catch (e) {
        print("Hata!" + e.toString());
        return CustomMessage("Bilinmeyen Bir Hata Oluştu Tekrar Deneyiniz", Colors.red, false);
      }
    } else {
      print("Apiden veri gelmiyor");
      return CustomMessage("Bilinmeyen Bir Hata Oluştu Tekrar Deneyiniz", Colors.red, false);
    }
  }

  Future<CustomMessage> userVerificationLogin(String userPass) async {
    //Bu url değişecek
    var url = Uri.parse("https://security.kozmossinavmerkezi.com/take_data.php");
    var data = {
      "verification": verification,
      "password": userPass,
      "data_type": "login",
      "login_date": formattedDate,
    };
    Response response = await post(url, body: data);
    if (response.statusCode == 200) {
      String responseData = response.body;
      try {
        var userData = jsonDecode(responseData);
        answer = userData['answer'];
        if (answer == true) {
          print("giriş onayladı");
          return CustomMessage("başarılı", Colors.green, true);
        } else {
          print("girişi onaylamadı");
          return CustomMessage("Zaten Giriş Yaptınız", Colors.red, false);
        }
      } catch (e) {
        print("Hata!" + e.toString());
        return CustomMessage("Bilinmeyen Bir Hata Oluştu Tekrar Deneyiniz", Colors.red, false);
      }
    } else {
      print("Apiden veri gelmiyor");
      return CustomMessage("Bilinmeyen Bir Hata Oluştu Tekrar Deneyiniz", Colors.red, false);
    }
  }
}
