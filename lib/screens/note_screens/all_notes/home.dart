import 'package:back_to_firebase/custom_widgets/custom_button.dart';
import 'package:back_to_firebase/custom_widgets/loader.dart';
import 'package:back_to_firebase/custom_widgets/note_card.dart';
import 'package:back_to_firebase/custom_widgets/toast_message.dart';
import 'package:back_to_firebase/model/note_model.dart';
import 'package:back_to_firebase/provider/history_provider/history_provider.dart';
import 'package:back_to_firebase/provider/internet_provider/internet_checker_provider.dart';
import 'package:back_to_firebase/provider/locale_provider/locale_provider.dart';
import 'package:back_to_firebase/provider/note_provider/note_provider.dart';
import 'package:back_to_firebase/provider/theme_provider/theme_provider.dart';
import 'package:back_to_firebase/screens/auth_screens/sign_in/sign_in_page.dart';
import 'package:back_to_firebase/screens/search_history/search_history.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../provider/auth_provider/auth_provider.dart';

class Home extends StatefulWidget {
  final Function(bool) onToggle;
  const Home({super.key, required this.onToggle});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  String? uid;

  bool isSearching = false;
  bool isFiltered = false;
  bool hasSearched = false;
  String? editingNoteId;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  TextEditingController editTitleController = TextEditingController();
  TextEditingController editDesController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<String> filteredCategory = ['All', 'Work', 'Personal', 'Study', 'Other'];
  String selectedFilteringCategory = 'All';



  List<String> dropDownCategory = ['Select category', 'Work', 'Personal', 'Study', 'Other'];
  String selectedDropDownCategory = 'Select category';

  late InternetCheckerProvider netProvider;

  @override
  void initState() {
    super.initState();
    showNotesWithUid();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    netProvider = Provider.of<InternetCheckerProvider>(context, listen: false);
    netProvider.addListener(_showInternetToast);
  }

  void _showInternetToast() {
    if (!mounted) {
      return;
    }
    final locale = AppLocalizations.of(context)!;
    final message = locale.internetRestored;
    if (netProvider.isConnected) {
      ToastMsg.successToast(message);
    }
  }


  @override
  void dispose() {
    netProvider.removeListener(_showInternetToast);
    _titleController.dispose();
    _desController.dispose();
    _searchController.dispose();
    editTitleController.dispose();
    editDesController.dispose();
    super.dispose();
  }

