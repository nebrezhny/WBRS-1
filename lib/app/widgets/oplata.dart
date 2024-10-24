import 'package:flutter/material.dart';

class OplataPage extends StatefulWidget {
  const OplataPage({super.key});

  @override
  State<OplataPage> createState() => _OplataPageState();
}

class _OplataPageState extends State<OplataPage> {
  @override
  Widget build(BuildContext context) {
    return  const Column(
      children: [
        Text('Виды оплат'),
        ElevatedButton(onPressed: null, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Оплата картой'),
            Icon(Icons.credit_card)
          ],
        )),
        ElevatedButton(onPressed: null, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Оплата наличными'),
            Icon(Icons.money)
          ],
        )),
        ElevatedButton(onPressed: null, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('QR-код оплатa'),
            Icon(Icons.qr_code)
          ],
        )),
      ]
    );
  }
}
