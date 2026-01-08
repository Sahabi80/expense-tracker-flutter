# Expense Tracker Mobile Application

## Description
This is a mobile-based Expense Tracker application developed using Flutter and Supabase.
The application allows users to manage their daily expenses and income securely.
Users can view net balance, analyze spending through charts, and manage their profile.

This project was developed as part of an academic requirement.

---

## Features
- User Authentication (Login & Register)
- Splash Screen
- Profile Management (Update Name & Profile Picture)
- Expense Management (Add, Edit, Delete)
- Income Management
- Net Balance Dashboard
- Analytics & Charts
- Responsive UI
- Secure Logout
- Reusable Widgets

---

## Technologies Used
- Flutter (Dart)
- Supabase (Authentication, Database, Storage)
- PostgreSQL
- Row Level Security (RLS)

---

## Project Structure
lib/
├── screens/
├── services/
├── models/
├── widgets/
└── main.dart


---

## Security
- Supabase authentication is used for secure login and registration.
- Row Level Security ensures users can only access their own data.
- Sensitive keys are not included in this repository.

---

## How to Run the Project
1. Download or clone the repository
2. Open the project in Android Studio or VS Code
3. Run the following commands:

   flutter pub get  
   flutter run

4. Configure Supabase credentials before running

---

## Limitations
- Internet connection is required
- No offline mode
- No export feature (PDF/CSV)

---

## Future Improvements
- Monthly budget limits
- Dark mode
- Export expenses as PDF/CSV
- Notifications
- Recurring expenses

---

## Author
Name: Md. Emad uddin Khan Sahabi  
Department: CSE  
University: Leading University  

---

## License
This project is developed for academic purposes only.
