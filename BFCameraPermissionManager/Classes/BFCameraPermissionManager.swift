import AVFoundation
import Foundation
import UIKit

@objcMembers
public final class BFCameraPermissionManager: NSObject {
    public static let shared = BFCameraPermissionManager()
    private static var suppressGuideAlertOnceAfterSystemDeny = false
    private static var suppressGuideAlertOnceAfterGuideCancel = false
    private static var isPresentingGuideAlert = false

    private override init() {
        super.init()
    }

    @objc(sharedManager)
    public class func sharedManager() -> BFCameraPermissionManager {
        BFCameraPermissionManager.shared
    }

    // MARK: - Status

    @objc
    public class func authorizationStatus() -> AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }

    @objc
    public class func isAuthorized() -> Bool {
        authorizationStatus() == .authorized
    }

    // MARK: - Request

    /// Behavior:
    /// - If status is .notDetermined, only the system prompt is shown.
    /// - If user denies in the system prompt, the guide alert is NOT shown in this same request.
    /// - After system deny, one immediate follow-up request is suppressed (no guide alert).
    /// - If user cancels the guide alert, one immediate follow-up request is suppressed.
    /// - If called later and status is .denied/.restricted, the guide alert is shown.
    @objc(requestAuthorizationFromViewController:completion:)
    public class func requestAuthorization(fromViewController viewController: UIViewController?,
                                          completion: @escaping (Bool) -> Void) {
        guard viewController != nil else {
            DispatchQueue.main.async { completion(false) }
            return
        }

        switch authorizationStatus() {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    suppressGuideAlertOnceAfterSystemDeny = !granted
                    suppressGuideAlertOnceAfterGuideCancel = false
                    completion(granted)
                }
            }

        case .authorized:
            suppressGuideAlertOnceAfterSystemDeny = false
            suppressGuideAlertOnceAfterGuideCancel = false
            DispatchQueue.main.async { completion(true) }

        case .denied, .restricted:
            if suppressGuideAlertOnceAfterSystemDeny {
                suppressGuideAlertOnceAfterSystemDeny = false
                DispatchQueue.main.async { completion(false) }
                return
            }
            if suppressGuideAlertOnceAfterGuideCancel {
                suppressGuideAlertOnceAfterGuideCancel = false
                DispatchQueue.main.async { completion(false) }
                return
            }
            showPermissionGuideAlert(fromViewController: viewController, title: nil, message: nil) { _ in
                DispatchQueue.main.async { completion(false) }
            }

        @unknown default:
            DispatchQueue.main.async { completion(false) }
        }
    }

    // MARK: - Guide Alert

    @objc(showPermissionGuideAlertFromViewController:completion:)
    public class func showPermissionGuideAlert(fromViewController viewController: UIViewController?,
                                               completion: ((Bool) -> Void)?) {
        showPermissionGuideAlert(fromViewController: viewController, title: nil, message: nil, completion: completion)
    }

    @objc(showPermissionGuideAlertFromViewController:title:message:completion:)
    public class func showPermissionGuideAlert(fromViewController viewController: UIViewController?,
                                               title: String?,
                                               message: String?,
                                               completion: ((Bool) -> Void)?) {
        guard let viewController else {
            DispatchQueue.main.async { completion?(false) }
            return
        }

        DispatchQueue.main.async {
            guard !isPresentingGuideAlert else {
                completion?(false)
                return
            }
            isPresentingGuideAlert = true

            let bundle = BFPermissionLocalization.bundle(
                forResourceBundleNamed: "BFCameraPermissionManager",
                anchorClass: BFCameraPermissionManager.self
            )

            let alertTitle = title ?? BFPermissionLocalization.localized("bf_permission_camera_title", bundle: bundle)
            let alertMessage = message ?? BFPermissionLocalization.localized("bf_permission_camera_message", bundle: bundle)
            let settingsTitle = BFPermissionLocalization.localized("bf_permission_common_settings", bundle: bundle)
            let cancelTitle = BFPermissionLocalization.localized("bf_permission_common_cancel", bundle: bundle)

            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: settingsTitle, style: .default) { _ in
                isPresentingGuideAlert = false
                suppressGuideAlertOnceAfterGuideCancel = false
                openSystemSettings()
                completion?(true)
            })
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                isPresentingGuideAlert = false
                suppressGuideAlertOnceAfterGuideCancel = true
                completion?(false)
            })

            if viewController.presentedViewController != nil {
                isPresentingGuideAlert = false
                completion?(false)
                return
            }
            viewController.present(alert, animated: true)
        }
    }

    // MARK: - Settings

    @objc
    public class func openAppSettings() {
        openSystemSettings()
    }
}

private func openSystemSettings() {
    DispatchQueue.main.async {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

enum BFPermissionLocalization {
    static func bundle(forResourceBundleNamed name: String, anchorClass: AnyClass) -> Bundle {
        let frameworkBundle = Bundle(for: anchorClass)
        if let url = frameworkBundle.url(forResource: name, withExtension: "bundle"),
           let bundle = Bundle(url: url) {
            return bundle
        }
        return frameworkBundle
    }

    static func localized(_ key: String, bundle: Bundle) -> String {
        NSLocalizedString(key, bundle: bundle, comment: "")
    }
}
