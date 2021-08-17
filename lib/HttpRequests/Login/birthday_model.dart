 class BirthdayModel{
 final String applicationUserId;
 final String birthday;

  BirthdayModel({required this.applicationUserId, required this.birthday});

 factory BirthdayModel.fromJson(Map<String, dynamic> json){
  return BirthdayModel(
      applicationUserId: json["applicationUserId"] as String,
      birthday: json["birthday"] as String);
 }

 }