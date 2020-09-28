import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralInstructionPage extends StatefulWidget {
  final List<Widget> children;

  const GeneralInstructionPage({Key key, this.children}) : super(key: key);

  @override
  _GeneralInstructionPageState createState() => _GeneralInstructionPageState();
}

class _GeneralInstructionPageState extends State<GeneralInstructionPage> {
  int pickedPage = 0;
  PageController controller = PageController();

  Widget pageIndicator(bool picked, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Container(
          width: 50,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: picked ? Colors.white : Color(0x80FFFFFF),
          ),
        ),
      ),
    );
  }

  List<Widget> buildIndicators() {
    final indicators = List.generate(
      widget.children.length,
      (i) => pageIndicator(
        pickedPage == i,
        () => controller.animateToPage(
          i,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
        ),
      ),
    );
    for (var i = 1; i < indicators.length; i += 2) {
      indicators.insert(i, SizedBox(width: 20));
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF4665EA),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/images/assets/instruction_background.png'),
              fit: BoxFit.cover,
            ),
            color: Color(0xFF4665EA),
          ),
          child: SafeArea(
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(right: 30, top: 30),
                    alignment: Alignment.centerRight,
                    child: Container(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                      padding: EdgeInsets.all(2),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFF6B84EE),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: PageView(
                    children: widget.children,
                    controller: controller,
                    onPageChanged: (i) => setState(() => pickedPage = i),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: buildIndicators(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
