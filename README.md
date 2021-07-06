# IoT Sensor

Platform to collect and view the measurements of your sensors.

There is a wide range of IoT sensors used to detect and measure various environmental phenomena such as temperature, pressure, wind, pollution, sunlight ...  
The application presents a solution to manage your IoT sensors scattered anywhere in the world through a web interface.  
It is also able to interact with users, both to collect sensor data and to view the progress of the measurements received.  
The application can be used for any type of sensor as long as the measured data is in a numerical format.  
The sensors can interact with the platform by sending serialized measurements in JSON format using a ReST interface.  

[Deployment Link](https://rails-sensor-platform.herokuapp.com) 

## Info for Developing

Ruby version: 3.0.0   
Rails version: 6.1.1  

Create a copy of `database.yml.example` in 
`IoT_Rails/config/` e rename it in `database.yml`


    IoT_Rails
    ├── config                 
        ├── database.yml  
        ├── database.yml.examples   
        ├── ...       

Edit the file for your database          
        

### Dependencies

Install Yarn or npm e install dependencies:

Using npm:

```bash
npm install
```

or yarn:

```bash
yarn add chart.js chartkick leaflet jquery popper.js bootstrap
```



