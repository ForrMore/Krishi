import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager, weather : WeatherModel)
    func didFailWithError(_ error: Error)
}


struct WeatherManager {
    let weatherURL = KRSI.
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherData(city: String){
        let urlString  = "\(weatherURL)&q=\(city)"
       
        
        performRequest(urlString)// func call
    }
    
    func performRequest(_ urlString: String) {
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)//2. create urlSession
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self,weather : weather)
                    }
                }
            }//3. give the session a tsk
            
            task.resume()  //4. start the taskv
            
        }//1. create url
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{ // this is an optional because if it pass an nil as an out put
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let min = decodedData.main.temp_min
            let max = decodedData.main.temp_max
            let hum = decodedData.main.humidity
            let speed = decodedData.wind.speed
            let descrip = decodedData.weather[0].description
            
            
            let weather = WeatherModel(
                cityName: name,
                conditionId: id,
                temperature: temp,
                min_temperature : min,
                max_temperature : max,
                humadity : hum,
                wind : speed,
                description : descrip
            )
            return weather
        }catch{
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
}
