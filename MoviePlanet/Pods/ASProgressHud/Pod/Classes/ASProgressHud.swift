//
//  ASProgress.swift
//  Pods
//
//  Created by Andrea Stevanato on 17/02/16.
//
//

/**
*  Specify the property for the Hud.
*/
public struct HudProperty {
    
    /// The images predix name (eg. For a image with format "my_loader_XX.png" with NN from 0 to 20 the predix name is "my:loader")
    public let prefixName: String
    /// The number of images used to animate the loader
    let frameNumber: Int
    /// The size for the loader. Defaut value 60 px
    let size: CGFloat
    /// The animation duration for a single cycles. Default value 1.0 second
    let animationDuration: TimeInterval
    /// An optional background color. The defuault value is clear color
    let backgroundColor: UIColor?
    
    fileprivate var mainBundle: Bool = false
    
    /**
     Specify the property for the Hud
     
     - parameter prefixName:        The images predix name (eg. For a image with format "my_loader_XX.png" with NN from 0 to 20 the predix name is "my:loader")
     - parameter frameNumber:       The number of images used to animate the loader
     - parameter size:              The size for the loader. Defaut value 60 px
     - parameter animationDuration: The animation duration for a single cycles. Default value 1.0 second
     - parameter backgroundColor:   An optional background color. The defuault value is clear color
     
     - returns: The property struct
     */
    public init(prefixName: String, frameNumber: Int, size: CGFloat = 60, animationDuration: TimeInterval = 1.0, backgroundColor: UIColor? = UIColor.clear) {
        self.prefixName = prefixName
        self.frameNumber = frameNumber
        self.size = size
        self.animationDuration = animationDuration
        self.backgroundColor = backgroundColor
    }
}

/// A set of custom Hud
public enum HudType: Int {
    case `default`, flag, google
    
    var properties: HudProperty {
        switch self {
        case .default:
            return HudProperty(prefixName: "default", frameNumber: 18)
        case .flag:
            return HudProperty(prefixName: "flag", frameNumber: 20)
        case .google:
            return HudProperty(prefixName: "google", frameNumber: 30)
        }
    }
}

/**
 *  ASProgressHud is UIView subclass
 */
open class ASProgressHud: UIView {
    
    fileprivate var useAnimation = true
    fileprivate var showStarted: Date?
    fileprivate var hudImageView: UIImageView?
    var removeFromSuperViewOnHide: Bool? = false
    
    // MARK: - Init
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Init with Progress Hud Type
     
     :param: frame frame
     :param: type  Progress Hud Type
     
     :returns: ASProgressHud istance
     */
    init(frame: CGRect, type: HudType) {
        super.init(frame: frame)
        
        let hudProperty = type.properties
        self.initializeWithHudProperty(hudProperty)
        
        self.customTypeBasedConfiguration(type)
        self.addSubview(self.hudImageView!)
    }
    
    /**
     Init with custom loader
     
     :param: frame       Frame
     :param: hudProperty Hud property
     
     :returns: ASProgressHud istance
     */
    init(frame: CGRect, hudProperty: HudProperty) {
        super.init(frame: frame)
        
        self.initializeWithHudProperty(hudProperty)
        self.addSubview(self.hudImageView!)
    }
    
