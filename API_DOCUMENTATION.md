# Attendance Tracking API Documentation

## Overview
This document describes the API endpoints needed for the attendance tracking system. The Flutter app is ready to integrate with these endpoints.

## Base URL
```
http://localhost:3000/api
```
> **Note**: Update the `baseUrl` in `lib/services/attendance_service.dart` to match your backend URL.

## Authentication
All API requests should include authentication headers as per your backend implementation.

---

## Endpoints

### 1. Get Courses
Fetch all available courses.

**Endpoint**: `GET /courses`

**Response**:
```json
[
  {
    "id": "btech",
    "name": "B.Tech"
  },
  {
    "id": "mtech",
    "name": "M.Tech"
  }
]
```

---

### 2. Get Branches
Fetch branches for a specific course.

**Endpoint**: `GET /branches?course_id={courseId}`

**Parameters**:
- `course_id` (required): Course ID

**Response**:
```json
[
  {
    "id": "cse",
    "name": "CSE"
  },
  {
    "id": "ece",
    "name": "ECE"
  }
]
```

---

### 3. Get Subjects
Fetch subjects for a specific branch.

**Endpoint**: `GET /subjects?branch_id={branchId}`

**Parameters**:
- `branch_id` (required): Branch ID

**Response**:
```json
[
  {
    "id": "ds",
    "name": "Data Structures"
  },
  {
    "id": "algo",
    "name": "Algorithms"
  }
]
```

---

### 4. Get Attendance Records
Fetch attendance records based on filters.

**Endpoint**: `POST /attendance/records`

**Request Body**:
```json
{
  "course_id": "btech",
  "semester": "3",
  "branch_id": "cse",
  "section": "A",
  "subject_id": "ds",
  "start_date": "2024-01-01T00:00:00.000Z",
  "end_date": "2024-01-31T23:59:59.999Z"
}
```

**Request Body Fields** (all optional):
- `course_id`: Course identifier
- `semester`: Semester number (1-8)
- `branch_id`: Branch identifier
- `section`: Section letter (A, B, C, D)
- `subject_id`: Subject identifier
- `start_date`: Start date in ISO 8601 format
- `end_date`: End date in ISO 8601 format

**Response**:
```json
{
  "records": [
    {
      "student_id": "STU0001",
      "student_name": "Aarav Sharma",
      "roll_number": "CS001",
      "present_days": 25,
      "total_days": 30,
      "percentage": 83.33
    },
    {
      "student_id": "STU0002",
      "student_name": "Vivaan Patel",
      "roll_number": "CS002",
      "present_days": 28,
      "total_days": 30,
      "percentage": 93.33
    }
  ],
  "total_students": 2,
  "average_attendance": 88.33
}
```

**Response Fields**:
- `records`: Array of attendance records
  - `student_id`: Unique student identifier
  - `student_name`: Full name of the student
  - `roll_number`: Student roll number
  - `present_days`: Number of days present
  - `total_days`: Total number of days
  - `percentage`: Attendance percentage
- `total_students`: Total number of students in the result
- `average_attendance`: Average attendance percentage

---

## Error Handling

All endpoints should return appropriate HTTP status codes:

- `200 OK`: Successful request
- `400 Bad Request`: Invalid parameters
- `401 Unauthorized`: Authentication required
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error

**Error Response Format**:
```json
{
  "error": "Error message description",
  "code": "ERROR_CODE"
}
```

---

## Data Models

### FilterOption
```typescript
interface FilterOption {
  id: string;        // Unique identifier
  name: string;      // Display name
}
```

### AttendanceRecord
```typescript
interface AttendanceRecord {
  student_id: string;
  student_name: string;
  roll_number: string;
  present_days: number;
  total_days: number;
  percentage: number;
}
```

### AttendanceResponse
```typescript
interface AttendanceResponse {
  records: AttendanceRecord[];
  total_students: number;
  average_attendance: number;
}
```

---

## Implementation Notes

1. **Fallback Behavior**: The app currently uses mock data if the backend is unavailable. This allows development and testing without a backend.

2. **Cascading Filters**: 
   - When a course is selected, the app calls `/branches?course_id={id}`
   - When a branch is selected, the app calls `/subjects?branch_id={id}`

3. **Date Handling**: Dates are sent in ISO 8601 format. The backend should parse these appropriately.

4. **Loading States**: The UI shows loading indicators while fetching data from the backend.

5. **Error Messages**: User-friendly error messages are displayed when API calls fail.

---

## Testing

### Using Mock Data
The app will automatically use mock data if the backend is not available. This is useful for:
- Frontend development
- UI testing
- Demo purposes

### Connecting to Backend
1. Update `baseUrl` in `lib/services/attendance_service.dart`
2. Ensure CORS is configured on the backend
3. Add authentication headers if required

---

## Example Backend Implementation (Node.js/Express)

```javascript
// Example route handlers
app.get('/api/courses', async (req, res) => {
  const courses = await db.query('SELECT id, name FROM courses');
  res.json(courses);
});

app.get('/api/branches', async (req, res) => {
  const { course_id } = req.query;
  const branches = await db.query(
    'SELECT id, name FROM branches WHERE course_id = ?',
    [course_id]
  );
  res.json(branches);
});

app.get('/api/subjects', async (req, res) => {
  const { branch_id } = req.query;
  const subjects = await db.query(
    'SELECT id, name FROM subjects WHERE branch_id = ?',
    [branch_id]
  );
  res.json(subjects);
});

app.post('/api/attendance/records', async (req, res) => {
  const filters = req.body;
  // Build dynamic query based on filters
  const records = await getAttendanceRecords(filters);
  res.json({
    records,
    total_students: records.length,
    average_attendance: calculateAverage(records)
  });
});
```

---

## Configuration

Update the base URL in the service file:

**File**: `lib/services/attendance_service.dart`

```dart
class AttendanceService {
  // Update this URL to match your backend
  static const String baseUrl = 'https://your-backend-url.com/api';
  
  // ... rest of the code
}
```
