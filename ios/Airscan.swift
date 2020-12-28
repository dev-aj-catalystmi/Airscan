import UIKit
import VisionKit

@objc(Airscan)
class Airscan: NSObject {
  
  var window: UIWindow?
  
  @objc static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
    @available(iOS 13.0, *)
    @objc(startScanning)
  func startScanning() {
    DispatchQueue.main.async {
      
      self.window = UIWindow(frame: UIScreen.main.bounds)
      let rootViewController = UIViewController()
      
      if self.window == nil {
        return
      }
      
      self.window?.backgroundColor = .clear
      self.window?.rootViewController = rootViewController
      self.window?.makeKeyAndVisible()
      
      let scanVC = VNDocumentCameraViewController()
      scanVC.delegate = self
      scanVC.modalPresentationStyle = .overFullScreen
      
      rootViewController.present(scanVC, animated: true)
      
//      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//        let scanVC = VNDocumentCameraViewController()
//        scanVC.delegate = self
//        scanVC.modalPresentationStyle = .overFullScreen
//        appDelegate.rootViewController.present(scanVC, animated: true)
//      }
    }
  }
  
}

extension Airscan: VNDocumentCameraViewControllerDelegate {
    @available(iOS 13.0, *)
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
    guard scan.pageCount >= 1 else {
      return
    }
    
    var images: [UIImage] = [UIImage]()
    
    for pageIndex in 0 ..< scan.pageCount {
      images.append(scan.imageOfPage(at: pageIndex))
    }
    
    if images.count > 0 {
      CustomPhotoAlbum.sharedInstance.save(images: images)
    }
    
    DispatchQueue.main.async {
      controller.dismiss(animated: true)
      self.removeWindowFromSuperView()
    }
  }
  
    @available(iOS 13.0, *)
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
    // handle error here
    
    DispatchQueue.main.async {
      controller.dismiss(animated: true)
      self.removeWindowFromSuperView()
    }
    
  }
  
    @available(iOS 13.0, *)
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
    
    DispatchQueue.main.async {
      controller.dismiss(animated: true)
      self.removeWindowFromSuperView()
    }
    
  }
  
  func removeWindowFromSuperView() {
    self.window = nil
    self.window?.removeFromSuperview()
  }
}
