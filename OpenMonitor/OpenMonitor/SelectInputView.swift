//
//  ContentView.swift
//  OpenMonitor
//
//  Created by Juan Ruiz on 19/10/23.
//
import SwiftUI
import AVFoundation
import Photos

struct SelectInputView: View {
    @State private var selectedInputID: String = "none"
    @State private var navigateToMonitorView = false
    @ObservedObject private var deviceManager = DeviceManager()  // Use the observable object here
    
    func getAvailableCaptureDevices() -> [AVCaptureDevice] {
        let deviceTypes: [AVCaptureDevice.DeviceType] = [.external,.builtInDualCamera,.builtInDualWideCamera,.builtInTelephotoCamera,.builtInTripleCamera,.builtInUltraWideCamera,.builtInWideAngleCamera,.continuityCamera]
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: .unspecified)
        
        return discoverySession.devices
    }
    
    
    
    func startCaptureSession() {
        AVCaptureDevice.requestAccess(for: .video) { videoGranted in
            if videoGranted {
                AVCaptureDevice.requestAccess(for: .audio) { audioGranted in
                    if audioGranted {
                        PHPhotoLibrary.requestAuthorization { photoStatus in
                            switch photoStatus {
                            case .authorized:
                                // All permissions granted, start the capture session
                                break
                            case .denied, .restricted, .notDetermined:
                                print("Permissions denied for photo library.")
                            default:
                                break
                            }
                        }
                    } else {
                        print("Permissions denied for microphone.")
                    }
                }
            } else {
                print("Permissions denied for camera.")
            }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                if deviceManager.devices.isEmpty {
                    Text("Please connect a compatible device")
                } else {
                    Text("Select your input:")
                    Picker("Select your input:", selection: $selectedInputID) {
                        ForEach(deviceManager.devices, id: \.uniqueID) { device in
                            Text(device.localizedName).tag(device.uniqueID)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    let selectedInput = deviceManager.devices.first(where: { $0.uniqueID != selectedInputID })
                    NavigationLink(
                        destination: MonitorView(captureDevice: selectedInput!),  // Force unwrapping the optional here
                        isActive: $navigateToMonitorView,
                        label: { EmptyView() }
                    )
                    Button(action: {
                        print("selectedInputID: \(String(describing: selectedInputID))")  // Debug print
                        if selectedInputID != nil {
                            navigateToMonitorView = true
                        }
                    }) {
                        Text("Start")
                    }
                }
                
            }
        }
        
    }
}

struct SelectInputView_Preview: PreviewProvider {
    static var previews: some View {
        SelectInputView()
    }
}


class DeviceManager: ObservableObject {
    @Published var devices: [AVCaptureDevice] = []
    
    init() {
        fetchDevices()
    }
    
    func fetchDevices() {
        let deviceTypes: [AVCaptureDevice.DeviceType] = [.external, .builtInDualCamera, .builtInDualWideCamera, .builtInTelephotoCamera, .builtInTripleCamera, .builtInUltraWideCamera, .builtInWideAngleCamera, .continuityCamera]
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: .unspecified)
        self.devices = discoverySession.devices
    }
}

