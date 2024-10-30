import 'package:finegst_fe/widgets/popup_modal.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finegst_fe/widgets/popup_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // dotenv 초기화
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  bool isPopupVisible = true;
  List<PopupContent> popupData = [];
  final PopupService _popupService = PopupService();

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://kt-online.shop/'))
      ..setNavigationDelegate(NavigationDelegate())
      ..enableZoom(false);

    _loadPopupData();
  }

  Future<void> _loadPopupData() async {
    final contents = await _popupService.getPopupContents();
    if (mounted) {
      setState(() {
        popupData =
            contents.map((content) => PopupContent.fromJson(content)).toList();
      });
    }
    checkPopupStatus();
  }

  Future<void> checkPopupStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPopupDate = prefs.getString('lastPopupDate');

    if (lastPopupDate != null) {
      final lastDate = DateTime.parse(lastPopupDate);
      final now = DateTime.now();
      final difference = now.difference(lastDate);

      if (difference.inHours >= 24) {
        setState(() => isPopupVisible = true);
      }
    } else {
      setState(() => isPopupVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: WebViewWidget(controller: controller),
          ),
          if (isPopupVisible)
            PopupModal(
              isOpen: isPopupVisible,
              onClose: () => setState(() => isPopupVisible = false),
              data: popupData,
              // handleUri: {},
            ),
        ],
      ),
    );
  }
}
