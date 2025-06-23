import UIKit
import CoreML

protocol PrescriptionClassifierServiceProtocol {
    func classify(image: UIImage, completion: @escaping (Result<(Bool, Double), Error>) -> Void)
}

class PrescriptionClassifierService: PrescriptionClassifierServiceProtocol {
    private let model: PrescriptionClassifier

    init?() {
        guard let model = try? PrescriptionClassifier(configuration: MLModelConfiguration()) else {
            return nil
        }
        self.model = model
    }

    func classify(image: UIImage, completion: @escaping (Result<(Bool, Double), Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let buffer = image.pixelBuffer(width: 224, height: 224) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "ImageConversion", code: -1, userInfo: nil)))
                }
                return
            }
            do {
                let prediction = try self.model.prediction(image: buffer)
                let isPrescription = prediction.target == "prescription"
                let confidence = prediction.targetProbability["prescription"] ?? 0.0
                DispatchQueue.main.async {
                    completion(.success((isPrescription, confidence)))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
} 
