
import 'dart:async';
import 'dart:io';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Utils.dart';

class WebApp extends StatefulWidget {
  const WebApp({Key? key}) : super(key: key);

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp>   with WidgetsBindingObserver{


  double _progress = 0;
  late WebViewController controller;
  Future<bool> _onBackPressed() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    // Enable virtual display.

    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    _requestPermission();

    //setState(() {});
    WidgetsBinding.instance.addObserver(this);

  }
  Future<void> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      // Permission granted
    } else {
      // Permission denied
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Storage permission is required to save tasks!')),
      // );
    }
  }

  void launchPhone(String phoneNumber) async {
    try {
      String telUrl = 'tel:+916296937613';
      await launchUrl(Uri.parse(telUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
    }
  }
  _launchURL(String url) async {
    launchUrl(
      Uri.parse(
          "https://api.whatsapp.com/send/?phone=+4915144298733"),
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    double w =MediaQuery.of(context).size.width;
    double h =MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Align(alignment:Alignment.topCenter,child: LinearProgressIndicator(value: _progress/100,color: Color(0xff0071a8)!,minHeight: 4,)),
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: WebView(

                          onWebViewCreated: (thisController){
                            controller = thisController;
                          },
                          gestureNavigationEnabled:true,

                          navigationDelegate: (NavigationRequest request) async{
                            if (request.url.startsWith('https://api.whatsapp.com/send/? phone=916296937613&text&')) {
                              // Handle WhatsApp link
                              try {
                                await _launchURL('https://api.whatsapp.com/send/?phone=916296937613&text&type=phone_number&app_absent=0');
                                return NavigationDecision.prevent;
                              } catch (e) {
                                _launchURL(request.url);
                                // Fluttertoast.showToast(msg: e.toString());
                              }
                            }
                            else if(request.url.startsWith('https://t.me')){
                              await launchUrl(Uri.parse(request.url),mode: LaunchMode.externalApplication);
                              return NavigationDecision.prevent;
                            }
                            else if(request.url.startsWith('https://digitalsecuretrade.com//DIGITAL_SECURE_TRADE.pdf')){
                              await launchUrl(Uri.parse('https://digitalsecuretrade.com//DIGITAL_SECURE_TRADE.pdf'),mode:LaunchMode.externalApplication );
                              return NavigationDecision.prevent;

                            }
                            else if(request.url.startsWith('https://digitalsecuretrade.com//FAQ_Q&A.pdf')){
                              await launchUrl(Uri.parse('https://digitalsecuretrade.com//FAQ_Q&A.pdf'),mode:LaunchMode.externalApplication );
                              return NavigationDecision.prevent;
                            }
                            else if(request.url.contains('https://digitalsecuretrade.com/assets/')){
                              // if(await Permission.storage.request().isGranted){
                              //   await _saveNetworkImage(context,request.url);
                              // }
                              // else{
                              //   await _requestPermission().then((value) async{
                              //     if(await Permission.storage.request().isGranted){
                              //       await _saveNetworkImage(context,request.url);
                              //     }
                              //   });
                              // }
                              if(request.url.contains('.pdf')||request.url.contains('.doc')||request.url.contains('.docx')||request.url.contains('.odt')){
                                try{
                                  await launchUrl(Uri.parse(request.url),mode:LaunchMode.externalApplication );
                                }
                                catch(e){
                                  print(e.toString());
                                }
                              }
                             else {
                                await _saveNetworkMedia(context,request.url);
                              }

                              return NavigationDecision.prevent;
                            }
                            else if(request.url.contains('advertise@')){
                              await launchUrl(Uri.parse('mailto:advertise@digitalsecuretrade.com'),mode:LaunchMode.externalApplication );
                              return NavigationDecision.prevent;
                            }
                            else if(request.url.contains('support@digitalsecuretrade.com')){
                              await launchUrl(Uri.parse('mailto:support@digitalsecuretrade.com'),mode:LaunchMode.externalApplication );
                              return NavigationDecision.prevent;
                            }
                            else  {
                              try{return NavigationDecision.navigate;}
                              catch(e){print(e.toString());}
                            }
                            return NavigationDecision.navigate;
                          },
                          allowsInlineMediaPlayback: true,
                          initialUrl: "https://digitalsecuretrade.com/",
                          javascriptMode: JavascriptMode.unrestricted,
                          geolocationEnabled: false,//su
                          onProgress: (progress){
                            setState(() {_progress = double.parse(progress.toString());});
                          },
                          onWebResourceError: (error){}
                      )
                  )
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 6,right: 6),
                  child: Tooltip(
                    message: 'Refresh',
                    child: InkWell(
                        onTap: ()async{
                          try{await controller.reload();}
                          catch(e){}
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            text('Refresh', Color(0xff4e73de), FontWeight.w400,16),
                            SizedBox(width: 4,),
                            Icon(Icons.refresh,color: Color(0xff4e73de),size: 31,),
                          ],
                        )),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveNetworkMedia(BuildContext context, String mediaUrl) async {
    try {
      // Request storage permission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloading...'), duration: Duration(seconds: 10)),
      );
        String extension = p.extension(Uri.parse(mediaUrl).path);
        bool isVideo = ['.mp4', '.mov', '.avi', '.mkv'].contains(extension.toLowerCase());

        String filename = 'downloaded_media${extension}';

        var tempDir = await getTemporaryDirectory();
        String tempPath = p.join(tempDir.path, filename);

        var response = await Dio().download(mediaUrl, tempPath);

        if (response.statusCode == 200) {
          if (isVideo) {
            await GallerySaver.saveVideo(tempPath);
          } else {
            await GallerySaver.saveImage(tempPath);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded Successfully!')),
          );
        } else {
          throw Exception('Failed to download media');
        }
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Storage permission denied')),
      //   );
      // }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please try again!')),
      );
    }
  }
  // Future<void> _saveNetworkImage(BuildContext context, String imageUrl) async {
  //   try {
  //     // Request storage permission
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Downloading...'),duration: Duration(seconds: 5),),
  //     );
  //     // if (await Permission.storage.request().isGranted) {
  //       // Extract file extension from URL
  //       String extension = p.extension(Uri.parse(imageUrl).path);
  //
  //       // Generate a unique filename from the URL and extension
  //       String filename = 'downloaded_image${extension}';
  //
  //       // Download the image
  //       var response = await Dio().get(imageUrl, options: Options(responseType: ResponseType.bytes));
  //       final result = await ImageGallerySaver.saveImage(
  //         Uint8List.fromList(response.data),
  //         quality: 60,
  //         name: filename,
  //       );
  //
  //       // Show success message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Downloaded Successfully!')),
  //       );
  //     // } else {
  //     //   ScaffoldMessenger.of(context).showSnackBar(
  //     //     SnackBar(content: Text('Storage permission denied')),
  //     //   );
  //     // }
  //   } catch (e) {
  //     print('Error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Storage Permission Required!')),
  //     );
  //   }
  // }

}
