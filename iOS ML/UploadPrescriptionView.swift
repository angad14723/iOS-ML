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
import CoreVideo

struct UploadPrescriptionView: View {
    
    @State private var image: UIImage?
    @State private var isPickerPresented = false
    @StateObject private var viewModel = PrescriptionViewModel(classifierService: PrescriptionClassifierService()!)

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 20)
            // Image display
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemGray6))
                    .shadow(radius: 6)
                    .frame(height: 260)
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 240)
                        .cornerRadius(14)
                        .padding(8)
                        .transition(.scale)
                } else {
                    VStack {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
            }
            .padding(.horizontal)
            // Result Card
            if viewModel.isProcessing {
                ProgressView("Processing image...")
                    .padding(.top, 16)
            } else if let isPrescription = viewModel.isPrescription {
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: isPrescription ? "checkmark.seal.fill" : "xmark.seal.fill")
                            .foregroundColor(isPrescription ? .green : .red)
                        Text(isPrescription ? "Prescription Detected" : "Not a Prescription")
                            .font(.headline)
                            .foregroundColor(isPrescription ? .green : .red)
                    }
                    if let confidence = viewModel.confidence {
                        VStack(spacing: 4) {
                            Text("Confidence: \(Int(confidence * 100))%")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color(.systemGray5))
                                        .frame(height: 10)
                                    Capsule()
                                        .fill(isPrescription ? Color.green : Color.red)
                                        .frame(width: geometry.size.width * CGFloat(confidence), height: 10)
                                        .animation(.easeInOut, value: confidence)
                                }
                            }
                            .frame(height: 10)
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isPrescription ? Color.green.opacity(0.12) : Color.red.opacity(0.12))
                        .shadow(color: (isPrescription ? Color.green : Color.red).opacity(0.15), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.top, 16)
            } else {
                Text("Upload a prescription image to get started.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top, 16)
            }
            Spacer()
            Button(action: { isPickerPresented = true }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload Image")
                        .fontWeight(.semibold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 4, y: 2)
            }
            .padding(.horizontal)
            .sheet(isPresented: $isPickerPresented) {
                ImagePicker(image: $image, onImagePicked: { uiImage in
                    withAnimation { viewModel.classify(image: uiImage) }
                })
            }
            Spacer(minLength: 18)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

// MARK: - UIImage to CVPixelBuffer Extension
extension UIImage {
    func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        CVPixelBufferLockBaseAddress(buffer, [])
        let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
        guard let cgImage = self.cgImage else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(buffer, [])
        return buffer
    }
}


