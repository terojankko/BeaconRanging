//
//  ViewController.swift
//  BeaconRanging
//
//  Created by Tero on 8/3/17.
//  Copyright © 2017 Tero. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    fileprivate let uuidKey = "uuid"
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var uuidField: UITextField!
    @IBOutlet weak var beaconDetectedLabel: UILabel!
    
    var region : CLBeaconRegion?
    
    fileprivate var isRanging = false
    
    @IBAction func startStopTapped(_ sender: Any) {
        self.view.endEditing(true)
        if !isRanging {
             if let uuid = uuidField.text {
                guard let proximityUuid = (NSUUID.init(uuidString: uuid)) as UUID? else {
                    // error
                    showError("Sorry, I can't parse this uuid")
                    return
                }
                region = CLBeaconRegion(proximityUUID: proximityUuid, identifier: "my beacon")
                locationManager.startMonitoring(for: region!)
                locationManager.startRangingBeacons(in: region!)
                saveUuid(uuid)
                isRanging = true
                startStopButton.setTitle("Stop", for: .normal)
                startStopButton.backgroundColor = UIColor.red
                beaconDetectedLabel.text = "Scanning..."
                beaconDetectedLabel.backgroundColor = UIColor.lightGray
             } else {
                // error msg
            }
        }
        else {

            isRanging = false
            startStopButton.setTitle("Start", for: .normal)
            startStopButton.backgroundColor = UIColor.green
            guard let currentRegion = region else {
                return
            }
            locationManager.stopMonitoring(for: currentRegion)
            locationManager.stopRangingBeacons(in: currentRegion)
            region = nil
        }
        beaconDetectedLabel.backgroundColor = UIColor.white
    }
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uuidField.text = getUuid()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    func getUuid() -> String {
        let defaultUuid = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0" // my test beacon
        if let uuid = UserDefaults.standard.string(forKey: uuidKey) {
            return uuid
        } else {
            return defaultUuid
        }
    }
    
    func saveUuid(_ uuid: String) {
        UserDefaults.standard.set(uuid, forKey: uuidKey)
    }
    
    
    func showError(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count == 1 {
            beaconDetectedLabel.text = "(\(beacons[0].major), \(beacons[0].minor)), \(beacons[0].proximity.rawValue), \(beacons[0].rssi)"
            beaconDetectedLabel.backgroundColor = UIColor.green
        }
    }
}

func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print("Failed monitoring region: \(error.localizedDescription)")
}

func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location manager failed: \(error.localizedDescription)")
}
