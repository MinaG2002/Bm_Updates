// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Add a Swap Request          `
  String get AddaSwapRequest {
    return Intl.message(
      'Add a Swap Request          ',
      name: 'AddaSwapRequest',
      desc: '',
      args: [],
    );
  }

  /// `your Name`
  String get yourName {
    return Intl.message('your Name', name: 'yourName', desc: '', args: []);
  }

  /// `Enter your name`
  String get Enteryourname {
    return Intl.message(
      'Enter your name',
      name: 'Enteryourname',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get Pleaseenteryourname {
    return Intl.message(
      'Please enter your name',
      name: 'Pleaseenteryourname',
      desc: '',
      args: [],
    );
  }

  /// `Enter cisco number`
  String get Entercisconumber {
    return Intl.message(
      'Enter cisco number',
      name: 'Entercisconumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your cisco number `
  String get Enteryourcisconumber {
    return Intl.message(
      'Enter your cisco number ',
      name: 'Enteryourcisconumber',
      desc: '',
      args: [],
    );
  }

  /// `Please `
  String get Please {
    return Intl.message('Please ', name: 'Please', desc: '', args: []);
  }

  /// `Enter Location`
  String get EnterLocation {
    return Intl.message(
      'Enter Location',
      name: 'EnterLocation',
      desc: '',
      args: [],
    );
  }

  /// `Please select a location`
  String get Pleaseselectalocation {
    return Intl.message(
      'Please select a location',
      name: 'Pleaseselectalocation',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get Enteryourphonenumber {
    return Intl.message(
      'Enter your phone number',
      name: 'Enteryourphonenumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone`
  String get Pleaseenteryourphone {
    return Intl.message(
      'Please enter your phone',
      name: 'Pleaseenteryourphone',
      desc: '',
      args: [],
    );
  }

  /// `rquest Type`
  String get rquestType {
    return Intl.message('rquest Type', name: 'rquestType', desc: '', args: []);
  }

  /// `Select request type`
  String get Selectrequesttype {
    return Intl.message(
      'Select request type',
      name: 'Selectrequesttype',
      desc: '',
      args: [],
    );
  }

  /// `Please select a request type`
  String get Pleaseselectarequesttype {
    return Intl.message(
      'Please select a request type',
      name: 'Pleaseselectarequesttype',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get SelectDate {
    return Intl.message('Select Date', name: 'SelectDate', desc: '', args: []);
  }

  /// `Please select a date`
  String get Pleaseselectadate {
    return Intl.message(
      'Please select a date',
      name: 'Pleaseselectadate',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get Notes {
    return Intl.message('Notes', name: 'Notes', desc: '', args: []);
  }

  /// `Enter any additional notes`
  String get Enteranyadditionalnotes {
    return Intl.message(
      'Enter any additional notes',
      name: 'Enteranyadditionalnotes',
      desc: '',
      args: [],
    );
  }

  /// `add request successfully`
  String get addrequestsuccessfully {
    return Intl.message(
      'add request successfully',
      name: 'addrequestsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// ` Submit Request`
  String get SubmitRequest {
    return Intl.message(
      ' Submit Request',
      name: 'SubmitRequest',
      desc: '',
      args: [],
    );
  }

  /// `All requests`
  String get Allrequests {
    return Intl.message(
      'All requests',
      name: 'Allrequests',
      desc: '',
      args: [],
    );
  }

  /// `Filter by Location`
  String get FilterbyLocation {
    return Intl.message(
      'Filter by Location',
      name: 'FilterbyLocation',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get All {
    return Intl.message('All', name: 'All', desc: '', args: []);
  }

  /// `requests`
  String get requests {
    return Intl.message('requests', name: 'requests', desc: '', args: []);
  }

  /// `There are no requests yet`
  String get Therearenorequestsyet {
    return Intl.message(
      'There are no requests yet',
      name: 'Therearenorequestsyet',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Name {
    return Intl.message('Name', name: 'Name', desc: '', args: []);
  }

  /// `Cisco Number`
  String get CiscoNumber {
    return Intl.message(
      'Cisco Number',
      name: 'CiscoNumber',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get Phone {
    return Intl.message('Phone', name: 'Phone', desc: '', args: []);
  }

  /// `Date`
  String get Date {
    return Intl.message('Date', name: 'Date', desc: '', args: []);
  }

  /// `Whats App`
  String get WhatsApp {
    return Intl.message('Whats App', name: 'WhatsApp', desc: '', args: []);
  }

  /// `⚠️ Not logged in`
  String get Notloggedin {
    return Intl.message(
      '⚠️ Not logged in',
      name: 'Notloggedin',
      desc: '',
      args: [],
    );
  }

  /// `My Requests`
  String get MyRequests {
    return Intl.message('My Requests', name: 'MyRequests', desc: '', args: []);
  }

  /// `No requests yet`
  String get Norequestsyet {
    return Intl.message(
      'No requests yet',
      name: 'Norequestsyet',
      desc: '',
      args: [],
    );
  }

  /// `Confirm deletion`
  String get Confirmdeletion {
    return Intl.message(
      'Confirm deletion',
      name: 'Confirmdeletion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this request?`
  String get Areyousureyouwanttodeletethisrequest {
    return Intl.message(
      'Are you sure you want to delete this request?',
      name: 'Areyousureyouwanttodeletethisrequest',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message('Cancel', name: 'Cancel', desc: '', args: []);
  }

  /// `The request was successfully deleted`
  String get Therequestwassuccessfullydeleted {
    return Intl.message(
      'The request was successfully deleted',
      name: 'Therequestwassuccessfullydeleted',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get Delete {
    return Intl.message('Delete', name: 'Delete', desc: '', args: []);
  }

  /// `Edit request successfully`
  String get Editrequestsuccessfully {
    return Intl.message(
      'Edit request successfully',
      name: 'Editrequestsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Edit Request`
  String get EditRequest {
    return Intl.message(
      'Edit Request',
      name: 'EditRequest',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Save {
    return Intl.message('Save', name: 'Save', desc: '', args: []);
  }

  /// `Select date`
  String get Selectdate {
    return Intl.message('Select date', name: 'Selectdate', desc: '', args: []);
  }

  /// `All Requests`
  String get AllRequests {
    return Intl.message(
      'All Requests',
      name: 'AllRequests',
      desc: '',
      args: [],
    );
  }

  /// `Edit Swap`
  String get EditSwap {
    return Intl.message('Edit Swap', name: 'EditSwap', desc: '', args: []);
  }

  /// `Add Swap`
  String get AddSwap {
    return Intl.message('Add Swap', name: 'AddSwap', desc: '', args: []);
  }

  /// `Updates`
  String get Updates {
    return Intl.message('Updates', name: 'Updates', desc: '', args: []);
  }

  /// `Latest updates`
  String get Latestupdates {
    return Intl.message(
      'Latest updates',
      name: 'Latestupdates',
      desc: '',
      args: [],
    );
  }

  /// `Top Rank`
  String get TopRank {
    return Intl.message('Top Rank', name: 'TopRank', desc: '', args: []);
  }

  /// `Results`
  String get Results {
    return Intl.message('Results', name: 'Results', desc: '', args: []);
  }

  /// `Notification`
  String get Notification {
    return Intl.message(
      'Notification',
      name: 'Notification',
      desc: '',
      args: [],
    );
  }

  /// `PERSONAL DETAILS`
  String get PERSONALDETAILS {
    return Intl.message(
      'PERSONAL DETAILS',
      name: 'PERSONALDETAILS',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get Welcome {
    return Intl.message('Welcome', name: 'Welcome', desc: '', args: []);
  }

  /// `Your Cisco`
  String get YourCisco {
    return Intl.message('Your Cisco', name: 'YourCisco', desc: '', args: []);
  }

  /// `Log Out`
  String get LogOut {
    return Intl.message('Log Out', name: 'LogOut', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
