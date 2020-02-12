import 'dart:convert';

import 'package:http_app/models/note.dart';
import 'package:http_app/models/note_for_listing.dart';
import 'package:http_app/models/note_insert.dart';
import 'package:http_app/services/api_response.dart';
import 'package:http/http.dart' as http;

class NoteService {
  static const API = 'http://api.notes.programmingaddict.com';
  static const headers = {'apiKey': '08d771e2-7c49-1789-0eaa-32aff09f1471',
  'Content-Type': 'application/json',
  };
 

  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    return http.get(API + '/notes', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for (var item in jsonData) {
          // final note = NoteForListing(
          //   noteId: item['noteID'],
          //   noteTitle: item['noteTitle'],
          //   createDateTime: DateTime.parse(item['createDateTime']),
          //   latestEditDateTime: item['latesEditDateTime'] != null
          //       ? DateTime.parse(item['latesEditDateTime'])
          //       : null,
          // );
          notes.add(NoteForListing.fromJson(item));
        }
        return APIResponse<List<NoteForListing>>(
          data: notes,
        );
      }
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: 'Error occured');
    }).catchError((_) => APIResponse<List<NoteForListing>>(
          error: true,
          errorMessage: 'Error occured',
        ));
  }

  Future<APIResponse<Note>> getNote(String noteId) {
    return http.get(API + '/notes/' + noteId, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        // final note = Note(
        //   noteId: jsonData['noteID'],
        //   noteTitle: jsonData['noteTitle'],
        //   noteContent: jsonData['noteContent'],
        //   createDateTime: DateTime.parse(jsonData['createDateTime']),
        //   latestEditDateTime: jsonData['latesEditDateTime'] != null
        //       ? DateTime.parse(jsonData['latesEditDateTime'])
        //       : null,
        // );

        return APIResponse<Note>(
          data: Note.fromJson(jsonData),
        );
      }
      return APIResponse<Note>(error: true, errorMessage: 'Error occured');
    }).catchError((_) => APIResponse<Note>(
          error: true,
          errorMessage: 'Error occured',
        ));
  }

  Future<APIResponse<bool>> createNote(NoteManipulation item) {
    return http
        .post(API + '/notes', headers: headers, body:json.encode(item.toJson()) )
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(
          data: true,
        );
      }
      return APIResponse<bool>(error: true, errorMessage: 'Error occured');
    }).catchError((_) => APIResponse<bool>(
              error: true,
              errorMessage: 'Error occured',
            ));
  }

  Future<APIResponse<bool>> updateNote(String noteid,NoteManipulation item) {
    return http
        .put(API + '/notes/'+ noteid, headers: headers, body:json.encode(item.toJson()) )
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(
          data: true,
        );
      }
      return APIResponse<bool>(error: true, errorMessage: 'Error occured');
    }).catchError((_) => APIResponse<bool>(
              error: true,
              errorMessage: 'Error occured',
            ));
  }
}
