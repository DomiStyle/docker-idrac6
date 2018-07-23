# iDRAC 5 and 6 dockerized

![Web interface](https://i.imgur.com/Au9DPmg.png)
*Web interface*

![Guacamole](https://i.imgur.com/8IWAATS.png)
*Directly connected to VNC via Guacamole*

## About

Allows access to the iDRAC console without installing Java or messing with Java Web Start. Java is only run inside of the container and access is provided via web interface or directly with VNC.

Container is based on [docker-idrac6](https://github.com/DomiStyle/docker-idrac6) by [DomiStyle](https://github.com/DomiStyle) which in turn is based on [baseimage-gui](https://github.com/jlesage/docker-baseimage-gui) by [jlesage](https://github.com/jlesage)

# Usage

See the docker-compose [here](https://github.com/ncerny/docker-idrac/blob/master/docker-compose.yml) or use this command:

    docker run -d -p 5800:5800 -p 5900:5900 -e IDRAC_HOST=idrac1.example.org -e IDRAC_USER=root -e IDRAC_PASSWORD=1234 ncerny/idrac

The web interface will be available on port 5800 while the VNC server can be accessed on 5900. Startup might take a few seconds while the Java libraries are downloaded. You can add a volume on /app if you would like to cache them.

## Configuration

All listed configuration variables are required.

| Variable       | Description                                  |
|----------------|----------------------------------------------|
|`IDRAC_HOST`| Host for your iDRAC instance. Make sure your instance is reachable with https://<IDRAC_HOST> |
|`IDRAC_USER`| Username for your iDRAC instance. |
|`IDRAC_PASSWORD`| Password for your iDRAC instance. |

For advanced configuration options please take a look [here](https://github.com/jlesage/docker-baseimage-gui#environment-variables).

## Issues & limitations

* Libraries are not loaded correctly
  * Causes error message on start
  * "Pass all keystrokes to server", "Single Cursor" and "Virtual Media" is not available until fixed
* User preferences can't be saved
* VNC starts with default 1024x768 resolution instead of fullscreen
  * Use "View" -> "Full Screen" to work around this issue
* Keyboard layout can't be changed
* Only one iDRAC server can be accessed with a single instance
  * Run multiple containers to work around this issue (e.g. srv1.idrac.example.org, srv2.idrac.example.org)
