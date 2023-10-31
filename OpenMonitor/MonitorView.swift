import SwiftUI
import AVFoundation

// 1. A UIViewController to manage the camera preview.
class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var captureDevice: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPreview()
    }
    
    func setupPreview() {
        guard let captureSession = captureSession else {
            print("Capture session is nil")
            return
        }
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer)
    }
}

// 2. A SwiftUI view to bridge the UIViewController to SwiftUI.
struct CameraPreview: UIViewControllerRepresentable {
    var captureSession: AVCaptureSession
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.captureSession = captureSession
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

// 3. The main SwiftUI view to select and display camera input.
struct MonitorView: View {
    var captureDevice: AVCaptureDevice  // Parameter for the selected capture device
    @State private var captureSession: AVCaptureSession?
    init(captureDevice: AVCaptureDevice) {
        self.captureDevice = captureDevice
    }
    
    var body: some View {
        VStack {
            if let session = captureSession {
                CameraPreview(captureSession: session).frame(maxWidth: .infinity, maxHeight: .infinity).aspectRatio(contentMode: .fit)
                
            }
        }
        .onAppear {
            captureSession = self.captureSession(for: captureDevice)
            let dispatchQueue = DispatchQueue(label: "captureSession", qos: .background)
            dispatchQueue.async{
                captureSession?.startRunning()
            }
        }
        .onDisappear {
            captureSession?.stopRunning()
        }
    }
    
    func captureSession(for device: AVCaptureDevice) -> AVCaptureSession {
        let session = AVCaptureSession()
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch {
            print("Failed to create capture device input: \(error)")
        }
        
        return session
    }
}


