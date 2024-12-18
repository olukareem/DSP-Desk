import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/header.dart';
import '../../../components/side_nav.dart';
import '../../../theme/app_text_field.dart';

class AssignmentData {
  final String date;
  final String name;
  final String status;

  AssignmentData({
    required this.date,
    required this.name,
    required this.status,
  });
}

class MaintenanceData {
  final String date;
  final String maintenance;
  final String cost;

  MaintenanceData({
    required this.date,
    required this.maintenance,
    required this.cost,
  });
}

class FleetDetailsScreen extends StatefulWidget {
  final String fleetId;
  final Map<String, dynamic> fleetData;

  const FleetDetailsScreen({
    super.key,
    required this.fleetId,
    required this.fleetData,
  });

  @override
  State<FleetDetailsScreen> createState() => _FleetDetailsScreenState();
}

class _FleetDetailsScreenState extends State<FleetDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController commentsController;
  late TextEditingController safetyFeaturesController;
  late TextEditingController actionTakenController;

  @override
  void initState() {
    super.initState();
    commentsController =
        TextEditingController(text: widget.fleetData['comments'] ?? '');
    safetyFeaturesController =
        TextEditingController(text: widget.fleetData['safetyFeatures'] ?? '');
    actionTakenController =
        TextEditingController(text: widget.fleetData['actionTaken'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 250, 252, 1),
      appBar: Header(),
      drawer: SideNav(),
      body: Container(
        color: const Color.fromRGBO(249, 250, 252, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 32, right: 16, top: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Fleet Overview',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 22 / 14,
                                color: const Color.fromRGBO(102, 112, 133, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '/',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(102, 112, 133, 1),
                              ),
                            ),
                          ),
                          Text(
                            'Fleet Details',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 22 / 14,
                              color: const Color.fromRGBO(33, 36, 41, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Form(
                        key: _formKey,
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 350),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 24,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                              ),
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black.withOpacity(0.12),
                                  width: 1,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                  color: const Color(0x10101828),
                                ),
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 3,
                                  color: const Color(0x1A101828),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fleet Details',
                                  style: GoogleFonts.spectral(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    height: 1.54,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                if (widget.fleetData['imageUrl'] != null)
                                  Center(
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              widget.fleetData['imageUrl']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Center(
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            249, 250, 252, 1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              208, 213, 221, 1),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 48,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'No image available',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 24),
                                _buildDetailItem('Fleet ID',
                                    'Fleet #${widget.fleetData['fleetId'].toString()}'),
                                _buildDetailItem(
                                    'Fleet Name', widget.fleetData['name']),
                                _buildDetailItem(
                                    'Fleet Type', widget.fleetData['type']),
                                _buildDetailItem('License Plate',
                                    widget.fleetData['license']),
                                _buildDetailItem(
                                    'Model', widget.fleetData['model']),
                                _buildDetailItem('Status',
                                    widget.fleetData['status'] ?? 'No Status'),
                                _buildDetailItem(
                                    'Maintenance Status',
                                    widget.fleetData['maintenanceStatus'] ??
                                        'Up-to-date'),
                                const SizedBox(height: 24),
                                Text(
                                  'Technical Specifications',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.54,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildSpecItem(
                                    'Engine', widget.fleetData['engine']),
                                _buildSpecItem(
                                    'Fuel Type', widget.fleetData['fuelType']),
                                _buildSpecItem('Year Of Manufacture',
                                    widget.fleetData['year']?.toString()),
                                _buildSpecItem('Vin', widget.fleetData['vin']),
                                _buildSpecItem('Mileage', widget.fleetData['']),
                                _buildSpecItem('HP', widget.fleetData['']),
                                AppTextField(
                                  controller: commentsController,
                                  label: 'Notes And Comments',
                                  labelSize: 14,
                                  hintText: 'Enter comments',
                                  maxLines: 4,
                                  labelColor:
                                      const Color.fromRGBO(33, 36, 41, 1),
                                  textColor:
                                      const Color.fromRGBO(33, 36, 41, 1),
                                ),
                                _buildCertificateSection(),
                                const SizedBox(height: 24),
                                AppTextField(
                                  controller: safetyFeaturesController,
                                  label: 'Safety Features Installed',
                                  labelSize: 14,
                                  hintText: 'Enter safety features',
                                  maxLines: 4,
                                  labelColor:
                                      const Color.fromRGBO(33, 36, 41, 1),
                                  textColor:
                                      const Color.fromRGBO(33, 36, 41, 1),
                                ),
                                const SizedBox(height: 24),
                                AppTextField(
                                  controller: actionTakenController,
                                  label: 'Action Taken',
                                  labelSize: 14,
                                  hintText: 'Enter actions taken',
                                  maxLines: 4,
                                  labelColor:
                                      const Color.fromRGBO(33, 36, 41, 1),
                                  textColor:
                                      const Color.fromRGBO(33, 36, 41, 1),
                                ),
                                const SizedBox(height: 24),
                                _buildAssignmentTable(),
                                const SizedBox(height: 24),
                                _buildMaintenanceTable(),
                                const SizedBox(height: 24),
                                Text(
                                  'Fleet Location',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.54,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 350),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: const Color(0xFF101828),
                    ),
                    onPressed: _saveChanges,
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(102, 112, 133, 1),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value ?? 'Not specified',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.5,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(102, 112, 133, 1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value ?? 'Not specified',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCertificateSection() {
    if (widget.fleetData['certificateUrl'] == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Certification',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.54,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            final url = widget.fleetData['certificateUrl'];
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromRGBO(208, 213, 221, 1),
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/pdf.svg',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.fleetData['certificateFileName'] ??
                        'Certificate.pdf',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: const Color.fromRGBO(102, 112, 133, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAssignmentTable() {
    final assignments = [
      AssignmentData(date: '22/04/23', name: 'Delivery', status: 'Complete'),
      AssignmentData(date: '22/04/23', name: 'Delivery', status: 'Complete'),
      AssignmentData(date: '22/04/23', name: 'Delivery', status: 'Complete'),
      AssignmentData(date: '22/04/23', name: 'Delivery', status: 'Complete'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Assignments',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Table(
          border: TableBorder.all(
            color: const Color.fromRGBO(234, 236, 240, 1),
            width: 1,
          ),
          children: [
            // Header Row
            TableRow(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(249, 250, 251, 1),
              ),
              children: [
                _buildTableHeaderCell('Date'),
                _buildTableHeaderCell('Assignment Name'),
                _buildTableHeaderCell('Statuses'),
              ],
            ),
            // Data Rows
            ...assignments
                .map((assignment) => TableRow(
                      children: [
                        _buildTableCell(assignment.date),
                        _buildTableCell(assignment.name),
                        _buildTableCell(assignment.status),
                      ],
                    ))
                ,
          ],
        ),
      ],
    );
  }

  Widget _buildMaintenanceTable() {
    final maintenanceRecords = [
      MaintenanceData(
          date: '22/04/23', maintenance: 'Replace left rotr', cost: '30 \$'),
      MaintenanceData(
          date: '22/04/23', maintenance: 'Replace left rotr', cost: '30 \$'),
      MaintenanceData(
          date: '22/04/23', maintenance: 'Replace left rotr', cost: '30 \$'),
      MaintenanceData(
          date: '22/04/23', maintenance: 'Replace left rotr', cost: '30 \$'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maintenance Details',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Table(
          border: TableBorder.all(
            color: const Color.fromRGBO(234, 236, 240, 1),
            width: 1,
          ),
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(249, 250, 251, 1),
              ),
              children: [
                _buildTableHeaderCell('Date'),
                _buildTableHeaderCell('Maintenance Performed'),
                _buildTableHeaderCell('Cost'),
              ],
            ),
            ...maintenanceRecords
                .map((record) => TableRow(
                      children: [
                        _buildTableCell(record.date),
                        _buildTableCell(record.maintenance),
                        _buildTableCell(record.cost),
                      ],
                    ))
                ,
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(102, 112, 133, 1),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color.fromRGBO(102, 112, 133, 1),
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('fleets')
          .doc(widget.fleetId)
          .update({
        'comments': commentsController.text,
        'safetyFeatures': safetyFeaturesController.text,
        'actionTaken': actionTakenController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving changes'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    commentsController.dispose();
    safetyFeaturesController.dispose();
    actionTakenController.dispose();
    super.dispose();
  }
}
