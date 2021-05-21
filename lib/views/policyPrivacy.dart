import 'package:delivery_ctpaga/views/navbar/navbar.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';


class PolicyPrivacy extends StatefulWidget {

  @override
  _PolicyPrivacyState createState() => _PolicyPrivacyState();
}

class _PolicyPrivacyState extends State<PolicyPrivacy> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Navbar("Política de Privacidad"),
          Expanded(
            child: Stack(
              children: <Widget>[
                WebView(
                  initialUrl: 'https://ctpaga.app/privacy/ctpaga',
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                Visibility(
                  visible: isLoading,
                  child: Center( 
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
                    ),
                  )
                )
              ],
            )
          ),
        ],
      ),
    );
  }

}