import Foundation

#if !os(macOS)
import HomeKit
#endif

@available(iOS 13.0, *)
class HomeStore: NSObject, ObservableObject, HMHomeManagerDelegate {
    @Published public var homes: [HMHome] = []
    @Published public var primaryHomeRooms: [HMRoom] = []
    @Published public var primaryHome: HMHome?
public class HomeStore: NSObject, ObservableObject, HMHomeManagerDelegate {
    @Published var homes: [HMHome] = []
    @Published var primaryHomeRooms: [HMRoom] = []
    @Published var primaryHome: HMHome?
    
    private var manager: HMHomeManager!
    
    @Published public var accessoriesFor: (HMHome, HMRoom) -> [HMAccessory] = { h, r in
        return h.accessories.filter { a in
            a.room?.uniqueIdentifier == r.uniqueIdentifier
        }
    }
    
    public override init() {
        super.init()
        
        if(manager == nil) {
            manager = .init()
            manager.delegate = self
        }
        
        homes = manager.homes
        primaryHome = manager.primaryHome
    }
    
    internal func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        homes = manager.homes
        primaryHome = manager.primaryHome
        primaryHomeRooms = manager.primaryHome!.rooms
    }
    
    public func addHome(withName: String, completionHandler: @escaping (HMHome?, Error?) -> Void) {
        manager.addHome(withName: withName, completionHandler: completionHandler)
    }
    
    deinit {
        manager.delegate = nil
    }
}

