import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/history_provider/history_provider.dart';
import '../../l10n/app_localizations.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale.searchHistoryTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25.sp,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFe68f50), Color(0xFFd49d6e)],
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.r),
              bottomLeft: Radius.circular(20.r),
            ),
          ),
        ),
        actions: [
          if (user != null)
            Padding(
              padding:EdgeInsets.only(right: 20.w),
              child: IconButton(
                onPressed: historyProvider.historyList.isEmpty ? null : warning,
                icon: Icon(Icons.delete_forever, color: Colors.white, size: 30.sp),
              ),
            ),
        ],
      ),
      body: user == null?Center(
        child: Text(
          locale.pleaseLoginToViewHistory,
          style: theme.textTheme.titleMedium,
        ),
      )
          : Column(
        children: [
         SizedBox(height: 10.h),
          Expanded(
            child: historyProvider.historyList.isEmpty
                ? Center(
              child: Text(
                locale.noHistoryToShow,
                style: theme.textTheme.titleMedium,
              ),
            )
                : ListView.builder(
              itemCount: historyProvider.historyList.length,
              itemBuilder: (context, index) {
                final data = historyProvider.historyList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
                  child: Card(
                    color: theme.cardColor,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(20.w),
                      tileColor: Colors.transparent,
                      leading: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${index + 1}'.padLeft(2, '0'),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      title: Text('${locale.youSearchedFor} "$data"', style: theme.textTheme.titleSmall,
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
            ),
          ),
        ],
      ),
    );
  }

  void warning() {
    final locale = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Text(locale.exitDialogTitle, style: Theme.of(context).textTheme.titleLarge),
          content: Text(
            locale.exitDialogContent,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<HistoryProvider>(context, listen: false).clearAllHistory();
                Navigator.pop(context);
              },
              child: Text(locale.yes, style: Theme.of(context).textTheme.titleMedium),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(locale.no, style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        );
      },
    );
  }
}
