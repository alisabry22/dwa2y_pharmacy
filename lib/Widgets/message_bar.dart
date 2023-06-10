import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import '../Controllers/localization_controller.dart';

class ChatMessageBar extends StatefulWidget {
  ChatMessageBar({
    super.key,
    this.micShown = true,
  
    this.onCameraPressed,
    required this.onsend,
    this.onLongpressed = false,
    this.onLongPress,
    this.onDismissed,
    this.onLongPressEnd,
    this.recordInSec,
    this.onHorizontalDrag,
    this.onTextChanged,
   required this.textEditingController,
  });
  final void Function(String) onsend;
  void Function(DismissDirection)? onDismissed;
  bool onLongpressed;
  void Function()? onLongPress;
  void Function()? onCameraPressed;
  Function(LongPressEndDetails)? onLongPressEnd;
  bool micShown;
  String? recordInSec;
  Function(DragEndDetails)? onHorizontalDrag;
  final TextEditingController textEditingController;
  void Function(String)? onTextChanged;

  @override
  State<ChatMessageBar> createState() => _ChatMessageBarState();
}

class _ChatMessageBarState extends State<ChatMessageBar>
    with TickerProviderStateMixin {
  late final AnimationController _controller ;
 late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInCirc,
  );
  GlobalKey _one=GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _controller =
      AnimationController(duration: const Duration(seconds: 1), vsync: this)
        ..repeat(reverse: true);

  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {

    final localeCont = Get.find<LanguageController>().locale.value;
    return ShowCaseWidget(
      builder:Builder(builder: (context) {
        return  Align(
        alignment: localeCont.languageCode == "ar"
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        child: Padding(
          padding: localeCont.languageCode == "ar"
              ? EdgeInsets.only(right: 3)
              : EdgeInsets.only(left: 3),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Stack(children: [
                  TextField(
                    controller:widget. textEditingController,
                    keyboardType: TextInputType.multiline,
                    onChanged:widget.onTextChanged,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      
                      suffixIcon: widget.onLongpressed
                          ? null
                          : InkWell(
                              onTap: widget.onCameraPressed,
                              child: Icon(
                                Icons.camera_alt,
                                color: Color(0xff4062BB),
                              )),
                      hintText: widget.onLongpressed
                          ? "Slide To Cancel".tr
                          : "Type your message here".tr,
                      hintMaxLines: 1,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      hintStyle: TextStyle(
                        fontSize: 16,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.black26,
                          width: 0.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.black26,
                          width: 0.2,
                        ),
                      ),
                    ),
                  ),
                  widget.recordInSec != null
                      ? Positioned(
                          bottom: 10,
                          right: localeCont.languageCode != "ar" ? 10 : null,
                          left: localeCont.languageCode == "ar" ? 10 : null,
                          child: Row(
                            children: [
                              FadeTransition(
                                  opacity: _animation,
                                  child: Icon(
                                    Icons.mic,
                                    color: Colors.red,
                                  )),
                              Text(
                                widget.recordInSec!,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ))
                      : Container(),
                ]),
              ),
              Expanded(
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0xff4062BB), shape: BoxShape.circle),
                    child: widget.micShown == true
                        ? Center(
                            child: GestureDetector(
                              onHorizontalDragEnd: widget.onHorizontalDrag,
                              onTap: () {
                                ShowCaseWidget.of(context).startShowCase([_one]);
                              },
                              onLongPress: widget.onLongPress,
                              onLongPressEnd: widget.onLongPressEnd,
                              child: Showcase(
                                    description: "Hold to record,release to send".tr,
                                key: _one,
                                child: Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: InkWell(
                              onTap:widget. textEditingController.value.text.isNotEmpty
                                  ? () {
                                      widget.onsend(widget. textEditingController.value.text);
                                      widget. textEditingController.clear();
                                      
                                    }
                                  : null,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          )),
              ),
            ],
          ),
        ),
      );
      },)
  
    );
  }
}
