// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:uddokta/core/utils/assets_path.dart';
//
// class SQClient {
//   final String _dbShortPath = "/bdj_corporate.sqlite";
//
//   Future<Database> initializeDB() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = documentsDirectory.path + _dbShortPath;
//     if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
//       ByteData data = await rootBundle.load(AssetsPath.DB_PATH);
//       List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//       await File(path).writeAsBytes(bytes);
//     }
//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     String databasePath = appDocDir.path + _dbShortPath;
//     return await openDatabase(databasePath);
//   }
// }
//
// enum TableIndustry { name }
// extension TableIndustryExt on TableIndustry {
//   String get value {
//     switch (this) {
//       case TableIndustry.name:
//         return 'Industries';
//       default:
//         return "";
//     }
//   }
// }
//
//
// enum TableCategory { name }
// extension TableCategoryExt on TableCategory {
//   String get value {
//     switch (this) {
//       case TableCategory.name:
//         return 'CATEGORY';
//       default:
//         return "";
//     }
//   }
// }
//
// enum TableCategoryCol { categoryId, categoryEnName, categoryBnName }
// extension TableCategoryColExt on TableCategoryCol {
//   String get value {
//     switch (this) {
//       case TableCategoryCol.categoryId:
//         return 'CAT_ID';
//       case TableCategoryCol.categoryEnName:
//         return 'CAT_NAME';
//       case TableCategoryCol.categoryBnName:
//         return 'CAT_NAME_Bangla';
//       default:
//         return "";
//     }
//   }
// }
//
// enum TableIndustryCol { industryId, industryEnName, industryBnName }
// extension TableOrgTypeColExt on TableIndustryCol {
//   String get value {
//     switch (this) {
//       case TableIndustryCol.industryId:
//         return 'IndustryId';
//       case TableIndustryCol.industryEnName:
//         return 'IndustryName';
//       case TableIndustryCol.industryBnName:
//         return 'IndustryNameBng';
//       default:
//         return "";
//     }
//   }
// }
//
// enum TableOrganization { name }
// extension TableOrganizationExt on TableOrganization {
//   String get value {
//     switch (this) {
//       case TableOrganization.name:
//         return 'OrgTypes';
//       default:
//         return "";
//     }
//   }
// }
//
// enum TableOrganizationCol {orgTypeId, orgTypeName}
// extension TableOrganizationColExt on TableOrganizationCol {
//   String get value {
//     switch (this) {
//       case TableOrganizationCol.orgTypeId:
//         return 'Org_Type_ID';
//       case TableOrganizationCol.orgTypeName:
//         return 'Org_Type_Name';
//       default:
//         return "";
//     }
//   }
// }
//
// enum TableEducationLevel {name}
// extension TableEducationExt on TableEducationLevel {
//   String get value {
//     switch(this) {
//       case TableEducationLevel.name:
//         return 'EDUCATION_LEVELS';
//       default:
//         return "";
//     }
//   }
// }
//
// enum TableEducationLevelCol {eduLevel,eduId}
// extension TableEducationLevelColExt on TableEducationLevelCol {
//   String get value {
//     switch(this) {
//       case TableEducationLevelCol.eduLevel:
//         return 'EDU_LEVEL';
//       case TableEducationLevelCol.eduId:
//         return 'EDU_ID';
//       default:
//         return "";
//     }
//   }
// }
//
// enum TableEducationDegree {name}
// extension TableEducationDegreeExt on TableEducationDegree {
//   String get value {
//     switch(this) {
//       case TableEducationDegree.name:
//         return 'educationDegrees';
//       default:
//         return "";
//     }
//   }
// }
//
// enum TableEducationDegreeCol {id,eduLevel,degreeName,educationType}
// extension TableEducationDegreeColExt on TableEducationDegreeCol {
//   String get value {
//     switch(this) {
//       case TableEducationDegreeCol.id:
//         return 'ID';
//       case TableEducationDegreeCol.eduLevel:
//         return 'EduLevel';
//       case TableEducationDegreeCol.degreeName:
//         return 'DegreeName';
//       case TableEducationDegreeCol.educationType:
//         return 'EducationType';
//       default:
//         return "";
//     }
//   }
// }
//
// enum TableJobInfo {name}
// extension TableJobInfoExt on TableJobInfo {
//   String get value {
//     switch(this) {
//       case TableJobInfo.name:
//         return 'JOB_INFO';
//       default:
//         return "";
//     }
//   }
// }
//
// enum TableJobInfoCol {jobID,jobTitle,jobVacancy,gender,employmentType,jobResponsibilities,additionInfoText,jobDeadline,minSalary,maxSalary,isNegotiable,experienceNeeded,minExp,maxExp,skills,skillIds,degreeLevel,degreeName,degreeMajorIn,applyType,applyThroughHardCopy,applyThroughWalkInInterview,applyOverPhone}
// extension TableJobInfoColExt on TableJobInfoCol {
//   String get value {
//     switch(this) {
//       case TableJobInfoCol.jobID:
//         return "jobID";
//       case TableJobInfoCol.jobTitle:
//         return "jobTitle";
//       case TableJobInfoCol.jobVacancy:
//         return "jobVacancy";
//       case TableJobInfoCol.gender:
//         return "gender";
//       case TableJobInfoCol.employmentType:
//         return "employmentType";
//       case TableJobInfoCol.jobResponsibilities:
//         return "jobResponsibilities";
//       case TableJobInfoCol.additionInfoText:
//         return "additionalInfoText";
//       case TableJobInfoCol.jobDeadline:
//         return "jobDeadline";
//       case TableJobInfoCol.minSalary:
//         return "minSalary";
//       case TableJobInfoCol.maxSalary:
//         return "maxSalary";
//       case TableJobInfoCol.isNegotiable:
//         return "isNegotiable";
//       case TableJobInfoCol.experienceNeeded:
//         return "experienceNeeded";
//       case TableJobInfoCol.minExp:
//         return "minExp";
//       case TableJobInfoCol.maxExp:
//         return "maxExp";
//       case TableJobInfoCol.skills:
//         return "skills";
//       case TableJobInfoCol.skillIds:
//         return "skillIds";
//       case TableJobInfoCol.degreeLevel:
//         return "degreeLevel";
//       case TableJobInfoCol.degreeName:
//         return "degreeName";
//       case TableJobInfoCol.degreeMajorIn:
//         return "degreeMajorIn";
//       case TableJobInfoCol.applyType:
//         return "applyType";
//       case TableJobInfoCol.applyThroughHardCopy:
//         return "applyThroughHardCopy";
//       case TableJobInfoCol.applyThroughWalkInInterview:
//         return "applyThroughWalkInInterview";
//       case TableJobInfoCol.applyOverPhone:
//         return "applyOverPhone";
//       default:
//         return "";
//     }
//   }
// }