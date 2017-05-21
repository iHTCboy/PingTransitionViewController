//
//  PingTransition.swift
//  PingTransition-Swift
//
//  Created by HTC on 2017/5/21.
//  Copyright © 2017年 iHTCboy. All rights reserved.
//

import UIKit


class PingTransition: NSObject
{
    init(operation: UINavigationControllerOperation) {
        self.duration = 0.7 //default
        self.operation = operation
        super.init()
    }
    
    init(operation: UINavigationControllerOperation, duration:TimeInterval) {
        self.duration = duration
        self.operation = operation
        super.init()
    }
    
    var operation : UINavigationControllerOperation
    var duration = TimeInterval()
    var transitionContext: UIViewControllerContextTransitioning?
}

extension PingTransition: UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext;
        
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let contView = transitionContext.containerView
        let pingView = (operation == .push ? fromVC.pingView! : toVC.pingView!)
        
        if operation == .push {
            contView.addSubview(fromVC.view)
            contView.addSubview(toVC.view)
        }else{
            // pop
            contView.addSubview(toVC.view)
            contView.addSubview(fromVC.view)
        }
        
        //创建两个圆形的 UIBezierPath 实例；一个是 pingView 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
        let maskPingViewBP = UIBezierPath.init(ovalIn: pingView.frame)
        
        var finalPoint = CGPoint.zero
        //判断触发点在那个象限
        if(pingView.frame.origin.x > (toVC.view.bounds.width / 2)){
            if (pingView.frame.origin.y < (toVC.view.bounds.height / 2)) {
                //第一象限
                finalPoint = CGPoint.init(x: pingView.center.x - 0, y: pingView.center.y - toVC.view.bounds.maxY + 30)
            }else{
                //第四象限
                finalPoint = CGPoint.init(x: pingView.center.x - 0, y: pingView.center.y - 0);
            }
        }else{
            if (pingView.frame.origin.y < (toVC.view.bounds.height / 2)) {
                //第二象限
                finalPoint = CGPoint.init(x: pingView.center.x - toVC.view.bounds.maxX, y: pingView.center.y - toVC.view.bounds.maxY + 30);
            }else{
                //第三象限
                finalPoint = CGPoint.init(x: pingView.center.x - toVC.view.bounds.maxX, y: pingView.center.y - 0);
            }
        }
        
        let radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
        
        let maskFullBP = UIBezierPath.init(ovalIn: pingView.frame.insetBy(dx: -radius, dy: -radius))
        
        //创建一个 CAShapeLayer 来负责展示圆形遮盖
        let maskLayer = CAShapeLayer()
        maskLayer.path = (operation == .push ? maskFullBP.cgPath : maskPingViewBP.cgPath) //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
        (operation == .push ? toVC : fromVC).view.layer.mask = maskLayer;
        
        let maskLayerAnimation = CABasicAnimation.init(keyPath: "path")
        maskLayerAnimation.fromValue = (operation == .push ? maskPingViewBP.cgPath : maskFullBP.cgPath)
        maskLayerAnimation.toValue = (operation == .push ? maskFullBP.cgPath : maskPingViewBP.cgPath)
        maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
        
        maskLayerAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerAnimation.delegate = self as CAAnimationDelegate;
        
        maskLayer.add(maskLayerAnimation, forKey: "path")
        
    }
}


extension PingTransition : CAAnimationDelegate
{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        //告诉 iOS 这个 transition 完成
        self.transitionContext?.completeTransition(!(self.transitionContext?.transitionWasCancelled)!)
        
        //清除 fromVC 的 mask
        self.transitionContext?.viewController(forKey:.from )?.view.layer.mask = nil
        self.transitionContext?.viewController(forKey: .to)?.view.layer.mask = nil
    }
}


extension UIViewController
{
    private struct PingTransionKey {
        static var pingView:UIView?
        static var percentTransition: UIPercentDrivenInteractiveTransition?
    }
    
    var pingView: UIView? {
        get {
            return objc_getAssociatedObject(self, &PingTransionKey.pingView) as? UIView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &PingTransionKey.pingView, newValue as UIView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var popTransition: UIPercentDrivenInteractiveTransition? {
        get {
            return objc_getAssociatedObject(self, &PingTransionKey.percentTransition) as? UIPercentDrivenInteractiveTransition
        }
        set {
            objc_setAssociatedObject(self, &PingTransionKey.percentTransition, newValue as UIPercentDrivenInteractiveTransition?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

