import 'dart:async';
import 'package:back_to_firebase/custom_widgets/custom_button.dart';
import 'package:back_to_firebase/custom_widgets/gradient_background.dart';
import 'package:back_to_firebase/model/note_model.dart';
import 'package:back_to_firebase/provider/theme_provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../l10n/app_localizations.dart';

class NoteCard extends StatefulWidget {
  final NoteModel note;
  final String index;
  final VoidCallback? onEditIconPress;
  final VoidCallback? onCancelButtonPress;
  final VoidCallback? onEditTap;
  final VoidCallback onDeleteTap;
  final bool isLoading;
  final bool? isEditing;
  final TextEditingController? titleController;
  final TextEditingController? desController;
  final String? selectedCategory;
  final List<String>? items;
  final ValueChanged<String?>? onChanged;

  const NoteCard({
    super.key,
    required this.note,
    required this.index,
    this.onEditIconPress,
    this.onCancelButtonPress,
    this.onEditTap,
    required this.onDeleteTap,
    required this.isLoading,
    this.isEditing,
    this.titleController,
    this.desController,
    this.selectedCategory,
    this.items,
    this.onChanged,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {

  bool isTyping = false;
  late final Stream<dynamic> _minuteStream;

  @override
  void initState() {
    super.initState();
    _minuteStream = Stream.periodic(const Duration(minutes: 1),(_)=>null).asBroadcastStream();
    widget.titleController?.addListener(checkTyping);
    widget.desController?.addListener(checkTyping);

  }

  void checkTyping() {
    bool hasChanged = (widget.titleController?.text.trim() != widget.note.title.trim()) || (widget.desController?.text.trim() != widget.note.description.trim());

    if (hasChanged != isTyping) {
      setState(() {
        isTyping = hasChanged;
      });
    }
  }


  @override
  void dispose() {
    widget.titleController?.removeListener(checkTyping);
    widget.desController?.removeListener(checkTyping);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = Provider.of<ThemeProvider>(context, listen: false).themeMode == ThemeMode.dark;
    final locale = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      child: Skeletonizer(
        enabled: widget.isLoading,
        child: Card(
          color: theme.cardColor,
          elevation: 1,
          child: ExpansionTile(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            collapsedIconColor: theme.iconTheme.color,
            iconColor: theme.iconTheme.color,
            tilePadding: EdgeInsets.all(15.w),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            leading: SizedBox(
              width: 40.w,
              height: 40.h,
              child: ClipOval(
                child: GradientBackground(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(widget.index, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            title: (widget.isEditing ?? false)
                ? TextField(
              controller: widget.titleController,
              autofocus: true,
              cursorColor: const Color(0xFFe68f50),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: Color(0xFFe68f50), width: 2.w)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: Color(0xFFe68f50), width: 2.w)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: Color(0xFFe68f50), width: 2.w)),
              ),
            )
                : Text(widget.note.title, style: theme.textTheme.titleLarge),
            children: [
              Padding(
                padding:  EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (widget.isEditing ?? false)
                        ? TextField(
                      cursorColor: const Color(0xFFe68f50),
                      controller: widget.desController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide:  BorderSide(color: Color(0xFFe68f50), width: 2.w)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: Color(0xFFe68f50), width: 2.w)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: Color(0xFFe68f50), width: 2.w)),
                      ),
                    )
                        : Text(widget.note.description, style: theme.textTheme.titleMedium),
                    SizedBox(height: 15.h),
                    (widget.isEditing ?? false)
                        ? Row(
                      children: [
                        Text(locale.categoryLabel,
                            style: TextStyle(color: Color(0xFFe68f50), fontWeight: FontWeight.bold, fontSize: 18.sp)),
                       SizedBox(width: 10.w),
                        SizedBox(
                          width: 200.w,
                          child: DropdownButtonFormField(
                            dropdownColor: theme.dropdownMenuTheme.menuStyle?.backgroundColor?.resolve({}),
                            iconDisabledColor: theme.iconTheme.color,
                            iconEnabledColor: theme.iconTheme.color,
                            value: widget.selectedCategory,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide(color: Color(0xFFe68f50), width: 2.w)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide(color: Color(0xFFe68f50), width: 2.w)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide:  BorderSide(color: Color(0xFFe68f50), width: 2.w)),
                            ),
                            items: widget.items?.map((cat) {
                              return DropdownMenuItem(value: cat, child: Text(cat));
                            }).toList(),
                            onChanged: widget.onChanged,
                          ),
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        Text(locale.categoryLabel,
                            style:  TextStyle(color: Color(0xFFe68f50), fontWeight: FontWeight.bold, fontSize: 18.sp)),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0.w),
                          child: Text(widget.note.category,
                              style: theme.textTheme.titleMedium?.copyWith(fontSize: 18)),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    if (widget.note.updatedAt != null)
                      StreamBuilder(
                        stream: _minuteStream,
                        builder: (context, _) {
                          return Text("${locale.lastUpdated} : ${timeago.format(widget.note.updatedAt!)}",
                            style: theme.textTheme.labelMedium,
                          );
                        },
                      ),
                    SizedBox(height: 15.h),
                    Divider(thickness: 0.5, indent: 0, endIndent: 0, color: Colors.grey),
                    SizedBox(height: 10.h),
                    (widget.isEditing ?? false)
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: widget.onCancelButtonPress,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.white : Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r))),
                          child: Text(locale.cancelButton,
                              style: TextStyle(color: isDark ? Colors.black : Colors.white, fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(width: 10.w),
                        isTyping? CustomButton(
                          onPressed: widget.onEditTap ?? () {},
                          width: 123.w,
                          height: 41.h,
                          child: Text(locale.updateButton,
                              style:  TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 14.sp)),
                        ):ElevatedButton(
                            onPressed: null,
                            child: Text(locale.updateButton),
                        )
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit_note, color: Color(0xFFe68f50), size: 30.sp),
                            onPressed: widget.onEditIconPress),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: widget.onDeleteTap),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
