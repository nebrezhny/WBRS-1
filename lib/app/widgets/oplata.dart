import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/widgets/robokassa_webview.dart';
import 'package:wbrs/app/widgets/widgets.dart';

class OplataPage extends StatefulWidget {
  final String sum;
  const OplataPage({super.key, required this.sum});

  @override
  State<OplataPage> createState() => _OplataPageState();
}

class _OplataPageState extends State<OplataPage> {

  @override
  void initState() {
    print('object');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(children: [
        const Text('Виды оплат', style: TextStyle(fontSize: 20, color: Colors.white),),
        PopScope(
          onPopInvokedWithResult: (value, result) {
            print(value);
            print(result);
          },
          child: ElevatedButton(
              onPressed: () async {
                int count = 0;
                firebaseFirestore.collection('transaction').get().then((value) {
                  count = value.docs.length;
                });
                await firebaseFirestore.collection('transaction').doc(count.toString()).set({
                  'id': count.toString(),
                  'sum': widget.sum,
                  'user_email': firebaseAuth.currentUser!.email,
                  'user_id': firebaseAuth.currentUser!.uid,
                  'time': DateTime.now().toString(),
                });
                String signature = md5.convert(utf8.encode('WBRS:${widget.sum}:$count:Grebat-kopat3102-')).toString();
                nextScreen(context, RobokassaWebview(sum: widget.sum,));

                // if(resp) {
                //   String signature_status = md5.convert(utf8.encode('WBRS:$count:Zhevat-kopat3103-')).toString();
                //   print(signature_status);
                //   Duration duration = const Duration(seconds: 5);
                //   http.Response res = http.Response('', 500);
                //   Timer(duration, () async {
                //     while(res.statusCode != 200) {
                //       await Future.delayed(const Duration(seconds: 1));
                //       res = await http.post(
                //         Uri.parse('https://auth.robokassa.ru/Merchant/WebService/Service.asmx/OpStateExt?MerchantLogin=WBRS&InvoiceID=$count&Signature=$signature_status'),
                //         headers: <String, String>{
                //           'Content-Type': 'application/json'
                //         },
                //       );
                //       print(XmlDocument.parse(res.body).findAllElements('Code').first.innerText);
                //     }
                //   });
                // }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Оплата СБП'), Icon(Icons.credit_card)],
              )),
        ),
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 300,
                      width: 300,
                      child: AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('QR-код для оплаты'),
                        content: Image.asset('assets/pay/qr.jpeg'),
                      ),
                    );
                  });
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('QR-код оплатa'), Icon(Icons.qr_code)],
            )),
      ]),
    );
  }
}
