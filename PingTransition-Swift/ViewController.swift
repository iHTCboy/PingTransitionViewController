//
//  ViewController.swift
//  PingTransition-Swift
//
//  Created by HTC on 2017/5/20.
//  Copyright © 2017年 iHTCboy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.gray
        view.addSubview(button1);
        view.addSubview(button2);
        view.addSubview(button3);
        view.addSubview(button4);
        view.addSubview(button5);
    }
    
    lazy var button1: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 20, y: 100, width: 48, height: 48))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(clickedButton(button:)), for: .touchUpInside)
        return button;
    }()
    
    lazy var button2: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 20, y: 100, width: 48, height: 48))
        button.center = self.view.center
        button.backgroundColor = UIColor(red:0,  green:0.478,  blue:0.725, alpha:1)
        button.addTarget(self, action: #selector(clickedButton(button:)), for: .touchUpInside)
        return button;
    }()
    
    lazy var button3: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 20, y: self.view.frame.height - 100, width: 48, height: 48))
        button.backgroundColor = UIColor.purple
        button.addTarget(self, action: #selector(clickedButton(button:)), for: .touchUpInside)
        return button;
    }()
    
    lazy var button4: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: self.view.frame.width - 80, y: 130, width: 48, height: 48))
        button.backgroundColor = UIColor(red:0.953,  green:0.573,  blue:0.235, alpha:1)
        button.addTarget(self, action: #selector(clickedButton(button:)), for: .touchUpInside)
        return button;
    }()
    
    lazy var button5: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: self.view.frame.width - 80, y: self.view.frame.height - 100, width: 48, height: 48))
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(clickedButton(button:)), for: .touchUpInside)
        return button;
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func clickedButton(button: UIButton) {
        // Target View
        self.pingView = button;
        let vc = SecondViewController()
        vc.view.backgroundColor = button.backgroundColor;
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

extension ViewController: UINavigationControllerDelegate
{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == .push) {
            return PingTransition.init(operation: operation)
        }else{
            return nil
        }
    }
}

