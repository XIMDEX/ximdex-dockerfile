# Ximdex Dockerfile

Commands to try it

1)  Clone this repo

2)  Build the image locally (inside root folder)

```sh
$ docker build -t myximimage . 
```

3)  Launch a mysql container with docker

```sh
$ docker run --name some-mysql -d mysql:5.5
```

4)  Launch a myximimage container (linking it with the mysql container)

```sh
$ docker run --name myximdex -p 9000:80 --link some-mysql:mysql myximimage
```

5)  Visit http://localhost:9000/setup/index.php
