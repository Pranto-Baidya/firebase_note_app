
import 'package:back_to_firebase/provider/history_provider/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {

  List<String> historyList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<HistoryProvider>(context,listen: false).loadSearchHistory();
    });
    super.initState();
  }

  void warning(){
    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
            title: Text('Wait',style: Theme.of(context).textTheme.titleLarge,),
            content: Text("Are you sure you want to clear all the history?",style: Theme.of(context).textTheme.titleMedium,),
            actions: [
              TextButton(
                  onPressed: (){
                    Provider.of<HistoryProvider>(context,listen: false).clearAllHistory();
                    Navigator.pop(context);
                  }, child: Text('Yes',style: Theme.of(context).textTheme.titleMedium,)
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('No',style: Theme.of(context).textTheme.titleMedium,)
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search history',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 30),),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFe68f50),Color(0xFFd49d6e)]
              ),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: (){
                  warning();
                },
                icon: Icon(Icons.delete_forever,color: Colors.white,size: 30,)
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Expanded(
            child: Consumer<HistoryProvider>(
                builder: (context,prefs, _){
                  return prefs.historyList.isEmpty? Center(child: Text('No history to show',style: theme.textTheme.titleMedium,),)
                      : ListView.builder(
                      itemCount: prefs.historyList.length,
                      itemBuilder: (context,index){
                        final data = prefs.historyList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 3),
                          child: Card(
                            color: theme.cardColor,
                            elevation: 1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(20),
                              tileColor: Colors.transparent,
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.red,
                                child: Text('${index+1}'.padLeft(2,'0',),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ),
                              title: Text('You searched for $data',style: theme.textTheme.titleSmall,),
                              trailing: IconButton(
                                  onPressed: (){
                                    historyProvider.removeSpecificHistory(index);
                                  },
                                  icon: Icon(Icons.delete,color: Colors.red,)
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
