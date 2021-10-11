//
//  UIViewControllerExtension.swift
//  WeatherAPP
//
//  Created by Oluwatobiloba Akinrujomu on 11/10/2021.
//

import Foundation
import UIKit

var container : UIView!
var spinningActivityIndicator: UIActivityIndicatorView!

extension UIViewController: UIGestureRecognizerDelegate {
    
    func enableSwipeBack() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func transparentHeader() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func presentOkAlert(_ title: String, _ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let uiAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        present(uiAlert, animated: true)
        return
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async {
            
            spinningActivityIndicator = UIActivityIndicatorView()
            let window = UIApplication.shared.keyWindow
            container = UIView()
            container.frame = UIScreen.main.bounds
            container.backgroundColor = UIColor(hue: 0/360, saturation: 0/100, brightness: 0/100, alpha: 0.4)

            let loadingView: UIView = UIView()
            loadingView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            loadingView.center = container.center
            loadingView.backgroundColor = UIColor.lightGray
                //UIColor(hue: 359/360, saturation: 67/100, brightness: 71/100, alpha: 1)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 40
            
            spinningActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            spinningActivityIndicator.hidesWhenStopped = true
            spinningActivityIndicator.style = UIActivityIndicatorView.Style.large
            spinningActivityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
            loadingView.addSubview(spinningActivityIndicator)
            container?.addSubview(loadingView)
            window!.addSubview(container)
            spinningActivityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndicator() {
        //Again, we need to ensure the UI is updated from the main thread!
        DispatchQueue.main.async {
            spinningActivityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            container.removeFromSuperview()
        }
    }

    
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
    
}

@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 2

    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)

        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }

}

extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}

