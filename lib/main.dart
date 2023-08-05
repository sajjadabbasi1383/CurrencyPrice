import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'Model/Currency.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('fa')],
      //farsi
      theme: ThemeData(
        fontFamily: "dana",
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              fontFamily: 'dana',
              fontWeight: FontWeight.w800,
              fontSize: 17,
              color: Colors.black),
          bodyLarge: TextStyle(
              fontFamily: 'dana',
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.black),
          headlineMedium: TextStyle(
              fontFamily: 'dana',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.white),
          labelMedium: TextStyle(
              fontFamily: 'dana',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Colors.red),
          labelSmall: TextStyle(
              fontFamily: 'dana',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Colors.green),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse(BuildContext cntx) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";

    var value = await http.get(Uri.parse(url));
    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        // ignore: use_build_context_synchronously
        _showSnakBar(context, "اطلاعات با موفقیت بروزرسانی شد");
        List jsonList = convert.jsonDecode(value.body);

        if (jsonList.isNotEmpty) {
          for (int i = 0; jsonList.length > i; i++) {
            setState(() {
              currency.add(Currency(
                  id: jsonList[i]["id"],
                  title: jsonList[i]["title"],
                  price: jsonList[i]["price"],
                  changes: jsonList[i]["changes"],
                  status: jsonList[i]["status"]));
            });

          }
        }
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        actions: [
          const SizedBox(
            width: 7,
          ),
          Image.asset(
            "assets/images/money.png",
            width: 60,
            height: 60,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                "قیمت به روز ارز",
                style: Theme.of(context).textTheme.headlineLarge,
              )),
          const Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ))),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/info.png",
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    "نرخ ارز آزاد چیست؟",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "نرخ ارز ها در معاملات نقدی و رایج روزانه است. معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 130, 130, 130),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "نام ارز آزاد",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "قیمت",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "تغییر",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0,5,0,0),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2.3,
                  child: listFutureBuilder(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 13, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromARGB(255, 223, 223, 223)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 55,
                        child: TextButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 202, 193, 255)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)))),
                            onPressed: () async {
                              try {
                                final result =
                                    await InternetAddress.lookup('example.com');
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  currency.clear();
                                  listFutureBuilder(context);
                                }
                              } on SocketException catch (_) {
                                _showInternetSnakBar(context);
                              }
                            },
                            icon: const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 13, 0),
                              child: Icon(
                                CupertinoIcons.refresh_bold,
                                color: Colors.black,
                              ),
                            ),
                            label: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 2, 0),
                              child: Text(
                                "بروزرسانی",
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            )),
                      ),
                      Text("آخرین بروزرسانی  ${_getTime()}"),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext context, int position) {
                  return CurrencyItem(position, currency);
                },
                separatorBuilder: (BuildContext context, int index) {
                  if (index % 8 == 0) {
                    return const AdvertiseItem();
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
      future: getResponse(context),
    );
  }
}

String _getTime() {
  DateTime now = DateTime.now();
  return DateFormat("kk:mm:ss").format(now);
}

void _showSnakBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        action: SnackBarAction(
          label: 'بستن',
          onPressed: () {},
          disabledTextColor: Colors.black,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.green,
        content: Text(
          msg,
          style: Theme.of(context).textTheme.headlineLarge,
        )),
  );
}

void _showInternetSnakBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        action: SnackBarAction(
          label: 'بستن',
          onPressed: () {},
          disabledTextColor: Colors.black,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.red,
        content: Text(
          "اتصال به شبکه برقرار نشد",
          style: Theme.of(context).textTheme.headlineLarge,
        )),
  );
}

class CurrencyItem extends StatelessWidget {
  int position;
  List<Currency> currency;

  CurrencyItem(this.position, this.currency, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 2),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  currency[position].title!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  getFarsiNumber(currency[position].price.toString()),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  getFarsiNumber(currency[position].changes.toString()),
                  style: currency[position].status == "n"
                      ? Theme.of(context).textTheme.labelMedium
                      : Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdvertiseItem extends StatelessWidget {
  const AdvertiseItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 2),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
            )
          ],
          color: Colors.deepOrangeAccent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            "تبلیغات",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}

String getFarsiNumber(String number) {
  const en = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  const fa = ["۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹"];

  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });

  return number;
}
