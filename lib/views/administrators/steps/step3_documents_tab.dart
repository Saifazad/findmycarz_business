import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/admin_card_wrapper.dart';
import '../components/document_upload_box.dart';
import '../modals/upload_source_modal.dart';

class Step3DocumentsTab extends StatelessWidget {
  final bool aadharUploaded;
  final String? aadharUrl;
  final String? aadharPath;
  final void Function(String filePath) onAadharPicked;

  final bool panUploaded;
  final String? panUrl;
  final String? panPath;
  final void Function(String filePath) onPanPicked;

  final bool passbookUploaded;
  final String? passbookUrl;
  final String? passbookPath;
  final void Function(String filePath) onPassbookPicked;

  final List<String> extraDocuments;
  final VoidCallback onAddExtraDocument;
  final void Function(String doc) onRemoveExtraDocument;

  const Step3DocumentsTab({
    super.key,
    required this.aadharUploaded,
    this.aadharUrl,
    this.aadharPath,
    required this.onAadharPicked,
    required this.panUploaded,
    this.panUrl,
    this.panPath,
    required this.onPanPicked,
    required this.passbookUploaded,
    this.passbookUrl,
    this.passbookPath,
    required this.onPassbookPicked,
    required this.extraDocuments,
    required this.onAddExtraDocument,
    required this.onRemoveExtraDocument,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AdminCardWrapper(
            title: "Required Documents",
            subtitle: "Government ID proofs and KYC records",
            children: [
              DocumentUploadBox(
                label: "Aadhar Card",
                isUploaded: aadharUploaded,
                remoteUrl: aadharUrl,
                localPath: aadharPath,
                onSelectOrReplace: () => UploadSourceModal.show(
                  context: context,
                  docType: "Aadhar Card",
                  onFilePicked: onAadharPicked,
                ),
              ),
              const SizedBox(height: 12),
              DocumentUploadBox(
                label: "PAN Card",
                isUploaded: panUploaded,
                remoteUrl: panUrl,
                localPath: panPath,
                onSelectOrReplace: () => UploadSourceModal.show(
                  context: context,
                  docType: "PAN Card",
                  onFilePicked: onPanPicked,
                ),
              ),
              const SizedBox(height: 12),
              DocumentUploadBox(
                label: "Bank Passbook",
                isUploaded: passbookUploaded,
                remoteUrl: passbookUrl,
                localPath: passbookPath,
                onSelectOrReplace: () => UploadSourceModal.show(
                  context: context,
                  docType: "Bank Passbook",
                  onFilePicked: onPassbookPicked,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Additional Documents
          AdminCardWrapper(
            title: "Additional Documents",
            subtitle: "Upload extra verification certificates",
            children: [
              ...extraDocuments.map((doc) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined,
                        color: Color(0xFF003366)),
                    title: Text(doc,
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 20),
                      onPressed: () => onRemoveExtraDocument(doc),
                    ),
                  )),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: onAddExtraDocument,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF003366)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  "+ Add More",
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
