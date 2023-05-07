abstract class EventAuth {}

class getSearchSnapshotEvent extends EventAuth {
  final String name_group;
  getSearchSnapshotEvent(this.name_group);
}

class isJoinEvent extends EventAuth {
  final String groupName;
  final String groupId ;
  isJoinEvent(this.groupName , this.groupId );
}