//
//  UploadPrescriptionView.swift
//  iOS ML
//
//  Created by Angad on 30/04/25.
//

import SwiftUI
import PhotosUI
import CoreML
import Vision

struct UploadPrescriptionView: View {
    
    @State private var image: UIImage?
    @State private var resultText = "No image selected"
    @State private var isPickerPresented = false

    var body: some View {
        VStack(spacing: 20) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay(Text("No Image").foregroundColor(.gray))
            }

            Text(resultText)
                .font(.headline)
                .padding()

            Button("Upload Image") {
                isPickerPresented = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $image, onImagePicked: classifyImage)
        }
    }
    
    func classifyImage(_ image: UIImage) {
        //   isProcessing = true
           resultText = "Processing image..."
           
           // Create a proper CGImage - this is more reliable than CIImage in some cases
           guard let cgImage = image.cgImage else {
               resultText = "Failed to get CGImage from UIImage"
              // isProcessing = false
               return
           }
           
           // Load model with error handling
           do {
               // Create a proper model configuration
               let config = MLModelConfiguration()
               config.computeUnits = .all // Use all available compute units
               
               let mlModel = try PrescriptionClassifier(configuration: config).model
               let visionModel = try VNCoreMLModel(for: mlModel)
               
               let request = VNCoreMLRequest(model: visionModel) { request, error in
                   DispatchQueue.main.async {
                     //  isProcessing = false
                       
                       if let error = error {
                           resultText = "Vision error: \(error.localizedDescription)"
                           print("Vision request error: \(error)")
                           return
                       }
                       
                       guard let results = request.results as? [VNClassificationObservation],
                             let topResult = results.first else {
                           resultText = "No classification results"
                           return
                       }
                       
                       let percentage = Int(topResult.confidence * 100)
                       resultText = "Prediction: \(topResult.identifier) (\(percentage)%)"
                       
                       // Display top 3 results if available
                       if results.count > 1 {
                           var detailedResults = "Top predictions:\n"
                           for i in 0..<min(3, results.count) {
                               let result = results[i]
                               detailedResults += "- \(result.identifier): \(Int(result.confidence * 100))%\n"
                           }
                           resultText = detailedResults
                       }
                   }
               }
               
               // Important: Set the image crop and scale option to centerCrop
               request.imageCropAndScaleOption = .centerCrop
               
               // Create a handler with CGImage instead of CIImage
               let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
               
               // Perform the request on a background thread
               DispatchQueue.global(qos: .userInitiated).async {
                   do {
                       try handler.perform([request])
                   } catch {
                       DispatchQueue.main.async {
                           resultText = "Image processing error: \(error.localizedDescription)"
                        //   isProcessing = false
                           print("Handler perform error: \(error)")
                       }
                   }
               }
               
           } catch {
               resultText = "ML model error: \(error.localizedDescription)"
             //  isProcessing = false
               print("ML model initialization error: \(error)")
           }
       }
}


