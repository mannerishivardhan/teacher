// Backend-ready data models for Admission Report

class AdmissionReportFilter {
  final String? year;
  final String? course;
  final String? branch;
  final String? section;
  final String? rollNo;
  final DateTime? admissionDate;
  final String? gender;
  final String? seatType;
  final String? caste;

  AdmissionReportFilter({
    this.year,
    this.course,
    this.branch,
    this.section,
    this.rollNo,
    this.admissionDate,
    this.gender,
    this.seatType,
    this.caste,
  });

  // Convert filter to query parameters for API request
  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};
    
    if (year != null && year!.isNotEmpty) params['year'] = year;
    if (course != null && course!.isNotEmpty) params['course'] = course;
    if (branch != null && branch!.isNotEmpty) params['branch'] = branch;
    if (section != null && section!.isNotEmpty) params['section'] = section;
    if (rollNo != null && rollNo!.isNotEmpty) params['roll_no'] = rollNo;
    if (admissionDate != null) params['admission_date'] = admissionDate!.toIso8601String();
    if (gender != null && gender!.isNotEmpty) params['gender'] = gender;
    if (seatType != null && seatType!.isNotEmpty) params['seat_type'] = seatType;
    if (caste != null && caste!.isNotEmpty) params['caste'] = caste;
    
    return params;
  }

  // Convert to JSON for POST requests
  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'course': course,
      'branch': branch,
      'section': section,
      'roll_no': rollNo,
      'admission_date': admissionDate?.toIso8601String(),
      'gender': gender,
      'seat_type': seatType,
      'caste': caste,
    };
  }
}

class AdmissionRecord {
  final int id;
  final String rollNo;
  final String admissionNo;
  final String studentName;
  final String gender;
  final String bloodGroup;
  final DateTime dateOfBirth;
  final String category;
  final String caste;
  final String nationality;
  final String religion;
  final String motherTongue;
  final String identificationMarks;
  final String entranceType;
  final String hallticketNumber;
  final String rank;
  final DateTime joiningDate;
  final String seatType;
  final String admissionType;
  final String mobileNo;
  final bool scholarship;
  final String email;
  final String? distanceFromResidence;
  final String? bankAccountNo;
  final String? rationCardNo;
  final String? aadharCardNo;
  final bool phc;
  final String permanentAddress;
  final String correspondenceAddress;
  
  // SSC Details
  final String? sscHallTicketNo;
  final String? sscBoard;
  final String? sscYearOfPass;
  final String? sscMarks;
  final String? sscPercentage;
  final String? sscInstitution;
  final String? sscGradePoints;
  
  // Inter Details
  final String? interHallTicketNo;
  final String? interBoard;
  final String? interYearOfPass;
  final String? interMarks;
  final String? interPercentage;
  final String? interInstitution;
  final String? interGradePoints;
  
  // Diploma Details (optional)
  final String? diplomaHallTicketNo;
  final String? diplomaBoard;
  final String? diplomaYearOfPass;
  final String? diplomaMarks;
  final String? diplomaPercentage;
  final String? diplomaInstitution;
  
  // Degree Details (optional)
  final String? degreeHallTicketNo;
  final String? degreeBoard;
  final String? degreeYearOfPass;
  final String? degreeMarks;
  final String? degreePercentage;
  final String? degreeInstitution;
  
  // Family Details
  final String fatherName;
  final String fatherOccupation;
  final String annualIncome;
  final String fatherMobileNo;
  final String motherName;
  final String motherOccupation;
  final String motherMobile;
  
  // Academic Details
  final String course;
  final String year;
  final String? branch;
  final String? section;

