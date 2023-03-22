//
//  Extensions.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import MapKit
import UIKit

// MARK: - BlurLoader

class BlurLoader: UIView {
  // MARK: Lifecycle

  override init(frame: CGRect) {
    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = frame
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.blurEffectView = blurEffectView
    super.init(frame: frame)
    addSubview(blurEffectView)
    addLoader()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  var blurEffectView: UIVisualEffectView?

  // MARK: Private

  private func addLoader() {
    guard let blurEffectView = blurEffectView else { return }
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    blurEffectView.contentView.addSubview(activityIndicator)
    activityIndicator.center = blurEffectView.contentView.center
    activityIndicator.startAnimating()
  }
}

extension UIView {
  func showBlurLoader() {
    let blurLoader = BlurLoader(frame: frame)
    addSubview(blurLoader)
  }

  func removeBluerLoader() {
    if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
      blurLoader.removeFromSuperview()
    }
  }
}

extension UITextView {
  // Pass value for any one of both parameters and see result
  func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
    guard let labelText = text else { return }

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.lineHeightMultiple = lineHeightMultiple

    let attributedString: NSMutableAttributedString
    if let labelattributedText = attributedText {
      attributedString = NSMutableAttributedString(attributedString: labelattributedText)
    } else {
      attributedString = NSMutableAttributedString(string: labelText)
    }

    // Line spacing attribute
    attributedString.addAttribute(
      NSAttributedString.Key.paragraphStyle,
      value: paragraphStyle,
      range: NSMakeRange(0, attributedString.length)
    )

    attributedText = attributedString
  }
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(hideKeyboard)
    )
    view.addGestureRecognizer(tapGesture)
  }

  @objc
  func hideKeyboard() {
    view.endEditing(true)
  }
}

extension UIImage {
  func imageResize(sizeChange: CGSize) -> UIImage {
    let hasAlpha = true
    let scale: CGFloat = 0.0 // Use scale factor of main screen

    UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
    draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))

    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    return scaledImage!
  }
}

// extension MapViewController: MKMapViewDelegate {
//  // 1
////  func mapView(
////    _ mapView: MKMapView,
////    viewFor annotation: MKAnnotation
////  ) -> MKAnnotationView? {
////    // 2
////    guard let annotation = annotation as? Artwork else {
////      return nil
////    }
////    // 3
////    let identifier = "artwork"
////    var view: MKMarkerAnnotationView
////    // 4
////    if let dequeuedView = mapView.dequeueReusableAnnotationView(
////      withIdentifier: identifier) as? MKMarkerAnnotationView {
////      dequeuedView.annotation = annotation
////      view = dequeuedView
////    } else {
////      // 5
////      view = MKMarkerAnnotationView(
////        annotation: annotation,
////        reuseIdentifier: identifier)
////      view.canShowCallout = true
////      view.calloutOffset = CGPoint(x: -5, y: 5)
////      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
////    }
////    return view
////  }
//
//
//
////    private func mapView(_ mapView: MKMapView, annotationView view: ArtworkView,
////        calloutAccessoryControlTapped control: UIControl) {
////            guard let artwork = view.annotation as? Artwork else {
////                return
////            }
////
////            let launchOptions = [
////                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
////            ]
////
////            artwork.mapItem?.openInMaps(launchOptions: launchOptions)
////            print("ZHOPA")
////        }
//
// }

extension DispatchQueue {
  static func background(
    delay: Double = 0.0,
    background: (() -> ())? = nil,
    completion: (() -> ())? = nil
  ) {
    DispatchQueue.global(qos: .background).async {
      background?()
      if let completion = completion {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
          completion()
        }
      }
    }
  }
}