  void showNotesWithUid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
    }
    Provider.of<NoteProvider>(context, listen: false).getAllNotes(uid!);
  }

  void alert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildAlertDialog(context);
      },
    );
  }

  AlertDialog _buildAlertDialog(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      title: Text(locale.addNoteTitle,
          style: Theme.of(context).textTheme.headlineSmall),
      content: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                cursorColor: const Color(0xFFe68f50),
                controller: _titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return locale.noteTitleEmptyError;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: locale.noteTitleHint,
                  hintStyle: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            SizedBox(height: 15.h),
              TextFormField(
                cursorColor: const Color(0xFFe68f50),
                controller: _desController,
                maxLines: 5,
                validator: (value) {
                  if (value!.isEmpty) {
                    return locale.noteDescriptionEmptyError;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: locale.noteDescriptionHint,
                  hintStyle: Theme.of(context).textTheme.titleMedium,
                ),
              ),
             SizedBox(height: 15.h),
              DropdownButtonFormField(
                dropdownColor: Theme.of(context).dropdownMenuTheme.menuStyle?.backgroundColor?.resolve({}) ?? Colors.white,
                validator: (value){
                  if(value==locale.selectCategory){
                    return locale.categoryEmptyError;
                  }
                  return null;
                },
                value: selectedDropDownCategory,
                items: dropDownCategory.map((cat){
                  return DropdownMenuItem(
                      value: cat,
                      child: Text(cat,style: Theme.of(context).textTheme.titleMedium,)
                  );
                }).toList(),
                onChanged: (value){
                  if(value!=null){
                    selectedDropDownCategory = value;
                  }
                },
              ),

              SizedBox(height: 15.h),
              CustomButton(
                width: double.infinity.w,
                height: 50.h,
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    final note = NoteModel(
                      id: '',
                      title: _titleController.text,
                      description: _desController.text,
                      uid: uid ?? "",
                      category: selectedDropDownCategory,
                    );

                    final noteProvider =
                    Provider.of<NoteProvider>(context, listen: false);
                    noteProvider.addNote(note);
                    noteProvider.getFilteredCategory(selectedFilteringCategory);
                    _titleController.clear();
                    _desController.clear();
                    setState(() {
                      selectedDropDownCategory = locale.selectCategory;
                    });
                    Navigator.pop(context);
                  }
                },
                child: Provider.of<NoteProvider>(context).isLoading
                    ? Center(child: Loader.loaderWhite())
                    : Text(
                  locale.addNote, style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final provider = Provider.of<AuthProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context, listen: false).themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, provider, locale),
      body: Consumer<InternetCheckerProvider>(
        builder: (context, net, _) {
          if (net.isConnected) {
            return _buildMainBodyColumn(theme, isDark, locale);
          } else {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/net.json', width: 150.w, height: 150.h),
                  SizedBox(height: 20.h),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      locale.noInternet,
                      style: theme.textTheme.titleLarge,
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
      drawer: _buildDrawer(theme, isDark, provider, context, locale),
      floatingActionButton: Container(
        width: 66.w,
        height: 66.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFe68f50), Color(0xFFd49d6e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: alert,
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Column _buildMainBodyColumn(ThemeData theme, bool isDark, AppLocalizations locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(locale.categoriesTitle,
              style: theme.textTheme.headlineSmall?.copyWith(fontSize: 22.sp)),
        ),
        SizedBox(height: 20.h),
        _buildFilteredCategory(isDark),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(locale.allNotesTitle,
              style: theme.textTheme.headlineSmall?.copyWith(fontSize: 22.sp)),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: Consumer<NoteProvider>(
            builder: (context, provider, _) {
              final notesToShow = isSearching ? provider.searchNotes : provider.filteredCategory;

              if (notesToShow.isEmpty) {
                return Center(
                  child: Text(
                    isSearching ? locale.noNotesFound : locale.noNotesToShow,
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18.sp),
                  ),
                );
              }
              return _buildNotesListView(notesToShow, provider);
            },
          ),
        ),
      ],
    );
  }


  Drawer _buildDrawer(ThemeData theme, bool isDark, AuthProvider provider,
      BuildContext context, AppLocalizations locale) {
    return Drawer(
      backgroundColor: theme.drawerTheme.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              radius: 25.r,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Icon(Icons.person, size: 30.sp)
                  : null,
            ),
            accountName: Text(user?.displayName ?? locale.guestUser,
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 16.sp,color: Colors.white)),
            accountEmail: Text(user?.email ?? locale.noEmail,
                style: theme.textTheme.titleSmall?.copyWith(fontSize: 14.sp,color: Colors.white)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFe68f50), Color(0xFFd49d6e)],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          _buildDrawerTile(
              context: context,
              theme: theme,
              icon: Icons.color_lens_outlined,
              title: locale.drawerChangeTheme,
              trailing: SizedBox(
                width: 60.w,
                child: FlutterSwitch(
                  width: 60.w,
                  height: 30.h,
                  toggleSize: 25.r,
                  value: isDark,
                  borderRadius: 20.r,
                  activeColor: Color(0xFF7685be),
                  inactiveColor: Color(0xFFf0bb95),
                  activeIcon: Icon(Icons.nightlight, color: Color(0xFF111524), size: 20.sp),
                  inactiveIcon: Icon(Icons.sunny, color: Color(0xFFe68f50), size: 20.sp),
                  activeToggleColor: Colors.white,
                  inactiveToggleColor: Colors.white,
                  onToggle: widget.onToggle,
                ),
              ),
            ),
            _buildDrawerTile(
              context: context,
              theme: theme,
              icon: Icons.language,
              title: locale.drawerChangeLanguage,
              trailing: DropdownButton<Locale>(
                dropdownColor: theme.dropdownMenuTheme.menuStyle?.backgroundColor?.resolve(({})),
                value: Provider.of<LocaleProvider>(context).locale,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24.sp),
                items: [
                  DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English', style: theme.textTheme.titleMedium)),
                  DropdownMenuItem(
                      value: Locale('bn'),
                      child: Text('বাংলা', style: theme.textTheme.titleMedium)),
                ],
                onChanged: (Locale? locale) {
                  if (locale != null) {
                    Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
                  }
                },
              ),
            ),
            _buildDrawerTile(
              context: context,
              theme: theme,
              icon: Icons.history,
              title: locale.drawerHistory,
              trailing: Icon(Icons.arrow_forward_ios_outlined,
                  color: theme.iconTheme.color, size: 20.sp),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SearchHistory()));
              },
            ),
            _buildDrawerTile(
              context: context,
              theme: theme,
              icon: Icons.logout,
              title: locale.drawerSignOut,
              trailing: provider.isLoading
                  ? (isDark ? Loader.loaderWhite() : Loader.loaderPurple())
                  : Icon(Icons.arrow_forward_ios_outlined,
                  color: theme.iconTheme.color, size: 20.sp),
              onTap: () async {
                bool success = await provider.signOut();
                if (success) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const SignInPage()));
                } else {
                  ToastMsg.errorToast(provider.errorMsg!);
                }
              },
            ),
            _buildDrawerTile(
              context: context,
              theme: theme,
              icon: Icons.power_settings_new_outlined,
              title: locale.drawerExitApp,
              trailing: Icon(Icons.arrow_forward_ios_outlined,
                  color: theme.iconTheme.color, size: 20.sp),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        backgroundColor:
                        Theme.of(context).dialogTheme.backgroundColor,
                        title: Text(locale.exitDialogTitle,
                            style: theme.textTheme.titleLarge?.copyWith(fontSize: 18.sp)),
                        content: Text(locale.exitDialogContent,
                            style: theme.textTheme.titleMedium?.copyWith(fontSize: 16.sp)),
                        actions: [
                          TextButton(
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                              child: Text(locale.yes,
                                  style: theme.textTheme.titleMedium)),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(locale.no,
                                  style: theme.textTheme.titleMedium)),
                        ],
                      );
                    });
              },
            ),

        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Card(
        color: theme.cardColor,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: ListTile(
          tileColor: Colors.transparent,
          onTap: onTap,
          leading: Icon(icon, color: theme.iconTheme.color, size: 24.sp),
          title: Text(title, style: theme.textTheme.titleMedium),
          trailing: trailing,
        ),
      ),
    );
  }


  AppBar _buildAppBar(
      BuildContext context, AuthProvider provider, AppLocalizations locale) {
    return AppBar(
      title: isSearching
          ? TextField(
        controller: _searchController,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        autofocus: true,
        decoration: InputDecoration(
          hintText: locale.searchHint,
          hintStyle: const TextStyle(color: Colors.white),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder:
          const OutlineInputBorder(borderSide: BorderSide.none),
        ),
        onSubmitted: (query){
          Provider.of<NoteProvider>(context, listen: false).searchForNotes(query);
          Provider.of<HistoryProvider>(context, listen: false).saveSearchHistory(query);
        },
      )
          : Text('EverNote',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30.sp)),
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarHeight: 65.h,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient:
            LinearGradient(colors: [Color(0xFFe68f50), Color(0xFFd49d6e)]),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r))),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.r),
          child: isSearching
              ? IconButton(
              onPressed: () async {
                setState(() {
                  isSearching = false;
                  hasSearched = false;
                });
              },
              icon: const Icon(Icons.close, color: Colors.white))
              : IconButton(
            onPressed: () async {
              setState(() {
                isSearching = true;
                hasSearched = true;
              });
            },
            icon:  Icon(Icons.search, color: Colors.white, size: 30.sp),
          ),
        ),
      ],
    );
  }

  ListView _buildNotesListView(List<NoteModel> notesToShow, NoteProvider provider) {
    return ListView.builder(
      itemCount: notesToShow.length,
      itemBuilder: (context, index) {
        final data = notesToShow[index];
        final isEditing = editingNoteId == data.id;
        return NoteCard(
          note: data,
          index: (index + 1).toString().padLeft(2, '0'),
          isLoading: provider.isLoading,
          isEditing: isEditing,
          titleController: editTitleController,
          desController: editDesController,
          selectedCategory: selectedDropDownCategory,
          items: dropDownCategory,
          onChanged: (value) {
            if (value != null) {
              selectedDropDownCategory = value;
            }
          },
          onEditIconPress: () {
            setState(() {
              editingNoteId = data.id;
              editTitleController.text = data.title;
              editDesController.text = data.description;
              selectedDropDownCategory = data.category;
            });
          },
          onCancelButtonPress: () {
            setState(() {
              editingNoteId = null;
            });
          },
          onEditTap: () {
            if (editTitleController.text.trim().isEmpty ||
                editDesController.text.trim().isEmpty) {
              return;
            }
            Provider.of<NoteProvider>(context, listen: false).updateNote(
              NoteModel(
                id: data.id,
                title: editTitleController.text.trim(),
                description: editDesController.text.trim(),
                uid: data.uid,
                category: selectedDropDownCategory,
              ),
            );
            setState(() {
              editingNoteId = null;
            });
            if (isSearching) {
              Provider.of<NoteProvider>(context, listen: false).searchForNotes(_searchController.text);
            }
          },
          onDeleteTap: () async {
            await provider.deleteNote(data.uid, data.id);
            if (isSearching) {
              provider.searchForNotes(_searchController.text);
            } else {
              provider.getFilteredCategory(selectedFilteringCategory);
            }
          },
        );
      },
    );
  }

  SizedBox _buildFilteredCategory(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 40.h,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 8.w),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredCategory.length,
            itemBuilder: (context, index) {
              final data = filteredCategory[index];
              bool isSelected = Provider.of<NoteProvider>(context, listen: false).selectedCategory == data;
              return Padding(
                padding:EdgeInsets.symmetric(horizontal: 8.0.w),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilteringCategory = data;
                    });
                    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
                    noteProvider.setCategory(data);
                  },
                  child: Container(
                    width: 100.w,
                    decoration: isSelected
                        ? const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFFe68f50), Color(0xFFd49d6e)]),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    )
                        : BoxDecoration(
                        color: isDark ? Color(0xFFfcf3ec) : const Color(0xFFf7dcc8),
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Text(
                          data,
                          style: isSelected ? TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold
                          )
                              :  TextStyle(
                              color: Colors.black,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