  AdmissionRecord({
    required this.id,
    required this.rollNo,
    required this.admissionNo,
    required this.studentName,
    required this.gender,
    required this.bloodGroup,
    required this.dateOfBirth,
    required this.category,
    required this.caste,
    required this.nationality,
    required this.religion,
    required this.motherTongue,
    required this.identificationMarks,
    required this.entranceType,
    required this.hallticketNumber,
    required this.rank,
    required this.joiningDate,
    required this.seatType,
    required this.admissionType,
    required this.mobileNo,
    required this.scholarship,
    required this.email,
    this.distanceFromResidence,
    this.bankAccountNo,
    this.rationCardNo,
    this.aadharCardNo,
    required this.phc,
    required this.permanentAddress,
    required this.correspondenceAddress,
    // SSC
    this.sscHallTicketNo,
    this.sscBoard,
    this.sscYearOfPass,
    this.sscMarks,
    this.sscPercentage,
    this.sscInstitution,
    this.sscGradePoints,
    // Inter
    this.interHallTicketNo,
    this.interBoard,
    this.interYearOfPass,
    this.interMarks,
    this.interPercentage,
    this.interInstitution,
    this.interGradePoints,
    // Diploma
    this.diplomaHallTicketNo,
    this.diplomaBoard,
    this.diplomaYearOfPass,
    this.diplomaMarks,
    this.diplomaPercentage,
    this.diplomaInstitution,
    // Degree
    this.degreeHallTicketNo,
    this.degreeBoard,
    this.degreeYearOfPass,
    this.degreeMarks,
    this.degreePercentage,
    this.degreeInstitution,
    // Family
    required this.fatherName,
    required this.fatherOccupation,
    required this.annualIncome,
    required this.fatherMobileNo,
    required this.motherName,
    required this.motherOccupation,
    required this.motherMobile,
    // Academic
    required this.course,
    required this.year,
    this.branch,
    this.section,
  });

