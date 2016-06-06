# Ximdex Dockerfile

Commands to try it

1)  Launch a mysql container with docker

```sh
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:5.6
```

2)  Launch a ximdex container (linking it with the mysql container)

```sh
$ docker run --name myximdex -p 80:80 --link some-mysql:mysql docker pull ximdex/ximdex
```

3)  Visit http://localhost/setup/index.php
