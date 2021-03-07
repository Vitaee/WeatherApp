import requests,re
from bs4 import BeautifulSoup
from flask import Flask, json

app = Flask(__name__)


@app.route('/',methods=['GET'])
def hello():
    return "İl bazlı hava durumu api."

@app.route('/<string:city>',methods=['GET'])
def get_data(city):

    req = requests.get(f'https://yandex.com.tr/hava/{city.lower()}')
    res = req.content
    soup = BeautifulSoup(res, 'html.parser')

    #weather_temp = soup.find('span',class_='temp__value temp__value_with-unit')
    weather_state = soup.find('div',class_='link__condition day-anchor i-bem')
    weather_feels = soup.find_all('span',class_='temp__value temp__value_with-unit')
    weather_wind = soup.find('span',class_='wind-speed')
    weather_humidity = soup.find('div',class_='term term_orient_v fact__humidity')
    
    data = {
        "WeatherTemp":weather_feels[1].text,
        "WeatherState":weather_state.text,
        "WeatherFeel":weather_feels[2].text,
        "WeatherWind":weather_wind.text,
        "WeatherHumidity":weather_humidity.text,
	"WeatherCity":city
    }


    return json.dumps(data, ensure_ascii=False, indent=4)
