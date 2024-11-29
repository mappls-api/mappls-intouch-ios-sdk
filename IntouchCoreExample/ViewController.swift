//
//  ViewController.swift
//  IntouchCoreExample
//
//  Created by Siddharth  on 28/11/24.
//

import UIKit
import MapplsIntouchCore
import MapplsAPICore
class ViewController: UIViewController {
    
    let stackView = UIStackView()
    let initializeIntouchButton = UIButton()
    let stopTrackingButton = UIButton()
    let startTrackingButton = UIButton()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Config", style: .plain, target: self, action: #selector(configTapped))
        
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        initializeIntouchButton.addTarget(self, action: #selector(initializeIntouch), for: .touchUpInside)
        initializeIntouchButton.layer.cornerRadius = 5
        initializeIntouchButton.layer.borderWidth = 1
        initializeIntouchButton.layer.borderColor = UIColor.black.cgColor
        initializeIntouchButton.setTitle("  Initialize  ", for: .normal)
        initializeIntouchButton.isEnabled = true
        initializeIntouchButton.setTitleColor(UIColor.gray, for: .disabled)
        initializeIntouchButton.setTitleColor(UIColor.green, for: .normal)
        
        stackView.addArrangedSubview(initializeIntouchButton)
        
        
        startTrackingButton.addTarget(self, action: #selector(startTracking), for: .touchUpInside)
        startTrackingButton.layer.cornerRadius = 5
        startTrackingButton.layer.borderWidth = 1
        startTrackingButton.layer.borderColor = UIColor.black.cgColor
        startTrackingButton.setTitle("  Start Tracking  ", for: .normal)
        startTrackingButton.setTitleColor(UIColor.gray, for: .disabled)
        startTrackingButton.setTitleColor(UIColor.yellow, for: .selected)
        startTrackingButton.setTitleColor(UIColor.green, for: .normal)
        
        stackView.addArrangedSubview(startTrackingButton)
        
        
        
       
        stopTrackingButton.addTarget(self, action: #selector(stopTracking), for: .touchUpInside)
        stopTrackingButton.layer.cornerRadius = 5
        stopTrackingButton.layer.borderWidth = 1
        stopTrackingButton.layer.borderColor = UIColor.black.cgColor
        stopTrackingButton.setTitle("  Stop Tracking  ", for: .normal)
        
        
        stopTrackingButton.setTitleColor(UIColor.gray, for: .disabled)
        stopTrackingButton.setTitleColor(UIColor.green, for: .normal)
        
        stackView.addArrangedSubview(stopTrackingButton)
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        
        configureButtonStatus()
    }
    
    @objc func configTapped() {
        let configuration = MapplsIntouchConfiguration()
        configuration.allowsBackgroundLocationUpdates = true
        // To set the how t
        let pollingProfile = configuration.setPollingProfile(profile: .slow)
        configuration.desiredAccuracy = 100
    }
    
    func configureButtonStatus() {
        if Intouch.shared.isInitialized {
            initializeIntouchButton.isEnabled = false
            if Intouch.shared.intouchTrackingEnabled() {
                startTrackingButton.isEnabled = false
                stopTrackingButton.isEnabled = true
            } else {
                startTrackingButton.isEnabled = true
                stopTrackingButton.isEnabled = false
            }
            
        } else {
            startTrackingButton.isEnabled = false
            stopTrackingButton.isEnabled = false
            initializeIntouchButton.isEnabled = true
        }
    }
    
    @objc func initializeIntouch() {
        guard !Intouch.shared.isInitialized else {
            return
        }
        activityIndicator.startAnimating()
        Intouch.shared.initializeForCredentials(clientId: MapplsAccountManager.clientId() ?? "", clientSecret: MapplsAccountManager.clientSecret() ?? "", deviceName: "siddharth_test") { success in
            DispatchQueue.main.async {
                self.initializeIntouchButton.isEnabled = false
                self.startTrackingButton.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
        } failure: { error in
            self.activityIndicator.stopAnimating()
            if let error = error {
                debugPrint("error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func startTracking() {
        self.activityIndicator.startAnimating()
        Intouch.shared.startTracking { isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.startTrackingButton.isEnabled = false
                    self.stopTrackingButton.isEnabled = true
                }
            } else {
                self.activityIndicator.stopAnimating()
                debugPrint("Start tracking failed")
            }
            
        }
        
    }
    
    @objc func stopTracking() {
        Intouch.shared.stopTracking()
        self.startTrackingButton.isEnabled = true
        self.stopTrackingButton.isEnabled = false
    }
}

