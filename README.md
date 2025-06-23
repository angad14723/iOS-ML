# iOS ML Prescription Classifier

This app detects whether an uploaded image is a doctor's prescription using a CoreML model.

## Architecture

- **SOLID Principles**: The codebase is structured for maintainability and testability.
  - **Single Responsibility**: Each class (service, view model, view) has a clear responsibility.
  - **Open/Closed**: The classifier service is protocol-based and can be extended or swapped.
  - **Liskov Substitution**: The service protocol allows for easy mocking or replacement.
  - **Interface Segregation**: The protocol is focused and specific.
  - **Dependency Inversion**: The view model depends on the protocol, not a concrete class.

- **Concurrency with GCD**: Model inference runs on a background thread using Grand Central Dispatch, keeping the UI responsive.

## Main Components

- `PrescriptionClassifierServiceProtocol` — Protocol for the classifier service.
- `PrescriptionClassifierService` — Handles CoreML model loading and prediction, using GCD for background processing.
- `PrescriptionViewModel` — ObservableObject that manages state and business logic for the view.
- `UploadPrescriptionView` — SwiftUI view for image upload and result display.
- `UIImage.pixelBuffer(width:height:)` — Extension to convert images for CoreML input.

## Usage

1. Tap **Upload Image** to select a photo.
2. The app will classify the image and display whether it is a prescription.

---

This structure makes it easy to extend, test, and maintain the app.

Prescriptions Only, Please! Reducing Server Costs with On-Device Intelligence(iOS)
https://angad14723.medium.com/prescriptions-only-please-reducing-server-costs-with-on-device-intelligence-ios-c03c3dbf0b54

![WhatsApp Image 2025-05-13 at 13 56 53 (2)](https://github.com/user-attachments/assets/023d9749-e1bb-4e46-8bf3-f2dc21578d17)
![WhatsApp Image 2025-05-13 at 13 56 53 (1)](https://github.com/user-attachments/assets/7fde4d9d-beaf-457d-beea-94f31370a88b)
![WhatsApp Image 2025-05-13 at 13 56 53](https://github.com/user-attachments/assets/d49d4986-fa39-44d4-b662-6934b5d26935)
