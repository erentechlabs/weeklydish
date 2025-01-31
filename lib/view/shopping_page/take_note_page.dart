import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:weeklydish/controller/shopping_controller.dart';
import 'package:weeklydish/database/app_database.dart';
import 'package:weeklydish/view/custom_ui/success_snackbar_dialog.dart';
import '../../theme/theme.dart';
import '../custom_ui/warning_snackbar_dialog.dart';

class TakeNotePage extends StatefulWidget {
  final int? noteId;
  final String? noteTitle;
  final String? noteBody;

  const TakeNotePage({super.key, this.noteId, this.noteTitle, this.noteBody});

  @override
  State<TakeNotePage> createState() => _TakeNotePageState();
}

class _TakeNotePageState extends State<TakeNotePage> {
  // Shopping controller
  late ShoppingController shoppingController;

  // Text controller for the title
  final TextEditingController titleController = TextEditingController();

  // Quill controller for the note
  late QuillController bodyController;

  @override
  void initState() {
    // Call the super class
    super.initState();

    // Initialize the shopping controller
    shoppingController = ShoppingController(AppDatabase());

    // Initialize the controllers with existing note data if provided
    if (widget.noteTitle != null) {
      titleController.text = widget.noteTitle!;
    }

    if (widget.noteBody != null) {
      var documentJson = jsonDecode(widget.noteBody!);
      var document = Document.fromJson(documentJson);
      bodyController = QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0));
    } else {
      bodyController = QuillController.basic();
    }
  }

  // Disposing the controller
  @override
  void dispose() {
    // Dispose the title controller
    titleController.dispose();

    // Dispose the Quill controller
    bodyController.dispose();

    // Call the super class
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Prevent the user from going back with gesture. for going back, user must press the back button
    return PopScope(
      canPop: false,
      child: Scaffold(
        // App bar also contains the title of the note
        appBar: AppBar(
          // Title of the note
          title: TextField(
            controller: titleController,
            maxLines: 1,
            textAlign: TextAlign.start,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),

            // Decoration for the title
            decoration: InputDecoration(
              hintText: 'enterTitle'.tr(),
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            ),
          ),
          centerTitle: true,

          // Leading icon button to navigate back and save the note
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              // Check if the widget is still mounted
              if (!mounted) return;

              // Check if both the title and the body are empty
              if (titleController.text.trim().isEmpty &&
                  !bodyController.document.isEmpty()) {
                // Show a warning to the user if both the title and the body are empty
                showWarningSnackbarDialog(context, 'titlecannotBeEmpty'.tr());

                return;
              }

              // Check if both the title and the body are not empty
              if (titleController.text.trim().isNotEmpty &&
                  bodyController.document.toString().trim().isNotEmpty) {
                // Save or update the note
                if (widget.noteId != null) {
                  // Update the existing note
                  await shoppingController.updateShoppingItem(
                      widget.noteId!,
                      titleController.text.trim(),
                      jsonEncode(bodyController.document.toDelta().toJson()),
                      false);
                } else {
                  // Save the new note
                  await shoppingController.insertShoppingItem(
                    titleController.text.trim(),
                    jsonEncode(bodyController.document.toDelta().toJson()),
                    false,
                  );
                }

                // Show a success message
                showSuccessSnackbarDialog(
                    context, 'noteSavedSuccessfully'.tr());
              }

              // Pop the page and pass a result to the previous screen
              Navigator.pop(context, true);
            },
          ),
        ),

        // Note body
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Toolbar for the note
              QuillSimpleToolbar(
                controller: bodyController,
                configurations: const QuillSimpleToolbarConfigurations(
                  showAlignmentButtons: true,
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showStrikeThrough: false,
                  showColorButton: true,
                  showBackgroundColorButton: false,
                  showClearFormat: false,
                  showHeaderStyle: false,
                  showListNumbers: false,
                  showListBullets: false,
                  showCodeBlock: false,
                  showQuote: false,
                  showLink: false,
                  showCenterAlignment: false,
                  showClipboardCopy: false,
                  showClipboardCut: false,
                  showClipboardPaste: false,
                  showDirection: false,
                  showDividers: false,
                  showFontFamily: false,
                  showFontSize: true,
                  showIndent: false,
                  showInlineCode: false,
                  showJustifyAlignment: false,
                  showLeftAlignment: false,
                  showLineHeightButton: false,
                  showListCheck: true,
                  showRedo: false,
                  showRightAlignment: false,
                  showSearchButton: false,
                  showSmallButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showUndo: false,
                ),
              ),

              // Take note area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: MaterialTheme.getContainerColor(
                          Theme.of(context).brightness),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                    ),

                    // Quill editor for the note
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: QuillEditor.basic(
                          controller: bodyController,
                          configurations: QuillEditorConfigurations(
                            showCursor: true,
                            padding: const EdgeInsets.all(8.0),
                            placeholder: 'enterYourNoteHere'.tr(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
