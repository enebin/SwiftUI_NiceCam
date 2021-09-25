//
//  CameraViewModel.swift
//  SwiftUI_JJaseCam
//
//  Created by 이영빈 on 2021/09/24.
//

import SwiftUI
import AVFoundation
import Combine

class CameraViewModel: ObservableObject {
    private let model: Camera
    private let session: AVCaptureSession
    private var subscriptions = Set<AnyCancellable>()
    let cameraPreview: AnyView

    @Published var recentImage: UIImage?
    @Published var isFlashOn = false
    @Published var isSilentModeOn = false
    
    // 초기 세팅
    func configure() {
        model.requestAndCheckPermissions()
    }
    
    // 플래시 온오프
    func switchFlash() {
        isFlashOn.toggle()
    }
    
    // 무음모드 온오프
    func switchSilent() {
        isSilentModeOn.toggle()
    }
    
    // 사진 촬영
    func capturePhoto() {
        model.capturePhoto()
        print("[CameraViewModel]: Photo captured!")
    }
    
    // 전후면 카메라 스위칭
    func changeCamera() {
        print("[CameraViewModel]: Camera changed!")
    }
    
    init() {
        model = Camera()
        session = model.session
        cameraPreview = AnyView(CameraPreviewView(session: session))
        
        model.$recentImage.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.recentImage = pic
        }
        .store(in: &self.subscriptions)
    }
}
