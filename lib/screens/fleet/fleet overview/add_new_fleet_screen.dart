import 'package:drivers_management_app/theme/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:path/path.dart' as path;

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../components/header.dart';
import '../../../components/side_nav.dart';
import '../../../theme/app_text_field.dart';

class AddEditFleetScreen extends StatefulWidget {
  final Map<String, dynamic>? fleetData;
  final String? fleetId;

  const AddEditFleetScreen({
    super.key,
    this.fleetData,
    this.fleetId,
  });

  @override
  State<AddEditFleetScreen> createState() => _AddEditFleetScreenState();
}

class _AddEditFleetScreenState extends State<AddEditFleetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController vinController;
  late TextEditingController licensePlateController;
  late TextEditingController yearController;
  late TextEditingController groupController;
  late TextEditingController stateController;
  late TextEditingController rentalContactController;
  late TextEditingController rentalCompanyController;
  late TextEditingController addressController;
  late TextEditingController colorController;
  late TextEditingController priceController;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  File? _selectedCertificate;
  String? _certificateFileName;

  String? selectedType;
  String? selectedMake;
  String? selectedModel;
  String? selectedEngine;
  String? selectedFuelType;
  String? selectedOperator;
  String? selectedOwnership;
  String? selectedBodyType;
  String? selectedBodySubtype;
  String? selectedLinkedFleet;
  String? selectedStatus;
  String? selectedMaintenanceStatus;

  DateTime? startDate;
  DateTime? endDate;

  late TextEditingController startDateController;
  late TextEditingController endDateController;

