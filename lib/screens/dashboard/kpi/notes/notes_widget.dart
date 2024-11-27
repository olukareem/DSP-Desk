import 'package:drivers_management_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../theme/buttons.dart';

class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  List<Note> _notes = [];
  int? _editingIndex;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedSection = 'Fleet';
  final List<String> _sections = [
    'Fleet',
    'Drivers',
    'Routes',
    'Opening Notes',
    'Closing Notes'
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notesJson = prefs.getString('notes');
    if (notesJson != null) {
      List<dynamic> notesList = jsonDecode(notesJson);
      setState(() {
        _notes = notesList.map((e) => Note.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String notesJson = jsonEncode(_notes.map((e) => e.toJson()).toList());
    await prefs.setString('notes', notesJson);
  }

  Note? _viewingNote;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionTabs(),
        const SizedBox(height: 16),
        if (_editingIndex != null)
          _buildNoteEditor()
        else if (_viewingNote != null)
          _buildNoteDetail(_viewingNote!)
        else
          _buildNotesList(),
        if (_editingIndex == null && _viewingNote == null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              text: 'Add New Notes',
              onPressed: () {
                setState(() {
                  _editingIndex = _notes.length;
                  _titleController.clear();
                  _contentController.clear();
                });
              },
              isFullWidth: true,
              size: ButtonSize.large,
              variant: ButtonVariant.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTabs() {
    return SizedBox(
      height: 46,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _sections.map((section) {
              final isSelected = _selectedSection == section;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSection = section;
                    // Reset viewing and editing states when changing sections
                    _viewingNote = null;
                    _editingIndex = null;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Text(
                    section,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color:
                          isSelected ? AppTheme.primaryBlue : Colors.grey[600],
                      height: 1.57,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    final filteredNotes =
        _notes.where((note) => note.section == _selectedSection).toList();

    return Expanded(
      child: ListView.separated(
        itemCount: filteredNotes.length,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFEAECF0),
        ),
        itemBuilder: (context, index) {
          final note = filteredNotes[index];
          return Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  _viewingNote = note;
                });
              },
              highlightColor: const Color.fromRGBO(247, 247, 247, 1),
              hoverColor: const Color.fromRGBO(247, 247, 247, 1),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C4A97),
                            ),
                          ),
                          const SizedBox(height: 4),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return SizedBox(
                                width: constraints.maxWidth - 48,
                                child: Text(
                                  note.content,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF667085),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              offset: const Offset(0, 24),
                              child: const Icon(
                                Icons.more_vert,
                                color: Color(0xFF828282),
                                size: 20,
                              ),
                              onSelected: (value) {
                                if (value == 'Edit') {
                                  setState(() {
                                    _editingIndex = _notes.indexOf(note);
                                    _titleController.text = note.title;
                                    _contentController.text = note.content;
                                  });
                                } else if (value == 'Delete') {
                                  setState(() {
                                    _notes.remove(note);
                                    _saveNotes();
                                  });
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'Edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'Delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd MMM').format(note.dateTime),
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF667085),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoteDetail(Note note) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            height: 373,
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F7F7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
              ),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 50, // Space for the date/time
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 209,
                        child: Text(
                          note.title,
                          style: const TextStyle(
                            fontFamily: 'Spectral',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'by ${note.author}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.67,
                          color: Color(0xFFA1A2A3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        note.content,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.71,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(note.dateTime),
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.83,
                            color: Color(0xFFA1A2A3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMM yyyy').format(note.dateTime),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.83,
                            color: Color(0xFFA1A2A3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteEditor() {
    return Expanded(
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _contentController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(
                text: 'Cancel',
                onPressed: () {
                  setState(() {
                    _editingIndex = null;
                    _titleController.clear();
                    _contentController.clear();
                  });
                },
                variant: ButtonVariant.outline,
                size: ButtonSize.medium,
              ),
              AppButton(
                text: 'Submit',
                onPressed: () {
                  if (_editingIndex != null) {
                    setState(() {
                      if (_editingIndex == _notes.length) {
                        _notes.add(Note(
                          title: _titleController.text,
                          author:
                              'Author Name', // Placeholder; adjust as needed
                          dateTime: DateTime.now(),
                          section: _selectedSection,
                          content: _contentController.text,
                        ));
                      } else {
                        _notes[_editingIndex!] = Note(
                          title: _titleController.text,
                          author: _notes[_editingIndex!].author,
                          dateTime: _notes[_editingIndex!].dateTime,
                          section: _selectedSection,
                          content: _contentController.text,
                        );
                      }
                      _editingIndex = null;
                      _saveNotes();
                    });
                  }
                },
                variant: ButtonVariant.outline,
                size: ButtonSize.medium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Note {
  String title;
  String author;
  DateTime dateTime;
  String section;
  String content;

  Note({
    required this.title,
    required this.author,
    required this.dateTime,
    required this.section,
    required this.content,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      author: json['author'],
      dateTime: DateTime.parse(json['dateTime']),
      section: json['section'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'dateTime': dateTime.toIso8601String(),
      'section': section,
      'content': content,
    };
  }
}
