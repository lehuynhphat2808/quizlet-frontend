import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

Future<void> speak(String? newVoiceText) async {
  FlutterTts flutterTts = FlutterTts();

  await flutterTts.setVolume(10.0);
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setPitch(1.0);
  if (newVoiceText != null) {
    Translation translation = await newVoiceText.translate();
    var lanCode = translation.sourceLanguage.code;
    print("Language Code: $lanCode");
    if (lanCode != 'auto') {
      await flutterTts.setLanguage(lanCode);
    } else {
      await flutterTts.setLanguage('en-US');
    }
  }

  // if (language != null) {
  //   await flutterTts.setLanguage(language);
  // } else {
  //   await flutterTts.setLanguage('en-US');
  // }

  if (newVoiceText != null) {
    if (newVoiceText.isNotEmpty) {
      print('xxxxxxxxxx');
      await flutterTts.speak(newVoiceText);
    }
  }
}
