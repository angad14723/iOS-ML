# iOS ML Prescription Classifier

This app detects whether an uploaded image is a doctor's prescription using a CoreML model.

flowchart TD
    A["User taps Upload Image"] --> B["ImagePicker presents"]
    B --> C["User selects image"]
    C --> D["ViewModel receives image"]
    D --> E["ViewModel calls Service"]
    E --> F["Service runs ML model (GCD background)"]
    F --> G["Service returns result & confidence"]
    G --> H["ViewModel updates published properties"]
    H --> I["SwiftUI View updates UI"]
    I --> J{"Show"}
    J -->|"Processing"| K["ProgressView"]
    J -->|"Result"| L["Result Card: Text, Icon, Confidence Bar"]
    J -->|"Error"| M["Error Message"]
    style L fill:#c6f6d5,stroke:#38a169,stroke-width:2px
    style M fill:#fed7d7,stroke:#e53e3e,stroke-width:2px
    style K fill:#bee3f8,stroke:#3182ce,stroke-width:2px

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

![WhatsApp Image 2025-06-23 at 15 14 19](https://github.com/user-attachments/assets/a4484de0-c7c6-4d1c-9974-55245da5d53c)
![WhatsApp Image 2025-06-23 at 15 14 19 (1)](https://github.com/user-attachments/assets/03dde99d-25fd-4f16-a0d4-efc32a31a3a0)
![WhatsApp Image 2025-06-23 at 15 14 19 (2)](https://github.com/user-attachments/assets/f772bc5b-081b-42d2-b3d3-6d9c92745071)