  // Parse from API JSON response
  factory AdmissionRecord.fromJson(Map<String, dynamic> json) {
    return AdmissionRecord(
      id: json['id'],
      rollNo: json['roll_no'],
      admissionNo: json['admission_no'],
      studentName: json['student_name'],
      gender: json['gender'],
      bloodGroup: json['blood_group'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      category: json['category'],
      caste: json['caste'],
      nationality: json['nationality'],
      religion: json['religion'],
      motherTongue: json['mother_tongue'],
      identificationMarks: json['identification_marks'],
      entranceType: json['entrance_type'],
      hallticketNumber: json['hallticket_number'],
      rank: json['rank'],
      joiningDate: DateTime.parse(json['joining_date']),
      seatType: json['seat_type'],
      admissionType: json['admission_type'],
      mobileNo: json['mobile_no'],
      scholarship: json['scholarship'] == true || json['scholarship'] == 'Yes',
      email: json['email'],
      distanceFromResidence: json['distance_from_residence'],
      bankAccountNo: json['bank_account_no'],
      rationCardNo: json['ration_card_no'],
      aadharCardNo: json['aadhar_card_no'],
      phc: json['phc'] == true || json['phc'] == 'Yes',
      permanentAddress: json['permanent_address'],
      correspondenceAddress: json['correspondence_address'],
      sscHallTicketNo: json['ssc_hall_ticket_no'],
      sscBoard: json['ssc_board'],
      sscYearOfPass: json['ssc_year_of_pass'],
      sscMarks: json['ssc_marks'],
      sscPercentage: json['ssc_percentage'],
      sscInstitution: json['ssc_institution'],
      sscGradePoints: json['ssc_grade_points'],
      interHallTicketNo: json['inter_hall_ticket_no'],
      interBoard: json['inter_board'],
      interYearOfPass: json['inter_year_of_pass'],
      interMarks: json['inter_marks'],
      interPercentage: json['inter_percentage'],
      interInstitution: json['inter_institution'],
      interGradePoints: json['inter_grade_points'],
      diplomaHallTicketNo: json['diploma_hall_ticket_no'],
      diplomaBoard: json['diploma_board'],
      diplomaYearOfPass: json['diploma_year_of_pass'],
      diplomaMarks: json['diploma_marks'],
      diplomaPercentage: json['diploma_percentage'],
      diplomaInstitution: json['diploma_institution'],
      degreeHallTicketNo: json['degree_hall_ticket_no'],
      degreeBoard: json['degree_board'],
      degreeYearOfPass: json['degree_year_of_pass'],
      degreeMarks: json['degree_marks'],
      degreePercentage: json['degree_percentage'],
      degreeInstitution: json['degree_institution'],
      fatherName: json['father_name'],
      fatherOccupation: json['father_occupation'],
      annualIncome: json['annual_income'],
      fatherMobileNo: json['father_mobile_no'],
      motherName: json['mother_name'],
      motherOccupation: json['mother_occupation'],
      motherMobile: json['mother_mobile'],
      course: json['course'],
      year: json['year'],
      branch: json['branch'],
      section: json['section'],
    );
  }

  // Convert to Map for display in DataTable
  Map<String, String> toDisplayMap() {
    return {
      'Roll.No': rollNo,
      'Admission.No': admissionNo,
      'Student Name': studentName,
      'Gender': gender,
      'Blood Group': bloodGroup,
      'Date Of Birth': '${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}',
      'Category': category,
      'Caste': caste,
      'Nationality': nationality,
      'Religion': religion,
      'Mother Tongue': motherTongue,
      'Identification Marks': identificationMarks,
      'Entrance Type': entranceType,
      'Hallticket Number': hallticketNumber,
      'Rank': rank,
      'Joining Date': '${joiningDate.day}/${joiningDate.month}/${joiningDate.year}',
      'Seat Type': seatType,
      'Admission Type': admissionType,
      'Mobile No.': mobileNo,
      'ScholarShip': scholarship ? 'Yes' : 'No',
      'Email': email,
      'Distance From Residence': distanceFromResidence ?? '-',
      'Bank A/C No.': bankAccountNo ?? '-',
      'Ration Card No.': rationCardNo ?? '-',
      'Adhar Card No.': aadharCardNo ?? '-',
      'PHC': phc ? 'Yes' : 'No',
      'Permanent Address': permanentAddress,
      'Correspondence Address': correspondenceAddress,
      'SSC Hall Ticket.No': sscHallTicketNo ?? '-',
      'SSC Board': sscBoard ?? '-',
      'SSC Year Of Pass': sscYearOfPass ?? '-',
      'SSC Marks': sscMarks ?? '-',
      'SSC %': sscPercentage ?? '-',
      'SSC Institution': sscInstitution ?? '-',
      'SSC Grade Points': sscGradePoints ?? '-',
      'Inter Hall Ticket.No': interHallTicketNo ?? '-',
      'Inter Board': interBoard ?? '-',
      'Inter Year Of Pass': interYearOfPass ?? '-',
      'Inter Marks': interMarks ?? '-',
      'Inter %': interPercentage ?? '-',
      'Inter Institution': interInstitution ?? '-',
      'Inter Grade Points': interGradePoints ?? '-',
      'Diploma Hall Ticket.No': diplomaHallTicketNo ?? '-',
      'Diploma Board': diplomaBoard ?? '-',
      'Diploma Year Of Pass': diplomaYearOfPass ?? '-',
      'Diploma Marks': diplomaMarks ?? '-',
      'Diploma %': diplomaPercentage ?? '-',
      'Diploma Institution': diplomaInstitution ?? '-',
      'Degree Hall Ticket.No': degreeHallTicketNo ?? '-',
      'Degree Board': degreeBoard ?? '-',
      'Degree Year Of Pass': degreeYearOfPass ?? '-',
      'Degree Marks': degreeMarks ?? '-',
      'Degree %': degreePercentage ?? '-',
      'Degree Institution': degreeInstitution ?? '-',
      'Father Name': fatherName,
      'Father Occupation': fatherOccupation,
      'Annucal Income': annualIncome,
      'Father Mobile.No': fatherMobileNo,
      'Mother Name': motherName,
      'Mother Occupation': motherOccupation,
      'Mother Mobile': motherMobile,
      'Course': course,
      'Year': year,
      'Branch': branch ?? '-',
      'Section': section ?? '-',
    };
  }
}
