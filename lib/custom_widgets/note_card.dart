

import 'package:back_to_firebase/custom_widgets/custom_button.dart';
import 'package:back_to_firebase/custom_widgets/gradient_background.dart';
import 'package:back_to_firebase/model/note_model.dart';
import 'package:back_to_firebase/provider/theme_provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoteCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = Provider.of<ThemeProvider>(context,listen: false).themeMode==ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Skeletonizer(
        enabled: isLoading,
        child: Card(
          color: theme.cardColor,
          elevation: 1,
          child: ExpansionTile(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            collapsedIconColor: theme.iconTheme.color,
            iconColor: theme.iconTheme.color,
            tilePadding: EdgeInsets.all(15),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: SizedBox(
              width: 40,
              height: 40,
              child: ClipOval(
                child: GradientBackground(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(index, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            title: isEditing?? false?
            TextField(
              controller: titleController,
              autofocus: true,
              cursorColor: Color(0xFFe68f50),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Color(0xFFe68f50),width: 2)
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Color(0xFFe68f50),width: 2)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Color(0xFFe68f50),width: 2)
                ),

              ),
            )
            :Text(note.title, style: theme.textTheme.titleLarge),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isEditing?? false?
                    TextField(
                      cursorColor: Color(0xFFe68f50),
                      controller: desController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Color(0xFFe68f50),
                                width: 2
                            )
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0xFFe68f50),width: 2)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0xFFe68f50),width: 2)
                        ),

                      ),
                    )
                    :Text(note.description, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 15),
                    isEditing?? false?
                    Row(
                      children: [
                        Text("Category : ",style: TextStyle(color: Color(0xFFe68f50),fontWeight: FontWeight.bold,fontSize: 18),),
                        SizedBox(width: 10,),
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField(
                            dropdownColor: theme.dropdownMenuTheme.menuStyle?.backgroundColor?.resolve({}),
                            iconDisabledColor: theme.iconTheme.color,
                            iconEnabledColor: theme.iconTheme.color,
                            value: selectedCategory,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFFe68f50), width: 2)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFFe68f50), width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFFe68f50), width: 2)),
                            ),
                            items: items?.map((cat){
                              return DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat)
                              );
                            }).toList(),
                            onChanged: onChanged,
                          ),
                        ),
                      ],
                    ):Row(
                      children: [
                        Text("Category : ",style: TextStyle(color: Color(0xFFe68f50),fontWeight: FontWeight.bold,fontSize: 18),),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(note.category,style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Divider(
                          thickness: 0.5,
                          indent: 0,
                          endIndent: 0,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        isEditing??false?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: onCancelButtonPress,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark? Colors.white : Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                                ),
                                child: Text("Cancel",style: TextStyle(color: isDark? Colors.black:Colors.white,fontWeight: FontWeight.w500),)
                            ),
                            const SizedBox(width: 10),
                            CustomButton(
                                onPressed: onEditTap ?? (){},
                                width: 93,
                                height: 42,
                                child: Text('Update',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
                            )
                          ],
                        )
                            :Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                icon: Icon(Icons.edit_note, color: Color(0xFFe68f50),size: 30,),
                                onPressed: onEditIconPress
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: onDeleteTap,
                            ),
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

