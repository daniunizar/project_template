# Despliegue en local

A continuación se indican los pasos a realizar para desplegar el proyecto en local.

**NOTA:** Usaremos como ejemplo un proyecto llamado '*parkia*'.

1. Clonamos el repositorio:

    ```sh
    git clone git@github.com:novadevs-opensource/parkia.git
    ```

2. Nos ubicamos en él y vamos a la rama deseada:

    ```sh
    cd parkia
    git checkout develop
    ```

3. Creamos el archivo `docker/local/.env` usando como plantilla el archivo `docker/local/.env.dist`:

    ```sh
    cp -v docker/local/.env.dist docker/local/.env
    ```

4. Modificar los valores del archivo `docker/local/.env`. A continuación un ejemplo:

    ```yaml
    # Project configuration
    COMPOSE_PROJECT_NAME=local-parkia

    # Docker environment configuration
    DOCKER_NETWORK_NAME=local
    DOCKER_NETWORK_CIDR=192.17.203.0/24
    DOCKER_VOLUME_DB=db-data
    DOCKER_VOLUME_CODE=code-data

    # Users ids could retrieved by the command `id $USER`
    PUID=1000
    PGID=1000

    # Nginx
    NGINX_HOST_HTTP_PORT=8086
    NGINX_HOST_HTTPS_PORT=8087
    INSTALL_XDEBUG=true

    # Mysql
    MYSQL_PORT=33063
    MYSQL_ROOT_PASSWORD=R$$t_2022!
    MYSQL_DATABASE=db_parkia
    MYSQL_USER=dba_parkia
    MYSQL_PASSWORD=Db@_2022!

    # Mysql Testing
    MYSQL_TESTING_PORT=
    MYSQL_TESTING_ROOT_PASSWORD=R$$t_2022!
    MYSQL_TESTING_DATABASE=db_parkia-test
    MYSQL_TESTING_USER=dba_parkia-test
    MYSQL_TESTING_PASSWORD=Db@_T$T_2022!
    ```

    **NOTA:** Revisad previamente que no haya conflicto con otros proyectos en ejecución. Las líneas problemáticas son: 6, 15, 16, 20 y 27.

5. Crear los archivos: `.env` y `.env.testing` en la raíz del proyecto usando como plantilla el archivo `.env.example`:

    ```sh
    cp -v .env.example .env
    cp -v .env.example .env.testing
    ```

6. Modificamos el valor de ambos archivos, a continuación un ejemplo:

    **Archivo '.env' :**

    ```yaml
    APP_NAME=Parkia
    APP_ENV=local
    APP_KEY=
    APP_DEBUG=true
    APP_URL='http://parkia.local.novadevs.com'

    LOG_CHANNEL=stack
    LOG_DEPRECATIONS_CHANNEL=null
    LOG_LEVEL=debug

    DB_CONNECTION=mysql
    DB_HOST=local-parkia_db
    DB_PORT=3306
    DB_DATABASE=db_parkia
    DB_USERNAME=dba_parkia
    DB_PASSWORD=Db@_2022!

    BROADCAST_DRIVER=log
    CACHE_DRIVER=file
    FILESYSTEM_DRIVER=local
    QUEUE_CONNECTION=sync
    SESSION_DRIVER=file
    SESSION_LIFETIME=120

    MEMCACHED_HOST=127.0.0.1

    REDIS_HOST=127.0.0.1
    REDIS_PASSWORD=null
    REDIS_PORT=6379

    MAIL_MAILER=smtp
    MAIL_HOST=smtp.mailtrap.io
    MAIL_PORT=2525
    MAIL_USERNAME=
    MAIL_PASSWORD=
    MAIL_ENCRYPTION=tls
    MAIL_FROM_ADDRESS=
    MAIL_FROM_NAME="${APP_NAME}"

    PUSHER_APP_ID=
    PUSHER_APP_KEY=
    PUSHER_APP_SECRET=
    PUSHER_APP_CLUSTER=mt1
    MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
    MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"

    VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
    VITE_PUSHER_HOST="${PUSHER_HOST}"
    VITE_PUSHER_PORT="${PUSHER_PORT}"
    VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
    VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
    ```

    **Archivo '.env.testing':**

    ```yaml
    APP_NAME=Parkia
    APP_ENV=testing
    APP_KEY=
    APP_DEBUG=false
    APP_URL='http://parkia.local.novadevs.com'

    LOG_CHANNEL=stack
    LOG_DEPRECATIONS_CHANNEL=null
    LOG_LEVEL=debug

    DB_CONNECTION=mysql
    DB_HOST=local-parkia_db-testing
    DB_PORT=3306
    DB_DATABASE=db_parkia-test
    DB_USERNAME=dba_parkia-test
    DB_PASSWORD=Db@_T$T_2022!

    BROADCAST_DRIVER=log
    CACHE_DRIVER=file
    FILESYSTEM_DRIVER=local
    QUEUE_CONNECTION=sync
    SESSION_DRIVER=file
    SESSION_LIFETIME=120

    MEMCACHED_HOST=127.0.0.1

    REDIS_HOST=127.0.0.1
    REDIS_PASSWORD=null
    REDIS_PORT=6379

    MAIL_MAILER=smtp
    MAIL_HOST=smtp.mailtrap.io
    MAIL_PORT=2525
    MAIL_USERNAME=
    MAIL_PASSWORD=
    MAIL_ENCRYPTION=tls
    MAIL_FROM_ADDRESS=
    MAIL_FROM_NAME="${APP_NAME}"

    AWS_ACCESS_KEY_ID=
    AWS_SECRET_ACCESS_KEY=
    AWS_DEFAULT_REGION=us-east-1
    AWS_BUCKET=
    AWS_USE_PATH_STYLE_ENDPOINT=false

    PUSHER_APP_ID=
    PUSHER_APP_KEY=
    PUSHER_APP_SECRET=
    PUSHER_APP_CLUSTER=mt1
    MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
    MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"

    VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
    VITE_PUSHER_HOST="${PUSHER_HOST}"
    VITE_PUSHER_PORT="${PUSHER_PORT}"
    VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
    VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
    ```

    **NOTA:** Los valores de la base de datos así como del puerto de la aplicación se obtienen del archivo `docker/local/.env`.

7. A continuación, revisamos que las variables del archivo `Makefile` coinciden con lo establecido en el archivo `docker/local/.env`. A continuación un ejemplo:

    ```sh
    DOMAIN_NAME := 'parkia.local.novadevs.com'
    NGINX_CONTAINER := 'local-parkia_nginx'
    WEB_CONTAINER := 'local-parkia_php-fpm'
    WEB_IMG_LABEL := 'local-parkia'
    DB_CONTAINER := 'local-parkia_db'
    DB_CONTAINER_TESTING := 'local-parkia_db-testing'
    ```

8. Finalmente, desplegamos el entorno:

    ```sh
    make build
    ```
