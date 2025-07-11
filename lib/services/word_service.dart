import 'dart:convert';
import 'package:exci_flutter/models/word.dart';
import 'package:exci_flutter/models/word_stat.dart';
import 'package:exci_flutter/utils/constants.dart';
import 'package:http/http.dart' as http;

class ListWordStat{
  late List<WordStat> lstWordStats;
  ListWordStat(List<Word> lstWords, int userId){
    if(lstWords.isEmpty == true) return;
    
    lstWordStats = [];
    for (var word in lstWords) {
      lstWordStats.add(WordStat(
        wordId: word.id,
        userId: userId,
        // nSteak: 0,
        // nMaxSteak: 0,
        memoryStat: 0,
        nListening: 0,
        nFListening: 0,
        nReading: 0,
        nFReading: 0,
        nWriting: 0,
        nFWriting: 0,
        // nSpeaking: 0,
        // nFSpeaking: 0
        ));
    }
  }

  WordStat? Search(int id){
    return lstWordStats.where((w) => w.wordId == id).firstOrNull;
  }

  Future<void> Save() async {
    if(lstWordStats.isEmpty == true)
    {
      return;
    }
    
    lstWordStats.forEach((stat) async {
      try{
        stat.CalculateMemoryStat();
        final url = Uri.parse('${host}/api/USER_VOCAB');
        final response = await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: json.encode(stat.toJson()),
          );

        if (response.statusCode != 200) {
          throw Exception('Failed to save the word stat');
        }
      }catch(error){
        print(error);
        print("${stat.wordId} ${stat.userId}");
      }
    });
  }
}