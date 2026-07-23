import 'package:flutter/material.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatbaseScreen extends StatefulWidget {
  const ChatbaseScreen({super.key});

  @override
  State<ChatbaseScreen> createState() => _ChatbaseScreenState();
}

class _ChatbaseScreenState extends State<ChatbaseScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(
        Uri.parse(
          'https://www.chatbase.co/chatbot-iframe/fbT7X9Ii3OkNpwolJhSaW',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: VetAppBar(title: 'Chat with AI',),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset > 0 ? 0 : 16),
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}