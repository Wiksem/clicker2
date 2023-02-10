import 'dart:async';
import 'dart:html';
import 'package:clicker2/model/game_result.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _bestPlayerName = "";
  var _clickCount = 0;
  var _isCounting = false;
  var _record = null;
  var _prenom = "";
  var _formkey = GlobalKey<FormState>();
  var _currentNameFieldController = TextEditingController();
  final List<GameResult> _resultList = [];

  _prenommodifie(value) {
    setState(() {
      _prenom = value;
    });
  }

  _startCounting() {
    setState(() {
      _clickCount = 0;
      _isCounting = true;
      Timer(Duration(seconds: 10), _stopGame);
    });
  }

  _ButtonClicked() {
    setState(() {
      _clickCount++;
    });
  }

  _stopGame() {
    setState(() {
      _isCounting = false;
      final result = GameResult(_prenom, _clickCount);
      _resultList.add(result);
      if (_record == null || _clickCount > _record) {
        _record = _clickCount;
        _bestPlayerName = _prenom;
      }
    });
  }

  _confirmerNouveauPrenom() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
    }
  }

  _currentNameChanged(String newUsername) {
    setState(() {
      _prenom = newUsername;
    });
  }

  Widget _makeRowForResult(BuildContext context, int rowNumber) {
    final result = _resultList[rowNumber];
    return Row(
      children: [
        Text(result.playerName),
        Icon(Icons.military_tech),
        Text("${result.score} points")
      ],
    );
  }

  @override
  void dispose() {
    _currentNameFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clicker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("kohi click test")),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isCounting == false)
                TextField(
                    decoration: InputDecoration(
                        helperText: "Entrez votre prénom", hintText: "prénom"),
                    autocorrect: false,
                    onChanged: _currentNameChanged,
                    controller: _currentNameFieldController),
              if (_record != null)
                Text("Record de points : $_bestPlayerName :  $_record"),
              Text("score : $_clickCount"),
              Spacer(),
              Image.network(
                "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAMAAACahl6sAAABIFBMVEX///8IJSANPzYz6ssqx6wfingVY1VoTR5JNhUpHgwNPjYIIx6JZycHHxvFzMu/xcQULyrn6ek1S0ciOzfg4eEKLygbSEDz9PSxurhziITX3NoVMSvJ09FKaWMAAAAx4cMv17oMNy8tvaQdfW2ZpqMszbFGW1cYgG0mPzpYRicJKiRdcG2FlJESVkpzg4AXbl8noYsWKR9fSh5BOCsdlYGhtLFRc20tIg1ALxNSPRckqpIHFxNfTzImTkeTqKMQTUOZjnwoMB+KmJZ3alFyVSCxrqc3LRxhgnx7i4ggGApPRjkjaVxVqJhhoJM/r5sstJx4npaKrqhjlYs5YFlzeXdGenGUjY+8ubs9V1MmOSuGe2VBRzgpSkNnWT9gWk5LPCIKgmtNAAAIw0lEQVR4nO2d/XvaRhLHIxnjWDphCAgwxgHx4hfZGMcX+xpITOu2cZrEoTnnLu01d/3//4sDdmZWaIUQNi+yO98f8jxRdkfzYVc7u7Mr5ckTFovFYrFYLBaLxWKxWCwW6/ErV56ozOzWCpOtlebv+5je6flJupzd2tZEY/mLwvyd92pbn6i7gEy2tssg0cQggWKQ+4tBAhUHEIdkg65mt7ZlQ21pzVguiNF7eQrq1EAfT7aFrhtT3Idy2yc3WLeP1k6TzlJBnFYtAaqugTou/poX4TaOsVXtdaxbAWPNRHu5IEYQiCZAjKkgBhRUQRKxAHEfC8ijaREGiR+IERVkWNCILYhpgCKAjOSuHiQwjoALeu+6gPJWpWvHPSjoxAAkWa2Aqk2/qrXdW6Fdz8o7cwEXf/sUUAWtVfbtJYNU8MesKk2z1tRRKQ9IHq7Z/TWlIWTdWIEkDJyslD0gb+CayyAMwiAIYjx0ENsVC78d76h1ACvJ56Eg60sCKR4L/dpHJaqkCoSDxEvU52LxXKh4ThdrFIJICTJ3AzdoLBgElfmGv29HaZpEk37fuo3TEaeltqEsWNNw5V+efu/5grzRhYNaOIgDHHogCPWoGpQbe6qWBAIPtHs6rUXgqZoGIkYHfQUg+lxBYJhbRYswCIMsBgRGrSggEYZfGt1S0+89ZxBDkKTDQCp1R4/aImL0zS+7RZ6UU7D9+nm/LtSvyEVjtSau9Zy6xFOXgwmoun8DxlLlJQX0ADUgJ9+lyDicQnVEht2TKFlT22EtoUEe/mRl7ktdwqTWHgeBHjUFBPMV26umeMIgDLIwMciDAGl2HMeX3g0FuV41xUCXhjjOk+2sUUActIiu94bypHebEmQQ5Ifl1mpQ14hDixRKQrnP7fYHUDK5rqR3mxTPOx/aoH9C3dIdznotTg25We5odc/zAqIOdWpisTgEdFWXOuXldDsUxMY5exx6lCoGiZv+kiCwHIwnSGOwDMR8oRUK0hUnghYe0AupLUWhA30uNVD5XT7/YR91qm4xEtGpWBa288bFsGIq9IhvkDNRV5GZAzftVzGswrYI0EaagntAnr3awtV7B8O6MTpEbOyG2S5lVWeiJihyWU3ReSgIPBna2LzRB1JpQaYE90doFyUUJLWjOrO1aBB3CggMBD6Q8BYpqyAugzAIg6wKxPDvXoWNWgSC+d5lgphTQMTywgoAoTxwFUBki+BJ39AN3IDh9w4gpt4C3e6BjigOH1+Adj9h1A447pOoi1Bf3xcHo/qdTm081Df7aOjiGpEKJ3i/W/Sgdy+QXhKkm3ApTenyC5oh1uhXTygNUYMtdxey8QGp+CZm7PU3CJJ55oIHDnrQ0sy5gFhwaScApB8GAtuceMQgoAiBGLcSRHvIIDqDMAiDxAHEHMoLgmPNvUGMoFFrdDvT8oCQooJkBiAjetPygIDSFBAvKK0YBoIzqjAQB9/o8cQRvJ8EMYVPZnSQQpFE3SeJ6dr29RfQJ3wdpyaPbMn92nWhlzfC0HW+JS7QYS15WqtJhvrbYPuE0sNJ7He30qs7ZIpPoIG77XUUPC1mV6ZFgg7RuRDRj4Shy0EPHKobcHxOni+ooHFnH29Xdy3hw97s3ntBoFdaM4Ng6gp2Pi6N8RljMEgVjdt1CQLP+OpARI9AEGWEYxAG+YuDOI8FBN4+8oEYcQTpV/2q1OhN1Y+XIzUaEIXLDbjwkYqo9asJYwUgVocmG3Sk7PQ57iscTbJ4jCW6Ae8l9Z2YgHRsnNJMfF/sVxwFgl55qz0oEJ1BGOTRg5iPA6Qrlm7dTvNuIKGjljDenTtIqgH6VxJzsEk8AlSnLdx1fFfnBt/fOZ+4Gi1jieJnesWHDNXpeJG8G3oQuh0bXUewhO669Fvlnyv69ywmv6r1XbS9j+1uPZvzieYj6GOe3tvDDBHK1Gb6okhR88t0JAga/20FINp9QSwGYRAGiSVI1yRBgnl2ENOrBYIUMoVCITP448sL0E57HaJXzya5QvbxoKzQxNvLEudUjaRjkK3reL+93Oj+vu9HzKzvD18LnZF+x9x1mwJyu4WJ5gNQduJB2KssFnmD6emkjOx03vaQ7gcOvP7P/UCegs42QGc/WKY16AWmRX1svY0eycdm4szoHZYwDawl53F1e5TotcwXdL8N9ODHuYOgI+35g+zbMEOUIGcMwiAMwiBzATHNwOEXI30ICIbxwOFXAbnX8Jshff8KhOFp4+wPDHoUEOvDgDhal8pgv5sDwcZlAf+6LcP4qNLgD09A/Aa2nx1u4B3Rgx+lV5E5/nuI+ulvoFeb/xB6uwVfl8rs+mcorku72cnWjlAaQvwV/H3HU4SqkaFvOTCeew+323yKHvxETh1G/Tpz5hCb86kE+WVT6C1Z2ZMzPuhtlsdLfBQgm32MT4anCNUjHdA++3u43S8ShJx6GvUkduZ1RBC/zOkgQaxSDwhkrIjpN8AgDHJnkEfzjCwSJONXKWD4Pfw76D2BHGVxsYdrvuxsXesge5Adr79HIP/D+x0GgGwV/C4P6+X2nvkl5wevvgP9nMFQTWtnukKisO049gQQzaVPNh8p9XM5+nXJ5Nc/wQPPLOkPxeNhzryU9jewd6KDPernSJ3ynemLkSoIhT9t4sbvmEpvoY99R05t/KD0yWGqvqQcPr8HiNrtFRD/v0xRCkA2GYRBGGReIDTgeEE2Ywli+cfGMRD6nP7vMj9KcfBrpLteZRWdTPyXL5FMlt6/FR78GZC1tYNALHrRtr6DGeQXVwVP6JwuJeJSxcn/Mk1YvEhOvaBFdhv3rsdA2kouQ9Om/OcCy1QKfTI1dRP+QYG4RBIKYj4YEJNB4iEGeaggnlGrHm8QT/o8EESj11l7VCWeIFpPvvYaBGKRtJiDqJ4Gz349iieIKgZZgRiEQRak6SBKgi6mICFujkByB+kd5TNDqDiBTPYynR6mTAupEMXos4Ohfq7uc8csFovFYrFYLBaLxWKxWCzWffR/owD7NnY4YJ4AAAAASUVORK5CYII=",
                width: 150,
                height: 150,
              ),
              Spacer(),
              if (_isCounting)
                IconButton(
                    onPressed: _ButtonClicked, icon: Icon(Icons.plus_one)),
              Expanded(
                  child: ListView.builder(
                      itemCount: _resultList.length,
                      itemBuilder: _makeRowForResult)),
              if (_isCounting == false)
                ElevatedButton(
                    onPressed: _startCounting,
                    child: Text("Commencer a compter")),
              if (_isCounting == false) Text("  ")
            ],
          ),
        ),
      ),
    );
  }
}
