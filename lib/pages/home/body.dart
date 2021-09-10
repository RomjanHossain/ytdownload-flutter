import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ytdownload/pages/results/results.dart';
import 'package:ytdownload/utils/const.dart';
import 'package:ytdownload/widgets/mytextfield.dart';

/// most download page
class MyBody extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  final List<String> _myTitle = <String>[
    'Search Video',
    'Search Playlist',
    'Search Channel'
  ];
  String val = '';
  int _selectedindex = 0;

  /// hislks
  SearchTo _st = SearchTo.video;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: NeumorphicToggle(
            style: const NeumorphicToggleStyle(
              backgroundColor: Color(0xffFF0000),
            ),
            width: MediaQuery.of(context).size.width / 1.06,
            selectedIndex: _selectedindex,
            thumb: Center(
              child: Text(_myTitle[_selectedindex]),
            ),
            onChanged: (int index) {
              setState(() {
                _selectedindex = index;
                if (index == 1) {
                  _st = SearchTo.playlist;
                } else if (index == 2) {
                  _st = SearchTo.channel;
                } else {
                  _st = SearchTo.video;
                }
              });
            },
            children: <ToggleElement>[
              ToggleElement(
                background: Center(
                  child: Text(_myTitle[0]),
                ),
              ),
              ToggleElement(
                background: Center(
                  child: Text(_myTitle[1]),
                ),
              ),
              ToggleElement(
                background: Center(
                  child: Text(_myTitle[2]),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
              color: kprimaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NeuTextField(
                    label: 'Input text',
                    onChanged: (String value) {
                      setState(() {
                        val = value;
                      });
                    },
                    hintTxt: _myTitle[_selectedindex],
                  ),
                  SizedBox(
                    width: 170,
                    child: NeumorphicButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      style: const NeumorphicStyle(
                        color: kprimaryColor,
                        shadowDarkColor: Colors.black,
                        shadowLightColor: Colors.white,
                      ),
                      onPressed: () {
                        print('thi searchto ->$_st');
                        if (val.isNotEmpty) {
                          Navigator.push(
                              context,
                              animateTopage(
                                  ShowingResult(
                                    query: val,
                                    st: _st,
                                  ),
                                  Offset(krandomGen(), krandomGen())));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        /* crossAxisAlignment: CrossAxisAlignment.center, */
                        children: const <Widget>[
                          Icon(
                            Icons.search,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text('Search'),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        )
      ],
    );
  }
}
