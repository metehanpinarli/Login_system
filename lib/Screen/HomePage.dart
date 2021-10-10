import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:imza_app/Context_extention.dart';
import 'package:imza_app/Screen/exitScreen.dart';
import 'package:imza_app/Screen/inputScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    'assets/kozmos-logo.png',
                    height: context.dynamicHeight(0.2),
                    scale: 0.5,
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: context.dynamicWidth(0.3),
                    child: ElevatedButton(
                      onPressed: () {
                        player.play("click.mp3");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => InputScreen()));
                      },
                      child: Text(
                        "Giriş",
                        style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.green),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))), elevation: 5),
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: context.dynamicWidth(0.3),
                    child: ElevatedButton(
                      onPressed: () {
                        player.play("click.mp3");

                        Navigator.push(context, MaterialPageRoute(builder: (context) => ExitScreen()));
                      },
                      child: Text(
                        "Çıkış",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))), elevation: 5),
                    ),
                  ),
                ),
                Spacer(),
                // Expanded(
                //   flex: 1,
                //   child: SizedBox(
                //     width: context.dynamicWidth(0.3),
                //     child: ElevatedButton(
                //       onPressed: () {
                //         Navigator.push(context, MaterialPageRoute(builder: (context) => ReportingScreen()));
                //       },
                //       child: Text(
                //         "Raporlama",
                //         style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
                //       ),
                //       style: ElevatedButton.styleFrom(primary: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))), elevation: 7),
                //     ),
                //   ),
                // ),
                iscoText(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Text iscoText() {
  return Text(
    "Created BY IscoSoftware",
    style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 24)),
  );
}
