import 'dart:io';

import 'package:dart_ping/dart_ping.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:toolbox/core/utils.dart';
import 'package:toolbox/data/res/color.dart';
import 'package:toolbox/view/widget/input_field.dart';
import 'package:toolbox/view/widget/round_rect_card.dart';

class PingPage extends StatefulWidget {
  const PingPage({Key? key}) : super(key: key);

  @override
  _PingPageState createState() => _PingPageState();
}

class _PingPageState extends State<PingPage>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _textEditingController;
  Ping? _ping;
  late MediaQueryData _media;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '');
    if (Platform.isIOS) {
      DartPingIOS.register();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GestureDetector(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Column(children: [
              const SizedBox(height: 13),
              buildInput(context, _textEditingController, maxLines: 1),
              _buildControl(),
              RoundRectCard(ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: _media.size.height * 0.6,
                ),
              )),
            ])),
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      ),
    );
  }

  void doPing() {
    _ping = Ping(_textEditingController.text.trim());
    _ping!.stream.listen((event) {
      final resp = event.response.toString();
      if (resp == 'null') return;
      setState(() {});
    });
  }

  Widget _buildControl() {
    return SizedBox(
      height: 57,
      child: RoundRectCard(
        InkWell(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(primaryColor)),
                child: Row(
                  children: const [
                    Icon(Icons.stop),
                    SizedBox(
                      width: 7,
                    ),
                    Text('Stop')
                  ],
                ),
                onPressed: () {
                  if (_ping != null) _ping!.stop();
                },
              ),
              TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(primaryColor)),
                child: Row(
                  children: const [
                    Icon(Icons.play_arrow),
                    SizedBox(
                      width: 7,
                    ),
                    Text('Start')
                  ],
                ),
                onPressed: () {
                  try {
                    doPing();
                  } catch (e) {
                    showSnackBar(context, Text('Error: \n$e'));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}