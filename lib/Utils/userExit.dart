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

class Logout {
  String verification = "A54U8sd-*237aHTR";
  late String name;
  late String surname;
  late bool answer;

  String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now());

  Future<CustomMessage> userLogout(String userPass) async {
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
          return CustomMessage("$name $surname olarak çıkış yapıyorsunuz bunu onaylıyormusunuz ?", Colors.green, true);
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

  Future<CustomMessage> userVerificationLogout(String userPass) async {
    //Bu url değişecek
    var url = Uri.parse("https://security.kozmossinavmerkezi.com/take_data.php");
    var data = {
      "verification": verification,
      "password": userPass,
      "data_type": "logout",
      "quit_date": formattedDate,
    };
    Response response = await post(url, body: data);
    if (response.statusCode == 200) {
      String responseData = response.body;
      try {
        var userData = jsonDecode(responseData);
        answer = userData['answer'];
        print(userData);
        if (answer == true) {
          print("çıkış yapmayı onayladı");
          return CustomMessage("Bilinmeyen Bir Hata Oluştu Tekrar Deneyiniz", Colors.green, true);
        } else {
          print("çıkış yapmayı onaylamadı");
          return CustomMessage("Zaten Çıkış Yaptınız", Colors.red, false);
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
