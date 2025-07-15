
import 'package:back_to_firebase/custom_widgets/custom_button.dart';
import 'package:back_to_firebase/custom_widgets/loader.dart';
import 'package:back_to_firebase/custom_widgets/note_card.dart';
import 'package:back_to_firebase/custom_widgets/toast_message.dart';
import 'package:back_to_firebase/model/note_model.dart';
import 'package:back_to_firebase/provider/history_provider/history_provider.dart';
import 'package:back_to_firebase/provider/internet_provider/internet_checker_provider.dart';
import 'package:back_to_firebase/provider/note_provider/note_provider.dart';
import 'package:back_to_firebase/provider/theme_provider/theme_provider.dart';
import 'package:back_to_firebase/screens/auth_screens/sign_in/sign_in_page.dart';
import 'package:back_to_firebase/screens/search_history/search_history.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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

  List<String> filteredCategory = ['All','Work','Personal','Study','Other'];
  String selectedFilteringCategory = 'All';

  List<String> dropDownCategory = ['Select category','Work','Personal','Study','Other'];
  String selectedDropDownCategory = 'Select category';

  @override
  void initState() {
    showNotesWithUid();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final netProvider = Provider.of<InternetCheckerProvider>(context,listen: false);
      netProvider.addListener((){
        final message = 'Internet connection restored';
        if(netProvider.isConnected){
          ToastMsg.successToast(message);
        }
      });
    });
  }


  void showNotesWithUid(){
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      uid = user.uid;
    }
    Provider.of<NoteProvider>(context,listen: false).getAllNotes(uid!);
  }

  void alert(){
    showDialog(
        context: context, 
        builder: (BuildContext context){
          return _buildAlertDialog(context);
        }
    );
  }

  AlertDialog _buildAlertDialog(BuildContext context) {
    return AlertDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Text("Add a note",style: Theme.of(context).textTheme.headlineSmall ),
          content: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    cursorColor: Color(0xFFe68f50),
                   controller: _titleController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please enter a title";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter a title',
                      hintStyle: Theme.of(context).textTheme.titleMedium
                    ),
                  ),

                  const SizedBox(height: 15,),
                  TextFormField(
                    cursorColor: Color(0xFFe68f50),
                   controller: _desController,
                    maxLines: 6,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please enter a description";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter a description',
                        hintStyle: Theme.of(context).textTheme.titleMedium
                    ),
                  ),
                  const SizedBox(height: 15,),
                  DropdownButtonFormField(
                    dropdownColor: Theme.of(context)
                        .dropdownMenuTheme
                        .menuStyle
                        ?.backgroundColor
                        ?.resolve({}) ?? Colors.white,
                      validator: (value){
                        if(value=='Select category'){
                          return "Please select a category";
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
                  const SizedBox(height: 15,),
                  CustomButton(
                    width: double.infinity,
                    height: 55,
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        final note = NoteModel(
                          id: '',
                          title: _titleController.text,
                          description: _desController.text,
                          uid: uid ?? "",
                          category: selectedDropDownCategory,
                        );

                        final noteProvider = Provider.of<NoteProvider>(context, listen: false);
                        noteProvider.addNote(note);
                        noteProvider.getFilteredCategory(selectedFilteringCategory);
                        _titleController.clear();
                        _desController.clear();
                        setState(() {
                          selectedDropDownCategory = 'Select category';
                        });
                        Navigator.pop(context);
                      }
                    },

                    child: Provider.of<NoteProvider>(context).isLoading?Center(child: Loader.loaderWhite(),)
                      :Text('Add note',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                  )
                ],
              ),
            ),
          ),
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _desController.dispose();
    _searchController.dispose();
    editTitleController.dispose();
    editDesController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final provider = Provider.of<AuthProvider>(context);
    bool isDark = Provider.of<ThemeProvider>(context,listen: false).themeMode==ThemeMode.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, provider),
      body: Consumer<InternetCheckerProvider>(
          builder: (context, net, _){
            if(net.isConnected){
              return _buildMainBodyColumn(theme, isDark);
            }
            else{
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/net.json',width: 150,height: 150),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('No internet connection',style: theme.textTheme.titleLarge,),
                    )
                  ],
                ),
              );
            }
          },

      ),
      drawer: _buildDrawer(theme, isDark, provider, context),

      floatingActionButton: Container(
        width: 66,
        height: 66,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFFe68f50),Color(0xFFd49d6e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: alert,
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Column _buildMainBodyColumn(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("Categories",style: theme.textTheme.headlineSmall),
        ),
        const SizedBox(height: 20,),
        _buildFilteredCategory(isDark),
        const SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("All notes",style: theme.textTheme.headlineSmall,),
        ),
        const SizedBox(height: 10,),
        Expanded(
          child: Consumer<NoteProvider>(
            builder: (context, provider, _) {
              final notesToShow = isSearching
                  ? provider.searchNotes
                  : provider.filteredCategory;

              if (notesToShow.isEmpty) {
                return Center(
                  child: Text(
                    isSearching ? 'No notes found' : 'No notes to show',
                    style: Theme.of(context).textTheme.titleLarge,
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

  Drawer _buildDrawer(ThemeData theme, bool isDark, AuthProvider provider, BuildContext context) {
    return Drawer(
    backgroundColor: theme.drawerTheme.backgroundColor,
    child: ListView(
      padding: EdgeInsets.all(0),
      children: [
        UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              radius: 25,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Icon(Icons.person, size: 30)
                  : null,
            ),
            accountName: Text(user?.displayName?? "Guest",style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(user?.email ?? "No email",style: TextStyle(fontWeight: FontWeight.bold),),
            decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFe68f50),Color(0xFFd49d6e)],
                begin: Alignment.topLeft,
                end: Alignment.topRight
            )
          ),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Card(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: ListTile(
              tileColor: Colors.transparent,
              leading: Icon(Icons.color_lens_outlined,color: theme.iconTheme.color,),
              title: Text('Change theme',style: theme.textTheme.titleMedium,),
              trailing: SizedBox(
                width: 60,
                child: FlutterSwitch(
                    width: 60.0,
                    height: 30.0,
                    toggleSize: 25.0,
                    value: isDark,
                    borderRadius: 20.0,
                    activeColor: Color(0xFF7685be),
                    inactiveColor: Color(0xFFf0bb95),
                    activeIcon: Icon(Icons.nightlight, color: Color(0xFF111524)),
                    inactiveIcon: Icon(Icons.sunny, color: Color(0xFFe68f50)),
                    activeToggleColor: Colors.white,
                    inactiveToggleColor: Colors.white,
                    onToggle: widget.onToggle
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Card(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: ListTile(
              tileColor: Colors.transparent,
              leading: Icon(Icons.language,color: theme.iconTheme.color,),
              title: Text('Change language',style: theme.textTheme.titleMedium,),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Card(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: ListTile(
              tileColor: Colors.transparent,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchHistory()));
              },
              leading: Icon(Icons.history,color: theme.iconTheme.color,),
              title: Text('History',style: theme.textTheme.titleMedium,),
              trailing: Icon(Icons.arrow_forward_ios_outlined,color: theme.iconTheme.color,),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Card(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: ListTile(
              tileColor: Colors.transparent,
              onTap: ()async{
                bool success = await provider.signOut();
                if(success){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SignInPage()));
                }
                else{
                  ToastMsg.errorToast(provider.errorMsg!);
                }
              },
              leading: Icon(Icons.logout,color: theme.iconTheme.color,),
              title: Text('Sign out',style: theme.textTheme.titleMedium,),
              trailing: provider.isLoading?
               isDark? Loader.loaderWhite(): Loader.loaderPurple()
                  :Icon(Icons.arrow_forward_ios_outlined,color: theme.iconTheme.color,),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Card(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: ListTile(
              tileColor: Colors.transparent,
              onTap: (){
                  showDialog(
                      context: context,
                      builder: (ctx){
                        return AlertDialog(
                          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
                          title: Text('Wait',style: Theme.of(context).textTheme.titleLarge,),
                          content: Text("Are you sure you want to exit from the app?",style: Theme.of(context).textTheme.titleMedium,),
                          actions: [
                            TextButton(
                                onPressed: (){
                                  SystemNavigator.pop();
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

              },
              leading: Icon(Icons.power_settings_new_outlined,color: theme.iconTheme.color,),
              title: Text('Exit app',style: theme.textTheme.titleMedium,),
              trailing: Icon(Icons.arrow_forward_ios_outlined,color: theme.iconTheme.color,),
            ),
          ),
        ),
      ],
    ),
   );
  }

  AppBar _buildAppBar(BuildContext context, AuthProvider provider) {
    return AppBar(
      title: isSearching?
          TextField(
            controller: _searchController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search for notes',
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none
              ),
            ),
            onChanged: (query){
              Provider.of<NoteProvider>(context,listen: false).searchForNotes(query);
              Provider.of<HistoryProvider>(context,listen: false).saveSearchHistory(query);
            },
          )
      :Text('InkWell',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 30),),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      toolbarHeight: 65,
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
          child: isSearching?
          IconButton(
              onPressed: ()async{
                setState(() {
                  isSearching = false;
                  hasSearched = false;
                });
              },
              icon: Icon(Icons.close,color: Colors.white)
          )
          :IconButton(
              onPressed: ()async{
                setState(() {
                  isSearching = true;
                  hasSearched = true;
                });
              },
              icon: Icon(Icons.search,color: Colors.white,size: 30,)
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
                    onChanged: (value){
                      if(value!=null){
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
                      }
                      else {
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
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
               scrollDirection: Axis.horizontal,
                itemCount: filteredCategory.length,
                itemBuilder: (context,index){
                 final data = filteredCategory[index];
                 bool isSelected = Provider.of<NoteProvider>(context,listen: false).selectedCategory==data;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilteringCategory = data;
                        });

                        final noteProvider = Provider.of<NoteProvider>(context, listen: false);
                        noteProvider.setCategory(data);
                      },
                      child: Container(
                        width: 100,
                        decoration: isSelected?BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFFe68f50),Color(0xFFd49d6e)]
                        ),
                          borderRadius: BorderRadius.circular(30)
                        ) : BoxDecoration(
                            color: isDark ? Colors.white : Color(0xFFf7dcc8),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Center(child: Text(data,style: isSelected?
                              TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)
                            : TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),)),
                      ),
                    ),
                  );
                }
            ),
          ),
        );
  }
}
