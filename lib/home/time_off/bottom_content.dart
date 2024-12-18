import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';

class BottomContent extends StatefulWidget {
  final Function(PlatformFile?) onFileSelected;

  const BottomContent({super.key, required this.onFileSelected});

  @override
  State<BottomContent> createState() => _BottomContentState();
}

class _BottomContentState extends State<BottomContent> {
  PlatformFile? _selectedFile;
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
      widget.onFileSelected(_selectedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      borderRadius: BorderRadius.circular(0),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Attachment ',
                style: AppTextStyles.heading2_1
                    .copyWith(color: Theme.of(context).colorScheme.primary),
                children: <TextSpan>[
                  TextSpan(text: '(optional)', style: AppTextStyles.heading4),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    side: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _selectedFile?.name ?? 'Upload files',
                          style: AppTextStyles.heading2_1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
