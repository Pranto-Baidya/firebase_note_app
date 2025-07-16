import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/history_provider/history_provider.dart';
class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Provider.of<HistoryProvider>(context, listen: false).loadSearchHistory(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search history',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFe68f50), Color(0xFFd49d6e)],
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: user == null
                  ? null
                  : () {
                warning();
              },
              icon: const Icon(Icons.delete_forever, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Please log in to view search history.'))
          : Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<HistoryProvider>(
              builder: (context, prefs, _) {
                return prefs.historyList.isEmpty
                    ? Center(
                  child: Text(
                    'No history to show',
                    style: theme.textTheme.titleMedium,
                  ),
                )
                    : ListView.builder(
                  itemCount: prefs.historyList.length,
                  itemBuilder: (context, index) {
                    final data = prefs.historyList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 3),
                      child: Card(
                        color: theme.cardColor,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20),
                          tileColor: Colors.transparent,
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.red,
                            child: Text(
                              '${index + 1}'.padLeft(2, '0'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            'You searched for $data',
                            style: theme.textTheme.titleSmall,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              historyProvider.removeSpecificHistory(index);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void warning() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Text('Wait', style: Theme.of(context).textTheme.titleLarge),
          content: Text(
            "Are you sure you want to clear all the history?",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<HistoryProvider>(context, listen: false).clearAllHistory();
                Navigator.pop(context);
              },
              child: Text('Yes', style: Theme.of(context).textTheme.titleMedium),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No', style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        );
      },
    );
  }
}