    fileprivate func initializeWithHudProperty(_ hudProperty: HudProperty) {
        self.removeFromSuperViewOnHide = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.isOpaque = false
        self.alpha = 0.0
        self.contentMode = UIView.ContentMode.center
        self.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
        // Configure HudImageView
        self.hudImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: hudProperty.size, height: hudProperty.size))
        self.hudImageView?.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.hudImageView?.contentMode = UIView.ContentMode.scaleAspectFit
        self.hudImageView?.backgroundColor = hudProperty.backgroundColor
        
        // Load images
        let imagesArray = self.loadImages(hudProperty)
        
        // Animation configuration
        self.hudImageView?.animationImages = imagesArray
        self.hudImageView?.animationDuration = hudProperty.animationDuration
        self.hudImageView?.animationRepeatCount = 0
        self.hudImageView?.clipsToBounds = true
        self.hudImageView?.layer.cornerRadius = 10.0
    }
    
    fileprivate func customTypeBasedConfiguration(_ type: HudType) {
        switch type {
        case .default:
            
            // Add a black shadow with radius offset and opacity
            self.hudImageView?.layer.shadowColor = UIColor.black.cgColor
            self.hudImageView?.layer.shadowOpacity = 0.4
            self.hudImageView?.layer.shadowRadius = 3.0
            self.hudImageView?.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.hudImageView?.clipsToBounds = false
            
        default:
            break
        }
    }
    
    // MARK: - Utils
    
    fileprivate func loadImages(_ property: HudProperty) -> [UIImage] {

        // Load images
        var imageArray: [UIImage] = []
        
        for c in 0 ..< property.frameNumber {
            guard let image = UIImage(named: String(format: "%@_%02d.png", property.prefixName, c), in: property.mainBundle ? nil : self.podBundle(), compatibleWith: nil) else {
                assertionFailure("Cannot load the image")
                return []
            }
            imageArray.append(image)
        }
        
        return imageArray
    }
    
    fileprivate func podBundle() -> Bundle {
        
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "Resources", withExtension: "bundle") {
            
            if let bundle = Bundle(url: bundleURL) {
                return bundle
            } else {
                assertionFailure("Could not load the bundle")
            }
        } else {
            assertionFailure("Could not create a path to the bundle")
        }
        return podBundle
    }
    
    // MARK: - Class methods
    
    /**
    Creates a new HUD, adds it to provided view and shows it. The counterpart to this method is hideHUDForView:animated:.
    
    :note: This method sets `removeFromSuperViewOnHide`. The HUD will automatically be removed from the view hierarchy when hidden.
    
    :param: view     The view that the HUD will be added to
    :param: animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use animations while appearing.
    :param: type     The type for the HUD
    
    :returns: A reference to the created HUD.
    
    :see: hideHUDForView:animated:
    :see: animationType
    */
    @discardableResult
    public static func showHUDAddedTo(_ view: UIView, animated: Bool, type: HudType) -> ASProgressHud {
        let hud = ASProgressHud(frame: view.bounds, type: type)
        view.addSubview(hud)
        hud.show(animated)
        return hud
    }
    
    /**
     Creates a new HUD, adds it to provided view and shows it. The counterpart to this method is hideHUDForView:animated:.
     
     :note: This method sets `removeFromSuperViewOnHide`. The HUD will automatically be removed from the view hierarchy when hidden.
     
     :param: view     The view that the HUD will be added to
     :param: animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use animations while appearing.
     :param: type     The type for the HUD
     
     :returns: A reference to the created HUD.
     
     :see: hideHUDForView:animated:
     :see: animationType
     */
    @discardableResult
    public static func showCustomHUDAddedTo(_ view: UIView, animated: Bool, property: HudProperty) -> ASProgressHud {
        var hudProperty = property
        hudProperty.mainBundle = true
        let hud = ASProgressHud(frame: view.bounds, hudProperty: hudProperty)
        view.addSubview(hud)
        hud.show(animated)
        return hud
    }
    
    /**
     Finds the top-most HUD subview and hides it. The counterpart to this method is showHUDAddedTo:animated:.
     
     :note: This method sets `removeFromSuperViewOnHide`. The HUD will automatically be removed from the view hierarchy when hidden.
     
     :param: view     The view that is going to be searched for a HUD subview.
     :param: animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use animations while disappearing.
     
     :returns: YES if a HUD was found and removed, NO otherwise.
     
     :see: showHUDAddedTo:animated:
     :see: animationType
     */
    @discardableResult
    public static func hideHUDForView(_ view: UIView, animated: Bool) -> Bool {
        let hud = self.HUDForView(view)
        
        if hud != nil {
            hud?.removeFromSuperViewOnHide = true
            hud?.hide(animated)
            return true
        }
        return false
    }
    
    /**
     Finds all the HUD subviews and hides them.
     
     :param: view     The view that is going to be searched for HUD subviews.
     :param: animated If set to YES the HUDs will disappear using the current animationType. If set to NO the HUDs will not use animations while disappearing.
     
     :returns: The number of HUDs found and removed.
     
     :see: hideHUDForView:animated:
     :see: animationType
     */
    public static func hideAllHUDsForView(_ view: UIView, animated: Bool) -> NSInteger {
        
        let huds = ASProgressHud.allHUDsForView(view)
        for hud in huds {
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated)
        }
        return huds.count
    }
    
    fileprivate static func HUDForView(_ view: UIView) -> ASProgressHud? {
        
        let subviewsEnum  = view.subviews as NSArray
        let array = subviewsEnum.reverseObjectEnumerator()
        
        for subView in array {
            if (subView as AnyObject).isKind(of: self) {
                return subView as? ASProgressHud
            }
        }
        return nil
    }
    
    fileprivate static func allHUDsForView(_ view: UIView) -> [ASProgressHud] {
        
        var huds: [ASProgressHud]? = []
        let subviews = view.subviews as Array
        for aView in subviews {
            if aView.isKind(of: self) {
                huds?.append(aView as! ASProgressHud)
            }
        }
        return huds!
    }
    
    // MARK: - Show & hide
    
    fileprivate func showUsingAnimation(_ animated: Bool) {
        // Cancel any scheduled hideDelayed: calls
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.setNeedsDisplay()
        
        self.hudImageView?.startAnimating()
        
        self.showStarted = Date()
        
        // Fade in
        if animated == true {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.30)
            self.alpha = 1.0
            UIView.commitAnimations()
        } else {
            self.alpha = 1.0
        }
    }
    
    fileprivate func hideUsingAnimation(_ animated: Bool) {
        // Fade out
        if animated == true && showStarted != nil {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.30)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(ASProgressHud.animationFinished))
            // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
            // in the done method
            self.alpha = 0.02
            UIView.commitAnimations()
        } else {
            self.alpha = 0.0
            self.done()
        }
        self.showStarted = nil
    }
    
    fileprivate func show(_ animated: Bool) {
        assert(Thread.isMainThread, "ASProgressHud needs to be accessed on the main thread.")
        self.useAnimation = animated
        self.showUsingAnimation(useAnimation)
    }
    
    fileprivate func hide(_ animated: Bool) {
        assert(Thread.isMainThread, "ASProgressHud needs to be accessed on the main thread.")
        self.useAnimation = animated
        self.hideUsingAnimation(useAnimation)
    }
    
    // MARK: - Internal show & hide operations
    
    @objc func animationFinished() {
        self.done()
    }
    
    fileprivate func done() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.alpha = 0.0
        self.hudImageView?.stopAnimating()
        
        if removeFromSuperViewOnHide == true {
            self.removeFromSuperview()
        }
    }
    
}
