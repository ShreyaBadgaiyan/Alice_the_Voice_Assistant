//
//
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
//import 'package:speech_to_text/speech_recognition_result.dart';
//import 'package:speech_to_text/speech_recognition_result.dart';
//import 'package:speech_to_text/speech_to_text.dart';
import 'package:voiceassistant/feature_Box.dart';
import 'package:voiceassistant/openai_service.dart';
import 'package:voiceassistant/pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts=FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService=OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start=200;
  int delay=200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async{
    await flutterTts.setSharedInstance(true);
    setState(() {

    });
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content)async {

      await flutterTts.speak(content);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BounceInDown(child: Text('Alice')),
          leading: Icon(Icons.menu),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ZoomIn(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Pallete.assistantCircleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      height: 123,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/virtualAssistant.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Chat bubble

              FadeInRight(
                child: Visibility(
                  visible: generatedImageUrl==null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.symmetric(
                      horizontal: 40,
                    ).copyWith(
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Pallete.borderColor,
                        ),
                        borderRadius: BorderRadius.circular(20).copyWith(
                          topLeft: Radius.zero,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        generatedContent==null?
                        'Heyyaa! What task can I do for you?'
                         :generatedContent!,
                        style: TextStyle(
                            color: Pallete.mainFontColor,
                            fontSize: generatedContent==null?25:18,
                            fontFamily: 'Cera Pro'),
                      ),
                    ),
                  ),
                ),
              ),
              if (generatedImageUrl!=null)Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(generatedImageUrl!)),
              ),


              SlideInLeft(
                child: Visibility(
                visible:generatedContent==null&&generatedImageUrl==null,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 10, left: 22),
                    child: Text(
                      'Here are a few features ',
                      style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera Pro'),
                    ),
                  ),
                ),
              ),

              //Features list

              Visibility(
                visible: generatedContent==null&&generatedImageUrl==null,
                child: Column(
                  children: [
                    SlideInLeft(
                      delay:Duration(milliseconds: start),
                      child: FeatureBox(
                        color: Pallete.firstSuggestionBoxColor,
                        headerText: 'ChatGPT',
                        descText:
                            'A smarter way to stay organized and informed with ChatGPT',
                      ),
                    ),
                    SlideInLeft(
    delay:Duration(milliseconds: start+delay),

    child: FeatureBox(
                        color: Pallete.secondSuggestionBoxColor,
                        headerText: 'Dall-E',
                        descText:
                            'Get inspired and stay creative with your personal assistant powered by Dall-E',
                      ),
                    ),
    SlideInLeft(
    delay:Duration(milliseconds: start+delay+delay),

    child: FeatureBox(

    color: Pallete.thirdSuggestionBoxColor,
                        headerText: 'Smart Voice Assistant',
                        descText:
                            'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ZoomIn(
    delay:Duration(milliseconds: start+delay+delay+delay),

    child: FloatingActionButton(
            backgroundColor: Pallete.secondSuggestionBoxColor,
            onPressed: () async {
              if (await speechToText.hasPermission &&
                  speechToText.isNotListening) {
                await startListening();
              } else if (speechToText.isListening) {
               final speech= await openAIService.isArtPromptAPI(lastWords);
               if(speech.contains('http')){
                 generatedImageUrl=speech;
                 generatedContent=null;
               }else{
                 generatedImageUrl=null;
                 generatedContent=speech;
          
                 setState(()  {
          
                 });
                 await systemSpeak(speech);
               }
               await systemSpeak(speech);
                await stopListening();
              } else {
                initSpeechToText();
              }
            },
           child:Icon(speechToText.isListening?Icons.stop:Icons.mic)
          ),
        )
    );
  }
}
