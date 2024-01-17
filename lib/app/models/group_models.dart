class Group {
  String groupId;
  String groupCode;
  String groupName;
  String moderator;
  
  Group({
    required this.groupId,
    required this.groupCode,
    required this.groupName,
    required this.moderator,
    });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'],
      groupCode: json['groupCode'],
      groupName: json['groupName'],
      moderator: json['moderator'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupCode': groupCode,
      'groupName': groupName,
      'moderator': moderator,
      };
  }
}
 