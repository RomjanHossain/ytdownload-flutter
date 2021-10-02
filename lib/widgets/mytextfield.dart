import 'package:flutter_neumorphic/flutter_neumorphic.dart';

///j lskjlsfdf
class NeuTextField extends StatefulWidget {
  /// sjlksdjflk

  const NeuTextField(
      {required this.label, required this.onChanged, required this.hintTxt});

  /// label
  final String label;

  /// label
  final String hintTxt;

  /// changing textfield
  final ValueChanged<String> onChanged;

  @override
  _NeuTextFieldState createState() => _NeuTextFieldState();
}

class _NeuTextFieldState extends State<NeuTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 10),
      style: NeumorphicStyle(
        color: const Color(0xffFF0000),
        depth: NeumorphicTheme.embossDepth(context),
        // boxShape: NeumorphicBoxShape.beveled(BorderRadius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      child: TextField(
        onChanged: widget.onChanged,
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: _controller,
        decoration: InputDecoration.collapsed(
            hintText: widget.hintTxt,
            hintStyle:NeumorphicTheme.currentTheme(context).textTheme.bodyText2,
            ),
      ),
    );
  }
}
