# Ximdex Dockerfile

Commands to try it

1)  Launch a mysql container with docker

```sh
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:5.6
$ # If you already have a mysql container called some-mysql you can run it with docker start some-mysql
```

2)  Launch a ximdex container (linking it with the mysql container)

```sh
$ docker run --name myximdex -p 80:80 --link some-mysql:mysql ximdex/ximdex
$ # If you already have a ximdex container called myximdex you can run it with docker start myximdex
```

3)  Visit http://localhost/setup/index.php In Mac OS, you have to visit http://DOCKER_HOST/setup/index.php, you can check your DOCKER_HOST using:

```sh
# Only for Mac OS users
env | grep DOCKER_HOST
```

The following environment variables are also honored for configuring your Ximdex instance:

-	`-e XIMDEX_DB_HOST=...` (defaults to the IP and port of the linked `mysql` container)
-	`-e XIMDEX_DB_USER=...` (defaults to "root")
-	`-e XIMDEX_DB_PASSWORD=...` (defaults to the value of the `MYSQL_ROOT_PASSWORD` environment variable from the linked `mysql` container)
-	`-e XIMDEX_DB_NAME=...` (defaults to "ximdex")

If the `XIMDEX_DB_NAME` specified does not already exist on the given MySQL server, it will be created automatically upon startup of the `ximdex` container, provided that the `XIMDEX_DB_USER` specified has the necessary permissions to create it.

If you'd like to use an external database instead of a linked `mysql` container, specify the hostname and port with `XIMDEX_DB_HOST` along with the password in `XIMDEX_DB_PASSWORD` and the username in `XIMDEX_DB_USER` (if it is something other than `root`):

```console
$ docker run --name some-ximdex -e XIMDEX_DB_HOST=10.1.2.3:3306 \
    -e XIMDEX_DB_USER=... -e XIMDEX_DB_PASSWORD=... -d ximdex/ximdex
```