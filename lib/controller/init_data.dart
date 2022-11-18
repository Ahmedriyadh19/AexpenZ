import 'dart:io';
import 'package:aexpenz/model/admin_model.dart';
import 'package:aexpenz/model/category_model.dart';
import 'package:aexpenz/model/contact_model.dart';
import 'package:aexpenz/model/profile_model.dart';
import 'package:aexpenz/model/unique_id_model.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class IntiData {
  static List<ContactModel> userContacts = [];

  static AdminModel intiData({required String p, required String n}) {
    String id = UniqueID.generateID();
    String phone = '+1145555';
    List<ProfileModel> profiles = [];
    return createProfile(
        a: AdminModel(
            password: p,
            phone: phone,
            userID: id,
            userName: n,
            profiles: profiles,
            transactionRecords: [],
            email: '',
            pic: '',
            friendsIDs: []));
  }

  static AdminModel createProfile(
      {required AdminModel a, String? profileName, String? des}) {
    List<CategoryModel> categories = [];
    List<String> tit = ['Bills', 'Car', 'Food', 'Loan', 'Rental'];
    for (int i = 0; i < tit.length; i++) {
      categories.add(CategoryModel(
          categoryID: UniqueID.generateID(),
          categoryName: tit[i],
          amount: 0.0,
          transactionRecords: [],
          categoryDescription: '$i'));
    }

    ProfileModel p2 = ProfileModel(
        profileID: UniqueID.generateID(),
        profileName: profileName ?? a.userName,
        profileDescription: des ?? 'N/A',
        categoriesModel: categories);
    a.profiles.add(p2);

    return a;
  }

  static AdminModel createSubProfile(
      {required AdminModel a,
      required String name,
      String? description,
      required int targetProfile}) {
    CategoryModel temp = CategoryModel(
        categoryID: UniqueID.generateID(),
        categoryName: name,
        amount: 0.0,
        transactionRecords: [],
        categoryDescription: description);
    a.profiles[targetProfile]!.categoriesModel.add(temp);
    a.profiles[targetProfile]!.categoriesModel.sort(
      (a, b) {
        return a!.categoryName
            .toLowerCase()
            .compareTo(b!.categoryName.toLowerCase());
      },
    );
    return a;
  }

  static AdminModel editSubProfile({
    required AdminModel a,
    required String name,
    String? description,
    required int targetProfile,
    required int targetSub,
  }) {
    CategoryModel? temp = a.profiles[targetProfile]!.categoriesModel[targetSub];
    a.profiles[targetProfile]!.categoriesModel.removeAt(targetSub);

    if (name != temp!.categoryName) {
      temp.categoryName = name;
    }
    if (description != temp.categoryDescription) {
      temp.categoryDescription = description;
    }
    a.profiles[targetProfile]!.categoriesModel.add(temp);
    a.profiles[targetProfile]!.categoriesModel.sort(
      (a, b) {
        return a!.categoryName
            .toLowerCase()
            .compareTo(b!.categoryName.toLowerCase());
      },
    );
    return a;
  }

  static AdminModel deleteSubProfile({
    required AdminModel a,
    required int targetProfile,
    required int targetSub,
  }) {
    a.profiles[targetProfile]!.categoriesModel.removeAt(targetSub);
    a.profiles[targetProfile]!.categoriesModel.sort(
      (a, b) {
        return a!.categoryName
            .toLowerCase()
            .compareTo(b!.categoryName.toLowerCase());
      },
    );
    return a;
  }

  static AdminModel deleteProfile({
    required AdminModel a,
    required int targetProfile,
  }) {
    a.profiles.removeAt(targetProfile);
    return a;
  }

  static AdminModel editProfileName(
      {required AdminModel a,
      required int targetProfile,
      required String newName}) {
    a.profiles[targetProfile]!.profileName = newName;
    return a;
  }

  static List<String> getPhone({required List<Phone> phoneList}) {
    List<String> holdData = [];
    for (var i = 0; i < phoneList.length; i++) {
      holdData.add(phoneList[i].number);
    }
    return holdData;
  }

  static List<String> getEmail({required List<Email> emailList}) {
    List<String> holdData = [];
    for (var i = 0; i < emailList.length; i++) {
      holdData.add(emailList[i].address);
    }
    return holdData;
  }

  static Future fetchContactData({required AdminModel a}) async {
    List<Contact> contacts = [];
    if (Platform.isAndroid || Platform.isIOS) {
      if (await FlutterContacts.requestPermission()) {
        a.friendsIDs.clear();
        userContacts.clear();
        contacts.clear();
        String id = a.userID;
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
        for (int i = 0; i < contacts.length; i++) {
          String tempID = UniqueID.generateID();
          userContacts.add(ContactModel(
            transactionRecords: [],
            adminID: id,
            contactModelID: tempID,
            contactModelName: contacts[i].displayName,
            contactModelPhone: contacts[i].phones.isEmpty
                ? []
                : getPhone(phoneList: contacts[i].phones),
            contactModelEmail: contacts[i].emails.isEmpty
                ? []
                : getEmail(emailList: contacts[i].emails),
          ));
          a.friendsIDs.add(tempID);
        }
      }
    }
  }
}
