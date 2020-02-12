class NoteForListing {
  String noteId;
  String noteTitle;
  DateTime createDateTime;
  DateTime latestEditDateTime;
  NoteForListing({
    this.noteId,
    this.noteTitle,
    this.createDateTime,
    this.latestEditDateTime,
  });


  factory NoteForListing.fromJson(Map<String, dynamic> item) {
    return NoteForListing(
      noteId: item['noteID'],
      noteTitle: item['noteTitle'],
      createDateTime: DateTime.parse(item['createDateTime']),
      latestEditDateTime: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}
