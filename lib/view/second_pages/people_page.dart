import 'package:aexpenz/controller/init_data.dart';
import 'package:aexpenz/model/admin_model.dart';
import 'package:aexpenz/model/contact_model.dart';
import 'package:aexpenz/view/content/loading.dart';
import 'package:aexpenz/view/main_pages/home_page.dart';
import 'package:aexpenz/view/third_pages/selected_person.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({
    Key? key,
  }) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final Color _darkColor = const Color.fromARGB(255, 66, 66, 66);
  final Color _lightColor = Colors.blue;
  late final bool _isDark;
  bool _isLoading = false;
  final AdminModel _admin = HomePageState.adminModel;
  final List<ContactModel> _searchList = [];
  final List<ContactModel> duplicateItems = IntiData.userContacts;
  final NumberFormat _oCcy = NumberFormat('#,##0.00');
  TextEditingController searchController = TextEditingController();
  late final OutlineInputBorder _border;
  List<int> indexFound = [];

  @override
  void initState() {
    super.initState();
    _isDark = HomePageState.isDark;
    _border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      borderSide:
          BorderSide(color: _isDark ? Colors.white : Colors.black, width: 1),
    );
    _searchList.addAll(duplicateItems);
    setFoundIndex();
  }

  ListView contactsData({required double w, required double h}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _searchList.length,
      itemBuilder: (_, index) {
        return GestureDetector(
            child: ListTile(
          title: Text(_searchList[index].contactModelName),
          trailing: SizedBox(
              width: w / 2.5,
              child: Row(
                children: [
                  const Icon(Icons.arrow_upward_rounded,
                      color: Colors.redAccent),
                  Text(_oCcy.format(_searchList[index].contactModelSentAmount)),
                  const SizedBox(width: 5),
                  const Icon(Icons.arrow_downward_rounded,
                      color: Colors.greenAccent),
                  Text(_oCcy
                      .format(_searchList[index].contactModelReceivedAmount)),
                ],
              )),
          subtitle: _searchList[index].contactModelPhone.isEmpty &&
                  _searchList[index].contactModelEmail.isEmpty
              ? const Text('No data')
              : Column(children: [
                  if (_searchList[index].contactModelEmail.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchList[index].contactModelEmail.length,
                      itemBuilder: (context, emailIndex) {
                        return Text(
                            _searchList[index].contactModelEmail[emailIndex]!);
                      },
                    ),
                  if (_searchList[index].contactModelPhone.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchList[index].contactModelPhone.length,
                      itemBuilder: (context, phoneIndex) {
                        return Text(
                            _searchList[index].contactModelPhone[phoneIndex]!);
                      },
                    )
                ]),
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => SelectedPerson(
                      index: indexFound.elementAt(index),
                    )));
          },
        ));
      },
    );
  }

  Column emptyData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('There is no data to be obtained.'),
              const Text('Or'),
              const Text('Permission denied'),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            _isDark ? _darkColor : _lightColor)),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await IntiData.fetchContactData(a: _admin);
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: const Text('Fetch now')),
              )
            ],
          ),
        ),
      ],
    );
  }

  Column body({required double w, required double h}) {
    return Column(
      children: [
        Center(child: searchBar(w: w)),
        _searchList.isNotEmpty
            ? Expanded(
                child: contactsData(h: h, w: w),
              )
            : const Center(
                child: Text('No data...'),
              )
      ],
    );
  }

  Padding searchBar({required double w}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w / 6, vertical: 10),
      child: TextField(
        autocorrect: true,
        decoration: InputDecoration(
          border: _border,
          focusedBorder: _border,
          hintText: 'Search...',
        ),
        controller: searchController,
        onChanged: (value) {
          filterSearchResults(query: value);
        },
      ),
    );
  }

  void setFoundIndex() {
    indexFound.clear();
    for (int i = 0; i < duplicateItems.length; i++) {
      indexFound.add(i);
    }
  }

  void filterSearchResults({required String query}) {
    List<ContactModel> dummySearchList = [];
    setFoundIndex();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      indexFound.clear();
      List<ContactModel> dummyListData = [];
      for (int i = 0; i < dummySearchList.length; i++) {
        if (dummySearchList[i]
                .contactModelName
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            dummySearchList[i].contactModelPhone.toString().contains(query)) {
          dummyListData.add(dummySearchList[i]);
          indexFound.add(i);
        }
      }
      setState(() {
        _searchList.clear();
        _searchList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _searchList.clear();
        _searchList.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return _isLoading
        ? Loading(isDark: _isDark)
        : duplicateItems.isEmpty
            ? emptyData()
            : body(h: h, w: w);
  }

  @override
  void dispose() {
    HomePageState.adminModel = _admin;
    super.dispose();
  }
}
