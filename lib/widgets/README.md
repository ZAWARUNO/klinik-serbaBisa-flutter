# Widgets Directory

## DoctorsSection Widget

### Overview
The `DoctorsSection` widget is a reusable component that displays a list of doctors with their schedules using `FutureBuilder` to fetch data from an API.

### Features
- **FutureBuilder Integration**: Uses `FutureBuilder` to handle async data loading from `ApiService.getDoctorSchedules()`
- **Loading State**: Shows a `CircularProgressIndicator` while data is being fetched
- **Error Handling**: Displays error message with retry button if API call fails
- **Empty State**: Shows message when no doctor data is available
- **Responsive Design**: Adapts to different screen sizes with proper layout
- **Modern UI**: Clean card-based design with gradient backgrounds

### Usage
```dart
import 'package:your_app/widgets/doctors_section.dart';

// In your widget tree
const DoctorsSection()
```

### Dependencies
- `../services/api_service.dart` - For API calls
- `../models/doctor_model.dart` - For Doctor data model
- `../screens/auth/auth_routes.dart` - For navigation

### API Requirements
The widget expects the API to return data in the following format:
```json
{
  "status": "success",
  "data": [
    {
      "nama": "Dr. John Doe",
      "specialty": "Dokter Umum",
      "schedule": {
        "Senin": "09:00",
        "Selasa": null,
        "Rabu": "14:00"
      },
      "max_reservasi": 10,
      "experience": "15+ Tahun",
      "color": "#4ECDC4",
      "image": "assets/images/dokter-john.png"
    }
  ]
}
```

### Components
1. **Header Section**: Displays title, description, and statistics
2. **Doctors List**: Shows individual doctor cards with schedules
3. **CTA Section**: Call-to-action buttons for registration and login

### Error Handling
- Network errors are caught and displayed with retry functionality
- Invalid data formats are handled gracefully
- Loading states provide good user experience 