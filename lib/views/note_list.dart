import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http_app/models/note_for_listing.dart';
import 'package:http_app/services/api_response.dart';
import 'package:http_app/services/notes_services.dart';
import 'package:http_app/views/note.modify.dart';
import 'package:http_app/views/note_delete.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteService get service => GetIt.I<NoteService>();
  APIResponse<List<NoteForListing>> _apiResponse;
  bool isLoading = false;

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      isLoading = false;
    });
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NoteModify()))
              .then((data) {
            _fetchNotes();
          });
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
      body: Builder(builder: (_) {
        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (_apiResponse.error) {
          return Center(
            child: Text(_apiResponse.errorMessage),
          );
        }

        return ListView.separated(
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: Colors.green,
          ),
          itemBuilder: (_, index) {
            return Dismissible(
              key: ValueKey(_apiResponse.data[index].noteId),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {},
              confirmDismiss: (direction) async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => NoteDelete(),
                );
                return result;
              },
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.only(left: 16),
                child: Align(
                  child: Icon(Icons.delete, color: Colors.white),
                  alignment: Alignment.centerLeft,
                ),
              ),
              child: ListTile(
                title: Text(
                  _apiResponse.data[index].noteTitle,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                subtitle: Text(
                    'Last edited on ${formatDateTime(_apiResponse.data[index].latestEditDateTime ?? _apiResponse.data[index].createDateTime)} '),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (_) => NoteModify(
                              noteId: _apiResponse.data[index].noteId)))
                      .then((value) {
                    _fetchNotes();
                  });
                },
              ),
            );
          },
          itemCount: _apiResponse.data.length,
        );
      }),
    );
  }
}