Future<void> _saveFleetData() async {
  if (_formKey.currentState!.validate()) {
    try {
      final fleetData = {
        'name': nameController.text,
        'vin': vinController.text,
        'license': licensePlateController.text,
        'year': int.tryParse(yearController.text) ?? 0,
        'type': selectedType,
        'status': selectedStatus,
        'maintenanceStatus': selectedMaintenanceStatus,
        'createdBy': FirebaseAuth.instance.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Store data
      await FirebaseFirestore.instance.collection('fleets').add(fleetData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fleet added successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}



  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickCertificate() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedCertificate = File(result.files.single.path!);
          _certificateFileName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error selecting certificate')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if available
    nameController =
        TextEditingController(text: widget.fleetData?['name'] ?? '');
    vinController = TextEditingController(text: widget.fleetData?['vin'] ?? '');
    licensePlateController =
        TextEditingController(text: widget.fleetData?['license'] ?? '');
    yearController = TextEditingController(
        text: widget.fleetData?['year']?.toString() ?? '');
    groupController =
        TextEditingController(text: widget.fleetData?['group'] ?? '');
    stateController =
        TextEditingController(text: widget.fleetData?['state'] ?? '');
    rentalContactController =
        TextEditingController(text: widget.fleetData?['rentalContact'] ?? '');
    rentalCompanyController =
        TextEditingController(text: widget.fleetData?['rentalCompany'] ?? '');
    addressController =
        TextEditingController(text: widget.fleetData?['address'] ?? '');
    colorController =
        TextEditingController(text: widget.fleetData?['color'] ?? '');
    priceController = TextEditingController(
        text: widget.fleetData?['price']?.toString() ?? '');

    // Initialize dropdown values
    selectedType = widget.fleetData?['type'];
    selectedMake = widget.fleetData?['make'];
    selectedModel = widget.fleetData?['model'];
    selectedEngine = widget.fleetData?['engine'];
    selectedFuelType = widget.fleetData?['fuelType'];
    selectedOperator = widget.fleetData?['operator'];
    selectedOwnership = widget.fleetData?['ownership'];
    selectedBodyType = widget.fleetData?['bodyType'];
    selectedBodySubtype = widget.fleetData?['bodySubtype'];
    selectedLinkedFleet = widget.fleetData?['linkedFleet'];
    selectedStatus = widget.fleetData?['status'] ?? 'No Status';
    startDate = widget.fleetData?['startDate']?.toDate();
    endDate = widget.fleetData?['endDate']?.toDate();
    selectedMaintenanceStatus =
        widget.fleetData?['maintenanceStatus'] ?? 'Up-to-date';

    startDateController = TextEditingController(
        text: startDate != null ? _formatDate(startDate!) : '');
    endDateController = TextEditingController(
        text: endDate != null ? _formatDate(endDate!) : '');
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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
                            'New Fleet',
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
                                horizontal: 16, vertical: 24),
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
                                  'Add New Fleet',
                                  style: GoogleFonts.spectral(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    height: 1.54,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Identification',
                                  style: GoogleFonts.spectral(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      height: 1.54,
                                      color: Colors.black),
                                ),
                                Text(
                                  'Add Vehicle Picture',
                                  style: GoogleFonts.spectral(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (_selectedImage != null)
                                  Center(
                                    child: Image.file(
                                      _selectedImage!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Center(
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        text: 'Take Picture',
                                        variant: ButtonVariant.primary,
                                        isFullWidth: false,
                                        size: ButtonSize.medium,
                                        onPressed: _takePicture,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: AppButton(
                                        text: 'Upload Picture',
                                        variant: ButtonVariant.primary,
                                        isFullWidth: false,
                                        size: ButtonSize.medium,
                                        onPressed: _uploadPicture,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: nameController,
                                  label: 'Fleet Name',
                                  hintText: 'Name',
                                  isRequired: true,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a fleet name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Status',
                                  isRequired: true,
                                  items: [
                                    'Active',
                                    'Break',
                                    'Unavailable',
                                    'No Status'
                                  ],
                                  value: selectedStatus,
                                  onChanged: (value) =>
                                      setState(() => selectedStatus = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a status';
                                    }
                                    return null;
                                  },
                                  hintText: 'Select Status',
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Maintenance Status',
                                  isRequired: true,
                                  items: [
                                    'Up-to-date',
                                    'Due for Maintenance',
                                    'Under Maintenance',
                                    'Maintenance Scheduled'
                                  ],
                                  value: selectedMaintenanceStatus,
                                  onChanged: (value) => setState(
                                      () => selectedMaintenanceStatus = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select maintenance status';
                                    }
                                    return null;
                                  },
                                  hintText: '',
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: vinController,
                                  label: 'VIN / SN',
                                  hintText: '',
                                  isRequired: false,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: licensePlateController,
                                  label: 'License Plate',
                                  hintText: '',
                                  isRequired: false,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Type',
                                  isRequired: true,
                                  items: ['Truck', 'Car', 'Van', 'SUV'],
                                  value: selectedType,
                                  onChanged: (value) =>
                                      setState(() => selectedType = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a type';
                                    }
                                    return null;
                                  },
                                  hintText: '',
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: yearController,
                                  label: 'Year',
                                  hintText: '',
                                  isRequired: false,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Make',
                                  isRequired: true,
                                  items: [
                                    'Value 1',
                                    'Value 2',
                                    'Value 3',
                                    'Value 4'
                                  ],
                                  value: selectedMake,
                                  onChanged: (value) =>
                                      setState(() => selectedMake = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a make';
                                    }
                                    return null;
                                  },
                                  hintText: 'Select Make',
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Model',
                                  isRequired: true,
                                  items: [
                                    'Value 1',
                                    'Value 2',
                                    'Value 3',
                                    'Value 4'
                                  ],
                                  value: selectedModel,
                                  onChanged: (value) =>
                                      setState(() => selectedModel = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a model';
                                    }
                                    return null;
                                  },
                                  hintText: 'Select Model',
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Engine',
                                  isRequired: true,
                                  items: [
                                    'Gasoline Engine',
                                    'Diesel Engine',
                                    'Rotary Engine',
                                    'Parallel Hybrid',
                                    'Series Hybrid',
                                    'Plug-In Hybrid',
                                    'Battery Electric',
                                    'Extended Range Electric',
                                    'Fuel Cell Electric',
                                  ],
                                  value: selectedEngine,
                                  onChanged: (value) =>
                                      setState(() => selectedEngine = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a an engine';
                                    }
                                    return null;
                                  },
                                  hintText: 'Select Engine',
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Fuel',
                                  isRequired: true,
                                  items: [
                                    'Gasoline',
                                    'Diesel',
                                    'Ethanol',
                                    'CNG',
                                    'LPG',
                                    'Hydrogen',
                                    'Propane',
                                    'Battery',
                                    'Solar',
                                    'Fuel Cell',
                                  ],
                                  value: selectedFuelType,
                                  onChanged: (value) =>
                                      setState(() => selectedFuelType = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a fuel type';
                                    }
                                    return null;
                                  },
                                  hintText: 'Select Fuel',
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: stateController,
                                  label: 'Registration State Province',
                                  hintText: 'Enter State',
                                  isRequired: false,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: groupController,
                                  label: 'Group',
                                  hintText: '',
                                  isRequired: true,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Operator',
                                  isRequired: false,
                                  items: ['Operator 1', 'Operator 2'],
                                  value: selectedOperator,
                                  onChanged: (value) =>
                                      setState(() => selectedOperator = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select an Operator';
                                    }
                                    return null;
                                  },
                                  hintText: 'Select Operator',
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Ownership',
                                  isRequired: true,
                                  items: ['Owned', 'Not Owned'],
                                  value: selectedOwnership,
                                  onChanged: (value) =>
                                      setState(() => selectedOwnership = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select ownership status';
                                    }
                                    return null;
                                  },
                                  hintText: 'Select Ownership Status',
                                ),
                                const SizedBox(height: 16),
                                _buildCertificateUpload(),
                                const SizedBox(height: 16),
                                Text(
                                  'Rent Fleet',
                                  style: GoogleFonts.spectral(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      height: 1.54,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: rentalContactController,
                                  label: 'Rental Contact Number',
                                  hintText: 'Phone Number',
                                  isRequired: false,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: rentalCompanyController,
                                  label: 'Rental Company',
                                  hintText: 'Name Here',
                                  isRequired: false,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 16),
                                AppDateField(
                                  controller: startDateController,
                                  label: 'Start Date',
                                  hintText: 'Select Date',
                                  isRequired: false,
                                  onDateSelected: (date) {
                                    setState(() => startDate = date);
                                  },
                                ),
                                const SizedBox(height: 16),
                                AppDateField(
                                  controller: endDateController,
                                  label: 'End Date',
                                  hintText: 'Select Date',
                                  isRequired: false,
                                  initialDate:
                                      startDate?.add(const Duration(days: 1)) ??
                                          DateTime.now(),
                                  firstDate:
                                      startDate?.add(const Duration(days: 1)),
                                  onDateSelected: (date) {
                                    setState(() => endDate = date);
                                  },
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: addressController,
                                  label: 'Rental Company Address',
                                  hintText: 'Address',
                                  isRequired: false,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Additional Details',
                                  style: GoogleFonts.spectral(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      height: 1.54,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: colorController,
                                  label: 'Color',
                                  hintText: '',
                                  isRequired: false,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Body Type',
                                  isRequired: false,
                                  items: ['Value 1', 'Value 2'],
                                  value: selectedBodyType,
                                  onChanged: (value) =>
                                      setState(() => selectedBodyType = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select body type';
                                    }
                                    return null;
                                  },
                                  hintText: 'Select Body Type',
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Body Subtype',
                                  isRequired: false,
                                  items: ['Value 1', 'Value 2'],
                                  value: selectedBodySubtype,
                                  onChanged: (value) => setState(
                                      () => selectedBodySubtype = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select body subtype';
                                    }
                                    return null;
                                  },
                                  hintText: 'Select Body subtype',
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: priceController,
                                  label: 'Total Estimated Price',
                                  hintText: '',
                                  isRequired: false,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                                AppDropdownField<String>(
                                  label: 'Linked Fleets',
                                  isRequired: false,
                                  items: ['Value 1', 'Value 2'],
                                  value: selectedLinkedFleet,
                                  onChanged: (value) => setState(
                                      () => selectedLinkedFleet = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select fleet';
                                    }
                                    return null;
                                  },
                                  hintText: 'Please select fleet',
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
                    onPressed: _saveFleet,
                    child: Text(
                      widget.fleetId != null ? 'Update Fleet' : 'Add Fleet',
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

  void _saveFleet() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        String? imageUrl;

        // Upload image if one is selected
        if (_selectedImage != null) {
          // Create a unique file name
          final String fileName =
              'fleet_images/${DateTime.now().millisecondsSinceEpoch}${path.extension(_selectedImage!.path)}';
          final Reference ref = FirebaseStorage.instance.ref().child(fileName);

          try {
            // Upload the file
            await ref.putFile(_selectedImage!);
            // Get the download URL
            imageUrl = await ref.getDownloadURL();
          } catch (e) {
            if (mounted) {
              Navigator.pop(context); // Dismiss loading indicator
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error uploading image. Please try again.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }
        }

        // Get the current highest fleet ID
        final QuerySnapshot fleetQuery = await FirebaseFirestore.instance
            .collection('fleets')
            .orderBy('fleetId', descending: true)
            .limit(1)
            .get();

        // Calculate the next fleet ID
        int nextFleetId = 1001;
        if (fleetQuery.docs.isNotEmpty) {
          final highestId = fleetQuery.docs.first.get('fleetId') as int;
          nextFleetId = highestId + 1;
        }

        String? certificateUrl;
        if (_selectedCertificate != null) {
          final String fileName =
              'certificates/${DateTime.now().millisecondsSinceEpoch}_$_certificateFileName';
          final Reference storageRef =
              FirebaseStorage.instance.ref().child(fileName);
          await storageRef.putFile(_selectedCertificate!);
          certificateUrl = await storageRef.getDownloadURL();
        }

        final fleetData = {
          'fleetId': nextFleetId,
          'imageUrl': imageUrl,
          'name': nameController.text,
          'vin': vinController.text,
          'license': licensePlateController.text,
          'type': selectedType,
          'year': int.tryParse(yearController.text),
          'make': selectedMake,
          'model': selectedModel,
          'engine': selectedEngine,
          'fuelType': selectedFuelType,
          'state': stateController.text,
          'group': groupController.text,
          'operator': selectedOperator,
          'ownership': selectedOwnership,
          'rentalContact': rentalContactController.text,
          'rentalCompany': rentalCompanyController.text,
          'startDate':
              startDate != null ? Timestamp.fromDate(startDate!) : null,
          'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
          'address': addressController.text,
          'color': colorController.text,
          'bodyType': selectedBodyType,
          'bodySubtype': selectedBodySubtype,
          'linkedFleet': selectedLinkedFleet,
          'price': double.tryParse(priceController.text),
          'status': selectedStatus ?? 'No Status',
          'createdAt': FieldValue.serverTimestamp(),
          'certificateUrl': certificateUrl,
          'certificateFileName': _certificateFileName,
          'maintenanceStatus': selectedMaintenanceStatus ?? 'Up-to-date',
        };

        if (widget.fleetId != null) {
          await FirebaseFirestore.instance
              .collection('fleets')
              .doc(widget.fleetId)
              .update(fleetData);
        } else {
          await FirebaseFirestore.instance
              .collection('fleets')
              .add(fleetData);
        }

        if (mounted) {
          Navigator.pop(context); // Dismiss loading indicator
          Navigator.pop(context); // Return to previous screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.fleetId != null
                  ? 'Fleet updated successfully'
                  : 'Fleet added successfully'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Dismiss loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error saving fleet'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildCertificateUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Certification',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(102, 112, 133, 1),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color.fromRGBO(208, 213, 221, 1),
            ),
          ),
          child: Column(
            children: [
              if (_selectedCertificate != null) ...[
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/pdf.svg',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _certificateFileName ?? 'Selected Certificate',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: const Color.fromRGBO(102, 112, 133, 1),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() {
                        _selectedCertificate = null;
                        _certificateFileName = null;
                      }),
                    ),
                  ],
                ),
              ] else
                Center(
                  child: Expanded(
                    child: AppButton(
                      text: 'Upload Certificate',
                      variant: ButtonVariant.secondary,
                      isFullWidth: false,
                      size: ButtonSize.medium,
                      onPressed: _pickCertificate,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    vinController.dispose();
    licensePlateController.dispose();
    yearController.dispose();
    groupController.dispose();
    stateController.dispose();
    rentalContactController.dispose();
    rentalCompanyController.dispose();
    addressController.dispose();
    colorController.dispose();
    priceController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
