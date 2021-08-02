import 'package:app_contatos/widgets/modal_top_decorator.dart';
import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  BottomSheetContainer({Key key, @required List<Widget> children, @required this.navigatorState, bottomWidget}) : super(key: key) {
    children.insert(0, ModalTopDecorator());
    this.children = children;
    this.bottomWidget = bottomWidget ?? SizedBox();
  }

  List<Widget> children;
  Widget bottomWidget;
  NavigatorState navigatorState;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .85,
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
