import 'dart:convert';

import '../../core/utils/constants.dart';

import '../data/source/pref_manager.dart';

class SessionManager {

  final PrefManager _prefManager;

  SessionManager(this._prefManager);

  // String? get phone => _prefManager.getStringValue(currentUserPhone);
  //
  // set phone(String? value) => _prefManager.saveString(currentUserPhone, value ?? "");
  //
  // String? get docPath => _prefManager.getStringValue(currentDocPath);
  // set docPath(String? value) => _prefManager.saveString(currentDocPath, value ?? "");
  //
  // String? get userName => _prefManager.getStringValue(currentUserUserName);
  //
  // set userName(String? value) => _prefManager.saveString(currentUserUserName, value ?? "");
  //
  // String? get companyAddress => _prefManager.getStringValue(companyAddressKey);
  //
  // set companyAddress(String? value) => _prefManager.saveString(companyAddressKey, value ?? "");
  //
  // String? get email => _prefManager.getStringValue(currentUserEmail);
  //
  // set email(String? value) => _prefManager.saveString(currentUserEmail, value ?? "");
  //
  // String? get contactPerson => _prefManager.getStringValue(currentContactPerson);
  //
  // set contactPerson(String? value) => _prefManager.saveString(currentContactPerson, value ?? "");
  //
  // String? get companyName => _prefManager.getStringValue(currentCompanyName);
  //
  // set companyName(String? value) => _prefManager.saveString(currentCompanyName, value ?? "");
  //
  // String? get loginId => _prefManager.getStringValue(currentUserLoginId);
  //
  // set comUsrAcc(int? value) => _prefManager.saveInt(companyUserAccount, value ?? 0);
  // int? get comUsrAcc => _prefManager.getIntValue(companyUserAccount);
  //
  // set accountStatus(int? value) => _prefManager.saveInt(accountStatusKey, value ?? 0);
  // int? get accountStatus => _prefManager.getIntValue(accountStatusKey);
  //
  // set loginId(String? value) => _prefManager.saveString(currentUserLoginId, value ?? "");
  //
  // String? get decodeId => _prefManager.getStringValue(currentCompanyDecodeId);
  //
  // set decodeId(String? value) => _prefManager.saveString(currentCompanyDecodeId, value ?? "");
  //
  // int? get companyId => _prefManager.getIntValue(currentCompanyId);
  //
  // set companyId(int? value) => _prefManager.saveInt(currentCompanyId, value ?? 0);
  //
  // int? get isIncomplete => _prefManager.getIntValue(accountIncomplete);
  //
  // set isIncomplete(int? value) => _prefManager.saveInt(accountIncomplete, value ?? 0);
  //
  // String? get companyCode => _prefManager.getStringValue(currentCompanyCode);
  // set companyCode(String? value) => _prefManager.saveString(currentCompanyCode, value ?? "");
  //
  // String? get comCODE => _prefManager.getStringValue(comCode);
  // set comCODE(String? value) => _prefManager.saveString(comCode, value ?? "");
  //
  // String? get companyCreation => _prefManager.getStringValue(currentCompanyCreation);
  //
  // set companyCreation(String? value) => _prefManager.saveString(currentCompanyCreation, value ?? "");
  //
  // void logout() => _prefManager.logOut();
  //
  // Future<bool> remove(String key) async => await _prefManager.removeKey(key);
  //
  // set setCurrentLoggedIn(CompanyRequest companyRequest) =>
  //     _prefManager.saveString(currentCompanyInfo, jsonEncode(companyRequest));
  //
  // CompanyRequest get getCurrentLoggedIn =>
  //     CompanyRequest.fromJson(jsonDecode(_prefManager.getStringValue(currentCompanyInfo)!));
  //
  // set setVerifyRequestStatus(bool verified) => _prefManager.saveBoolean(verifyRequestStatus, verified);
  // bool get getVerifyRequestStatus => _prefManager.getBoolValue(verifyRequestStatus);
  //
  // setSentVerifyRequest(String key,bool verified) => _prefManager.saveBoolean(key, verified);
  // bool getSentVerifyRequest(String key) => _prefManager.getBoolValue(key);
  //
  // set setVerifyStatus(bool verified) => _prefManager.saveBoolean(verifyStatus, verified);
  // bool get getVerifyStatus => _prefManager.getBoolValue(verifyStatus);
  //
  // bool? get isLoggedIn => _prefManager.getBoolValue(isLoggedInInfo);
  // set isLoggedIn(bool? value) => _prefManager.saveBoolean(isLoggedInInfo, value ?? false);
  //
  // bool? get isGoogle => _prefManager.getBoolValue(isGoogleInfo);
  // set isGoogle(bool? value) => _prefManager.saveBoolean(isGoogleInfo, value ?? false);
  //
  // String? get googleID => _prefManager.getStringValue(GoogleID);
  // set googleID(String? value) => _prefManager.saveString(GoogleID, value ?? "");
}