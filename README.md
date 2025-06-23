# iOS ML Prescription Classifier

This app detects whether an uploaded image is a doctor's prescription using a CoreML model.

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

![WhatsApp Image 2025-06-23 at 15 14 19](https://github.com/user-attachments/assets/a4484de0-c7c6-4d1c-9974-55245da5d53c)
![WhatsApp Image 2025-06-23 at 15 14 19 (1)](https://github.com/user-attachments/assets/03dde99d-25fd-4f16-a0d4-efc32a31a3a0)
![WhatsApp Image 2025-06-23 at 15 14 19 (2)](https://github.com/user-attachments/assets/f772bc5b-081b-42d2-b3d3-6d9c92745071)

