// needed packages
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'languages.dart';

// run the app
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Sets up the design for the app
    return MaterialApp(
      title: 'Talk To Me Nice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

// creates the class as a stateful widget, giving us access to state management
class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

// class for the speech screen 
class _SpeechScreenState extends State<SpeechScreen> {
  // a map of words that will be highlighted in the text, these words are the names of the app
  final Map<String, HighlightedWord> _highlights = {
    'talk': HighlightedWord(
        onTap: () {},
        textStyle:
            // text will be bolded and red
            const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    'to': HighlightedWord(
        onTap: () {},
        textStyle:
            // text will be bolded and yellow
            const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
    'me': HighlightedWord(
        onTap: () {},
        textStyle:
            // text will be bolded and green
            const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
    'nice': HighlightedWord(
        onTap: () {},
        textStyle:
            // text will be bolded and blue
            const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
  };

  // object for http post
  Dio dio = new Dio();

  // object for text to speech
  final FlutterTts tts = FlutterTts();

  // variable for speech to text
  stt.SpeechToText _speech;
  // variable for checking if listening
  bool _isListening = false;
  // get the users input in this text variable
  String _text = "Press the mic button and start speaking";
  // the current language code
  String _lang = "es";
  // if we have translated yet
  bool _translated = false;

  // when the class is initialized, set up the speech to text
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    // Layout of the app
    return Scaffold(
      // appBar set up
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // title here
              Text("Talk To Me Nice: "),
              // Dropdown for language selector
              DropdownButton(
                iconEnabledColor: Colors.white,
                // the value will be the language code
                value: _lang,
                // loop through the list of languages and create dropdown buttons for them
                items: Languages.map((Language value) {
                  return new DropdownMenuItem<String>(
                    // the value of the button will be the google code
                    value: value.googleCode,
                    // The text of the button will be the bolded title
                    child: new Text(value.title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  );
                }).toList(),
                underline: SizedBox(
                  height: 0,
                ),
                // when the dropdown selects a new value, switch the value of the _lang variable
                onChanged: (value) {
                  setState(() {
                    _lang = value;
                  });
                },
              ),
            ],
          ),
        ),
         // position of the buttons
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // add the buttons
        floatingActionButton: Padding(
          // create padding
          padding: const EdgeInsets.all(8),
          // get a row of button
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // button 1: translate
              FloatingActionButton(
                // on the button press...
                onPressed: () async {
                  ///...post to the transaltor, get the value back, and set the _text to our value
                  await postData().then((value) {
                    print(value);
                    setState(() => _text = value);
                  });
                },
                // use translation icon
                child: Icon(Icons.translate),
              ),
              // button 2: speak
              FloatingActionButton(
                // speak the text on button press
                onPressed: () => _speak(),
                // use record icon
                child: Icon(Icons.record_voice_over),
              ),
              // Button 3: mic
              // add animated avatar glow effect
              AvatarGlow(
                animate: _isListening,
                glowColor: Colors.red,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                child: FloatingActionButton(
                  // use the listen function on pressed
                  onPressed: _listen,
                  // change icon between mic and mic_none depending on _isListening
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                ),
              ),
              // button 4: clear
              FloatingActionButton(
                // on press, set text back to default and translated to false
                onPressed: () {
                  setState(() {
                    _text = "Press the mic button and start speaking";
                    _translated = false;
                  });
                },
                // use backspace icon
                child: Icon(Icons.backspace),
              ),
              // button 5: camera
              FloatingActionButton(
                // dont do anything on press, used to summon camera, but caused some errors
                onPressed: () {},
                // use camera icon
                child: Icon(Icons.camera_enhance),
              ),
            ],
          ),
        ),
        // keep text in a scroll view
        body: SingleChildScrollView(
            // scroll backwords
            reverse: true,
            child: Container(
                // add padding
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 150),
                child: TextHighlight(
                    // _text will be the text for this body
                    text: _text,
                    // mark the words to highlight
                    words: _highlights,
                    textStyle: const TextStyle(
                        fontSize: 32.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)))));
  }

  // post the text to the translation api
  Future postData() async {
    // url to the api we made
    final String pathUrl =
        "https://TalkToMeNiceCS50.emekaezike1.repl.co/api/translate";

    // data sent in object form
    dynamic data = {"text": _text, "lang": _lang};

    // post the data and get response
    var response = await dio.post(pathUrl,
        data: data,
        options: Options(headers: {
          'Content-type': 'application/json; charset=UTF-8',
        }));

    // parse the Json
    var parsedJson = new Map<String, dynamic>.from(response.data);
    // change the state of translated to true
    setState(() => _translated = true);

    // get and return the result
    return parsedJson['result'];
  }

  // speak the text
  Future _speak() async {
    String language;
    // if translated is true, then get the flutter code of what we translated to
    if (_translated) {
      for (int i = 0; i < Languages.length; i++) {
        if (Languages[i].googleCode == _lang) {
          language = Languages[i].flutterCode;
          break;
        }
      }
      // else, just use english
    } else {
      language = "en-US";
    }

    // use the accent of the previously set language
    await tts.setLanguage(language);
    await tts.setPitch(1);
    // speak the text
    await tts.speak(_text);
  }

  // listen function
  void _listen() async {
    // if we aren't listening yet...
    if (!_isListening) {
      //... initialize the speech recognition
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        // we are now listening
        setState(() => _isListening = true);
        // listen to audio
        _speech.listen(
          // set the result of the recognized audio to the text
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                  _translated = false;
                }));
      }
    } else {
      // if we are listening, stop the speech and set listening to false
      _speech.stop();
      setState(() => _isListening = false);
    }
  }
}