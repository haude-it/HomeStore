import Foundation
import HomeKit
import SwiftUI

class HomeStore: NSObject, ObservableObject, HMHomeManagerDelegate {
    @Published var homes: [HMHome] = []
    @Published var primaryHomeRooms: [HMRoom] = []
    @Published var primaryHome: HMHome?
    
    private var manager: HMHomeManager!
    
    @Published var accessoriesFor: (HMHome, HMRoom) -> [HMAccessory] = { h, r in
        return h.accessories.filter { a in
            a.room?.uniqueIdentifier == r.uniqueIdentifier
        }
    }
    
    override init() {
        super.init()
        
        if(manager == nil) {
            manager = .init()
            manager.delegate = self
        }
        
        homes = manager.homes
        primaryHome = manager.primaryHome
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        homes = manager.homes
        primaryHome = manager.primaryHome
        primaryHomeRooms = manager.primaryHome!.rooms
    }
    
    func addHome(withName: String, completionHandler: @escaping (HMHome?, Error?) -> Void) {
        manager.addHome(withName: withName, completionHandler: completionHandler)
    }
    
    deinit {
        manager.delegate = nil
    }
}

