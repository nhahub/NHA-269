import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:learnflow/Firebase/material_service.dart';
import 'package:learnflow/Widgets/Shared/text_field.dart';
import 'package:learnflow/theme/app_colors.dart';
import 'package:mime/mime.dart';

class FileUploadDialog extends StatefulWidget {
  const FileUploadDialog({super.key});

  @override
  State<FileUploadDialog> createState() => _FileUploadDialogState();
}

class _FileUploadDialogState extends State<FileUploadDialog> {
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  String? _selectedFilePath;
  String? _originalFileName;
  bool _isUploading = false;
  String? _message;
  Color _messageColor = AppColors.grey;
  String? _selectedMaterialType; // "Notes", "PDFs", or "Videos"

  final _formKey = GlobalKey<FormState>();

  void _setMessage(String text, Color color) {
    setState(() {
      _message = text;
      _messageColor = color;
    });
  }

  Future<void> _pickFile() async {
    setState(() {
      _selectedFilePath = null;
      _originalFileName = null;
      _message = null;
    });

    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
        _originalFileName = result.files.single.name;
        _fileNameController.text = _originalFileName!.contains('.')
            ? _originalFileName!.substring(0, _originalFileName!.lastIndexOf('.'))
            : _originalFileName!;
      });
      _setMessage("File selected: $_originalFileName", AppColors.teal);
    }
  }

  void _handleSuccessResponse(String responseBody) async {
    try {
      final data = jsonDecode(responseBody) as Map<String, dynamic>;
      if (data['success'] == true) {
        _setMessage('File uploaded successfully!', AppColors.teal);

        //  Save metadata to Firestore
        await MaterialService().uploadMaterial(
          name: _fileNameController.text.trim(),
          type: _selectedMaterialType!,
          subject: _subjectController.text.trim(),
          size: File(_selectedFilePath!).lengthSync(),
          link: data['fileUrl'],
        );

      } else {
        _setMessage('Upload failed: ${data['error'] ?? 'Unknown script error'}', Colors.redAccent);
      }
    } catch (e) {
      _setMessage('Failed to parse server response: $e', Colors.redAccent);
    }
  }

  Future<void> _uploadFile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedMaterialType == null) {
      _setMessage('Please select a material type.', Colors.redAccent);
      return;
    }
    if (_selectedFilePath == null) {
      _setMessage('Please select a file first.', Colors.redAccent);
      return;
    }

    final fileName = _fileNameController.text.trim();
    setState(() {
      _isUploading = true;
      _message = "Uploading, please wait...";
      _messageColor = AppColors.oceanBlue;
    });

    try {
      final file = File(_selectedFilePath!);
      final bytes = await file.readAsBytes();
      final base64File = base64Encode(bytes);

      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final extension = _originalFileName!.contains('.')
          ? _originalFileName!.substring(_originalFileName!.lastIndexOf('.'))
          : '';
      final finalFileName = '$fileName$extension';

      const String scriptUrl =
          'https://script.google.com/macros/s/AKfycbxouEILiOJ8P632jrqBtyULoFu0ylIktgf99Xw58WOWy2pNRXxtPEcN53m_YUq9-Le8/exec';
      final uri = Uri.parse(scriptUrl);

      final request = http.Request('POST', uri)
        ..headers['Content-Type'] = 'application/json; charset=UTF-8'
        ..body = jsonEncode({
          'fileName': finalFileName,
          'mimeType': mimeType,
          'fileData': base64File,
        });

      final client = http.Client();
      final response = await client.send(request);

      if (response.statusCode == 302 || response.isRedirect) {
        final redirectedUrl = response.headers['location'];
        if (redirectedUrl != null) {
          final redirectedResponse = await http.get(Uri.parse(redirectedUrl));
          _handleSuccessResponse(redirectedResponse.body);
        } else {
          _setMessage('Upload failed: Redirect location not found.', Colors.redAccent);
        }
      } else if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        _handleSuccessResponse(responseBody);
      } else {
        _setMessage('Upload failed with status code: ${response.statusCode}', Colors.redAccent);
      }
    } catch (e) {
      _setMessage('An error occurred: $e', Colors.redAccent);
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Widget _buildTypeButton(String type) {
    final isSelected = _selectedMaterialType == type;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => _selectedMaterialType = type),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.oceanBlue : AppColors.grey,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: const Text(
        'Upload a File',
        style: TextStyle(
          color: AppColors.deepSapphire,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField(
                'Enter subject',
                Icons.book_outlined,
                controller: _subjectController,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter a subject' : null,
              ),
              const SizedBox(height: 12),
              buildTextField(
                'Enter file name (without extension)',
                Icons.insert_drive_file,
                controller: _fileNameController,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter a file name' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTypeButton("Notes"),
                  const SizedBox(width: 8),
                  _buildTypeButton("PDF"),
                  const SizedBox(width: 8),
                  _buildTypeButton("Video"),
                  const SizedBox(width: 8),
                  _buildTypeButton("Image"),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepSapphire,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  _selectedFilePath == null ? 'Select File' : 'Change File',
                ),
              ),
              const SizedBox(height: 16),
              if (_message != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: _messageColor.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _messageColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.oceanBlue,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.oceanBlue,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _isUploading ? null : _uploadFile,
              child: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Upload'),
            ),
          ],
        ),
      ],
    );
  }
}
