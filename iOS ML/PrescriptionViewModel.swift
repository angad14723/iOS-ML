import SwiftUI

class PrescriptionViewModel: ObservableObject {
    @Published var isPrescription: Bool?
    @Published var confidence: Double?
    @Published var errorMessage: String?
    @Published var isProcessing: Bool = false

    private let classifierService: PrescriptionClassifierServiceProtocol

    init(classifierService: PrescriptionClassifierServiceProtocol) {
        self.classifierService = classifierService
    }

    func classify(image: UIImage) {
        isProcessing = true
        errorMessage = nil
        isPrescription = nil
        confidence = nil
        classifierService.classify(image: image) { [weak self] result in
            DispatchQueue.main.async {
                self?.isProcessing = false
                switch result {
                case .success(let (isPrescription, confidence)):
                    self?.isPrescription = isPrescription
                    self?.confidence = confidence
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
} 