import 'dart:convert';
import 'dart:js_interop';
import 'package:http/http.dart' as http;

import 'package:voiceassistant/secrets.dart';

class OpenAIService{
  final List<Map<String,String>> messages=[];

  Future<String> isArtPromptAPI(String prompt) async{

    try{

      final res=await http.post(
        Uri.parse(''),//Here I will add the post link
        headers:{
          'Content-Type':'application/json',
          'Authorization':'Bearer $apikey',
        },

        body:jsonEncode({
          "model":"gpt-3.5-turbo",
          "messages":[
            {
              'role':'user',
              'content':
                  'Does this message want to generate an AI picture ,image,art or anything similar? $prompt.Simply answer with a yes or a no'
            }
          ]
        })
      );
      print(res.body);
      if(res.statusCode==200){
        String content=
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content=content.trim();
        switch(content){
          case 'Yes':
          case 'yes':
            case 'Yes.':
              case 'yes.':
                final res=await dallEAPI(prompt);
                return res;
          default:
            final res=await chatGPTAPI(prompt);
            return res;
        }

      }
      return 'An internal error occured';

      }
    catch(e){
      return e.toString();
    }
  }


  Future<String> chatGPTAPI(String prompt) async{

    messages.add({
      'role': 'user',
      'content': prompt
    } );
    try{

      final res=await http.post(
          Uri.parse(''),//Here I will add the post link
          headers:{
            'Content-Type':'application/json',
            'Authorization':'Bearer $apikey',
          },

          body:jsonEncode({
            "model":"gpt-3.5-turbo",
            "messages":messages
          })
      );

      if(res.statusCode==200){
        String content=
        jsonDecode(res.body)['choices'][0]['message']['content'];
        content=content.trim();
        messages.add({
          'role': 'assistant',
          'content': content
        } );
        return content;

      }
      return 'An internal error occured';

    }
    catch(e){
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async{

    messages.add({
      'role': 'user',
      'content': prompt
    } );
    try{

      final res=await http.post(
          Uri.parse(''),//Here I will add the post link
          headers:{
            'Content-Type':'application/json',
            'Authorization':'Bearer $apikey',
          },

          body:jsonEncode({
            "prompt":prompt,
            'n':1
          })
      );

      if(res.statusCode==200){
        String imageUrl=
        jsonDecode(res.body)['data'][0]['url'];
        imageUrl=imageUrl.trim();
        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        } );
        return imageUrl;

      }
      return 'An internal error occured';

    }
    catch(e){
      return e.toString();
    }
  }
}