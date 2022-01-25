import Foundation

class UserData{
    
    var userDic : NSDictionary!
    let stringConverter = StringConverter()
    
    init(){
        
        }
    
    private let defaults =  UserDefaults.standard
    func setUserDefaults(_ data : NSDictionary) {
        userDic = data
        defaults.set(userDic["id"],forKey: "ID")
        defaults.set(userDic["username"], forKey: "UserName")
        defaults.set(userDic["mobile"], forKey: "Mobile")
        defaults.set(userDic["state"], forKey: "State")
        defaults.set(userDic["district"], forKey: "District")
        defaults.set(userDic["commodity"],forKey: "userCommodity")
        defaults.set(userDic["taluka"], forKey: "Taluka")
    }
    
    func setDefaults(key : String,data : Any){
        defaults.removeObject(forKey: key)
        defaults.set(data, forKey: key)
    }
    
    func getUserDefaults(_ key : String) -> Any{
        guard let data = defaults.string(forKey: key) else { return "error"}
        return data
    }
}
