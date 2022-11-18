import 'package:aexpenz/controller/init_data.dart';
import 'package:aexpenz/model/admin_model.dart';
import 'package:aexpenz/view/main_pages/home_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:toggle_list/toggle_list.dart';

class ProfilesCreatorPage extends StatefulWidget {
  const ProfilesCreatorPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilesCreatorPage> createState() => _ProfilesCreatorPageState();
}

class _ProfilesCreatorPageState extends State<ProfilesCreatorPage> {
  List<ToggleListItem> listProfiles = [];
  final Color _darkColor = const Color.fromARGB(255, 66, 66, 66);
  final Color _lightColor = Colors.blue;
  final AdminModel _admin = HomePageState.adminModel;
  late bool _isDark;

  @override
  void initState() {
    _isDark = HomePageState.isDark;
    super.initState();
    buildProfiles();
  }

  @override
  void dispose() {
    HomePageState.adminModel = _admin;
    super.dispose();
  }

  Row optionsRow({
    required int profileIndex,
    required int categoryIndex,
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(_isDark ? _darkColor : _lightColor)),
        onPressed: () {
          setState(() {
            showAlertDialogCategory(
                context: context,
                category: categoryIndex,
                isCreate: false,
                profile: profileIndex);
          });
        },
        child: const Icon(Icons.edit),
      ),
      const SizedBox(width: 5),
      ElevatedButton(
          onPressed: () {
            setState(() {
              IntiData.deleteSubProfile(
                  a: _admin,
                  targetProfile: profileIndex,
                  targetSub: categoryIndex);
              buildProfiles();
            });
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  _isDark ? _darkColor : _lightColor)),
          child: const Icon(Icons.delete_forever))
    ]);
  }

  void refresh() {
    setState(() {});
  }

  Container buildBody({required double h, required double w}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ListView(
        children: [
          ToggleList(
              shrinkWrap: true,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              curve: Curves.easeInOut,
              children: listProfiles),
          Padding(
            padding: EdgeInsets.symmetric(vertical: h / 25),
            child: newProfileBtn(w: w),
          )
        ],
      ),
    );
  }

  void buildProfiles() {
    listProfiles.clear();
    for (int i = 0; i < _admin.profiles.length; i++) {
      listProfiles.add(ToggleListItem(
          expandedTitle: Text(_admin.profiles[i]!.profileName,
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          title: Text(_admin.profiles[i]!.profileName,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          content: Column(children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: _admin.profiles[i]!.categoriesModel.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _admin.profiles[i]!.categoriesModel[index]!
                                  .categoryName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              child: Text(
                                  _admin.profiles[i]!.categoriesModel[index]!
                                          .categoryDescription ??
                                      'N/A',
                                  style: const TextStyle(fontSize: 18)),
                            )
                          ]),
                      optionsRow(profileIndex: i, categoryIndex: index)
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const Divider(endIndent: 25, indent: 25, thickness: 2, height: 2),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('Customization'.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            profileOptionsButton(index: i),
            const Divider(endIndent: 25, indent: 25, thickness: 2, height: 30)
          ])));
    }
  }

  Padding profileOptionsButton({required int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: boxBorder(),
            child: TextButton(
                onPressed: () {
                  showAlertDialogCategory(
                      context: context,
                      category: 0,
                      isCreate: true,
                      profile: index);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _isDark ? _darkColor : _lightColor)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_box_rounded, color: Colors.white),
                    SizedBox(height: 5),
                    Text('Category', style: TextStyle(color: Colors.white)),
                  ],
                )),
          ),
          Container(
            decoration: boxBorder(),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    showAlertDialogProfile(
                        context: context, isEdit: true, targetIndex: index);
                  });
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _isDark ? _darkColor : _lightColor)),
                child: Column(
                  children: const [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(height: 5),
                    Text('Profile', style: TextStyle(color: Colors.white)),
                  ],
                )),
          ),
          Container(
            decoration: boxBorder(),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    if (_admin.profiles.length <= 1) {
                      dialogDeletingProfile(
                          targetIndex: index,
                          isOne: true,
                          dialog: "You can't delete the root profile");
                    } else {
                      dialogDeletingProfile(targetIndex: index, isOne: false);
                    }
                  });
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _isDark ? _darkColor : _lightColor)),
                child: Column(
                  children: const [
                    Icon(Icons.delete_forever_rounded, color: Colors.white),
                    SizedBox(height: 5),
                    Text('Profile', style: TextStyle(color: Colors.white)),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  boxBorder() {
    return BoxDecoration(
        border: Border.all(
            color: _isDark ? Colors.white : Colors.blueAccent, width: 2.5),
        borderRadius: const BorderRadius.all(Radius.circular(15)));
  }

  AwesomeDialog dialogDeletingProfile(
      {required int targetIndex, String? dialog, required bool isOne}) {
    return AwesomeDialog(
        context: context,
        dialogType: isOne ? DialogType.error : DialogType.warning,
        animType: AnimType.topSlide,
        title: isOne ? 'Error' : 'Warning',
        desc: isOne
            ? dialog
            : ' This profile will be deleted and all thr date will be lost\nAre you sure?',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          setState(() {
            if (!isOne) {
              IntiData.deleteProfile(a: _admin, targetProfile: targetIndex);
              buildProfiles();
            }
          });
        })
      ..show();
  }

  Row newProfileBtn({required double w}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: w / 2,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    _isDark ? _darkColor : _lightColor)),
            onPressed: () {
              showAlertDialogProfile(context: context, isEdit: false);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_to_photos_rounded),
                SizedBox(width: 5),
                Text('New Profile'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future showAlertDialogProfile(
      {required BuildContext context, required bool isEdit, int? targetIndex}) {
    TextEditingController profileNameCon = TextEditingController();
    TextEditingController profileDescriptionCon = TextEditingController();
    String? errorName;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Center(
                  child: Text(isEdit ? 'Edit profile name' : 'Create profile')),
              content: SizedBox(
                height: 140,
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: inputDec(
                                label: 'Profile name',
                                hints: isEdit
                                    ? 'Edit profile name'
                                    : 'New profile name')
                            .copyWith(errorText: errorName),
                        enabled: true,
                        maxLines: null,
                        minLines: null,
                        onChanged: (value) {
                          setState(
                            () {
                              if (value.trim().isEmpty) {
                                errorName = 'Invalid';
                              } else {
                                errorName = null;
                              }
                              for (var element in _admin.profiles) {
                                if (value.trim() == element!.profileName) {
                                  errorName = 'This name already existed';
                                }
                              }
                            },
                          );
                        },
                        controller: profileNameCon,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: inputDec(
                            label: 'Description', hints: 'Profile Description'),
                        controller: profileDescriptionCon,
                        enabled: true,
                        maxLines: null,
                        minLines: null,
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel',
                      style: TextStyle(
                          color: _isDark ? Colors.white : Colors.blue)),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                ),
                TextButton(
                  child: Text('Done',
                      style: TextStyle(
                          color: _isDark ? Colors.white : Colors.blue)),
                  onPressed: () {
                    setState(() {
                      if (profileNameCon.text.trim().isNotEmpty) {
                        if (isEdit) {
                          IntiData.editProfileName(
                              a: _admin,
                              newName: profileNameCon.text,
                              targetProfile: targetIndex!);
                        } else {
                          IntiData.createProfile(
                              a: _admin,
                              profileName: profileNameCon.text,
                              des: profileDescriptionCon.text);
                        }
                        listProfiles.clear();
                        buildProfiles();
                        refresh();
                        Navigator.of(context).pop();
                      } else {
                        setState(
                          () => errorName = 'Invalid',
                        );
                      }
                    });
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Future showAlertDialogCategory(
      {required BuildContext context,
      required int profile,
      required int category,
      required bool isCreate}) {
    TextEditingController? profileNameCon = TextEditingController();
    TextEditingController? categoryNameCon = TextEditingController();
    String? error;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Center(
                  child: Text(isCreate ? 'New category' : 'Edit category')),
              content: SizedBox(
                height: 140,
                child: Column(children: [
                  Expanded(
                    child: TextField(
                      decoration: inputDec(
                              label: 'Category name',
                              hints: isCreate
                                  ? 'Your category name'
                                  : 'New category name')
                          .copyWith(errorText: error),
                      enabled: true,
                      maxLines: null,
                      minLines: null,
                      controller: profileNameCon,
                      onChanged: (value) {
                        setState(
                          () {
                            if (value.trim().isEmpty) {
                              error = 'Invalid';
                            } else {
                              error = null;
                            }
                            for (var element
                                in _admin.profiles[profile]!.categoriesModel) {
                              if (value.trim() == element!.categoryName) {
                                error = 'This name already existed';
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: inputDec(
                          hints: 'Description',
                          label: isCreate
                              ? 'Your description'
                              : 'New description'),
                      controller: categoryNameCon,
                      enabled: true,
                      maxLines: null,
                      minLines: null,
                    ),
                  )
                ]),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel',
                      style: TextStyle(
                          color: _isDark ? Colors.white : Colors.blue)),
                  onPressed: () {
                    setState(() => Navigator.of(context).pop());
                    refresh();
                  },
                ),
                TextButton(
                  child: Text('Done',
                      style: TextStyle(
                          color: _isDark ? Colors.white : Colors.blue)),
                  onPressed: () {
                    if (profileNameCon.text.isNotEmpty ||
                        profileNameCon.text.trim().isNotEmpty) {
                      setState(() {
                        if (isCreate) {
                          IntiData.createSubProfile(
                              name: profileNameCon.text,
                              description:
                                  categoryNameCon.text.trim().isNotEmpty
                                      ? categoryNameCon.text
                                      : 'N/A',
                              a: _admin,
                              targetProfile: profile);
                        } else {
                          IntiData.editSubProfile(
                              name: profileNameCon.text,
                              description:
                                  categoryNameCon.text.trim().isNotEmpty
                                      ? categoryNameCon.text
                                      : _admin
                                          .profiles[profile]!
                                          .categoriesModel[category]!
                                          .categoryDescription,
                              a: _admin,
                              targetProfile: profile,
                              targetSub: category);
                        }
                        buildProfiles();
                        refresh();
                        Navigator.of(context).pop();
                      });
                    } else {
                      setState(() {
                        error = 'Invalid can\'t be Empty';
                      });
                    }
                  },
                )
              ],
            );
          }),
        );
      },
    );
  }

  InputDecoration inputDec({required String label, required String hints}) {
    return InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        label: Text(label),
        hintText: hints);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return buildBody(h: h, w: w);
  }
}
