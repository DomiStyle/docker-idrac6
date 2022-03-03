# iDRAC 6 dockerized

<img src="https://i.imgur.com/Sg6qYtT.png" alt="Web interface" width="100%" />

*Web interface*

<img src="https://i.imgur.com/LcD0q2a.png" alt="Guacamole" width="100%" />

*Directly connected to VNC via Guacamole*

## About

Allows access to the iDRAC 6 console without installing Java or messing with Java Web Start. Java is only run inside of the container and access is provided via web interface or directly with VNC.

Container is based on [baseimage-gui](https://github.com/jlesage/docker-baseimage-gui) by [jlesage](https://github.com/jlesage)

# Usage

See the docker-compose [here](https://github.com/DomiStyle/docker-idrac6/blob/master/docker-compose.yml) or use this command:
```
docker run -d \
  -p 5800:5800 \
  -p 5900:5900 \
  -e IDRAC_HOST=idrac1.example.org \
  -e IDRAC_USER=root \
  -e IDRAC_PASSWORD=1234 \
  domistyle/idrac6
```
The web interface will be available on port 5800 while the VNC server can be accessed on 5900. Startup might take a few seconds while the Java libraries are downloaded. You can add a volume on /app if you would like to cache them.

## Configuration

| Variable       | Description                                  | Required |
|----------------|----------------------------------------------|----------|
|`IDRAC_HOST`| Host for your iDRAC instance. Make sure your instance is reachable with https://<IDRAC_HOST>. See IDRAC_PORT for using custom ports. HTTPS is always used. | Yes |
|`IDRAC_USER`| Username for your iDRAC instance. | Yes |
|`IDRAC_PASSWORD`| Password for your iDRAC instance. | Yes |
|`IDRAC_PORT`| The optional port for the web interface. (443 by default) | No |
|`IDRAC_KEYCODE_HACK`| If you have issues with keyboard input, try setting this to ``true``. See [here](https://github.com/anchor/idrac-kvm-keyboard-fix) for more infos. | No |
|`VIRTUAL_MEDIA`| Filename of iso located within /vmedia to automount | No |

**For advanced configuration options please take a look [here](https://github.com/jlesage/docker-baseimage-gui#environment-variables).**

## Volumes

| Path       | Description                                  | Required |
|------------|----------------------------------------------|----------|
|`/app`| Libraries downloaded from your iDRAC instance will be stored here. Add a volume to cache those files for a faster container startup. | No |
|`/vmedia`| Can be used to allow virtual media to be mounted. | No |
|`/screenshots`| Screenshots taken from the virtual console can be stored here. | No |

Make sure the container user has read & write permission to these folders on the host. [More info here](https://github.com/jlesage/docker-baseimage-gui#usergroup-ids).

## Issues & limitations

* ~Libraries are not loaded correctly~
  * ~Causes error message on start~
  * ~"Pass all keystrokes to server", "Single Cursor" and "Virtual Media" is not available until fixed~
* User preferences can't be saved
* VNC starts with default 1024x768 resolution instead of fullscreen
  * Use "View" -> "Full Screen" to work around this issue
* Keyboard layout can't be changed
* Only one iDRAC server can be accessed with a single instance
  * Run multiple containers to work around this issue (e.g. srv1.idrac.example.org, srv2.idrac.example.org)
