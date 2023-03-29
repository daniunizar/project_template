# Despliegue en local

A continuación se indican los pasos a realizar para desplegar el proyecto en local.

1. Clonamos el repositorio:

    ```sh
    git clone git@github.com:novadevs-opensource/voyalteatro.git
    ```

2. Nos ubicamos en él y vamos a la rama deseada:

    ```sh
    cd voyalteatro
    git checkout develop
    ```

3. Creamos el archivo `docker/local/.env` usando como plantilla el archivo `docker/local/.env.dist`:

    ```sh
    cp -v docker/local/.env.dist docker/local/.env
    ```

4. Modificar los valores del archivo `docker/local/.env`. A continuación un ejemplo:

    ```yaml
    # Project configuration
    COMPOSE_PROJECT_NAME=local-voyalteatro

    # Docker environment configuration
    DOCKER_NETWORK_NAME=local
    DOCKER_NETWORK_CIDR=192.17.26.0/24
    DOCKER_VOLUME_DB=db-data

    # Users ids could retrieved by the command `id $USER`
    PUID=1000
    PGID=1000

    # Nginx
    NGINX_HOST_HTTP_PORT=9090
    NGINX_HOST_HTTPS_PORT=9091
    INSTALL_XDEBUG=true

    # Mysql
    MYSQL_PORT=33060
    MYSQL_ROOT_PASSWORD=root
    MYSQL_DATABASE=db_voyalteatro
    MYSQL_USER=dba_voyalteatro
    MYSQL_PASSWORD=DB@_2023!

    # Mysql Testing
    MYSQL_TESTING_PORT=
    MYSQL_TESTING_ROOT_PASSWORD=root
    MYSQL_TESTING_DATABASE=db_voyalteatro-test
    MYSQL_TESTING_USER=dba_voyalteatro-test
    MYSQL_TESTING_PASSWORD=DB@_T3T_2023!
    ```

    **NOTA:** Revisad previamente que no haya conflicto con otros proyectos en ejecución. Las líneas problemáticas son: 6, 15, 16, 20 y 27.

5. Crear los archivos: `.env` y `.env.testing` en la raíz del proyecto usando como plantilla el archivo `.env.example`:

    ```sh
    cp -v .env.example .env
    cp -v .env.example .env.testing
    ```

6. Modificamos el valor de ambos archivos, a continuación un ejemplo:

    **Archivo '.env' :**

    ```text
    APP_NAME=Voyalteatro
    APP_ENV=local
    APP_KEY=
    APP_DEBUG=true
    APP_URL=http://local-voyalteatro.local.novadevs.com

    LOG_CHANNEL=stack
    LOG_DEPRECATIONS_CHANNEL=null
    LOG_LEVEL=debug

    DB_CONNECTION=mysql
    DB_HOST=local-voyalteatro_db
    DB_PORT=3306
    DB_DATABASE=db_voyalteatro
    DB_USERNAME=dba_voyalteatro
    DB_PASSWORD=DB@_2023!

    BROADCAST_DRIVER=log
    CACHE_DRIVER=file
    FILESYSTEM_DISK=local
    QUEUE_CONNECTION=sync
    SESSION_DRIVER=file
    SESSION_LIFETIME=120

    MEMCACHED_HOST=127.0.0.1

    REDIS_HOST=127.0.0.1
    REDIS_PASSWORD=null
    REDIS_PORT=6379

    MAIL_MAILER=smtp
    MAIL_HOST=mailhog
    MAIL_PORT=1025
    MAIL_USERNAME=null
    MAIL_PASSWORD=null
    MAIL_ENCRYPTION=null
    MAIL_FROM_ADDRESS="hello@example.com"
    MAIL_FROM_NAME="${APP_NAME}"

    AWS_ACCESS_KEY_ID=
    AWS_SECRET_ACCESS_KEY=
    AWS_DEFAULT_REGION=us-east-1
    AWS_BUCKET=
    AWS_USE_PATH_STYLE_ENDPOINT=false

    PUSHER_APP_ID=
    PUSHER_APP_KEY=
    PUSHER_APP_SECRET=
    PUSHER_HOST=
    PUSHER_PORT=443
    PUSHER_SCHEME=https
    PUSHER_APP_CLUSTER=mt1

    VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
    VITE_PUSHER_HOST="${PUSHER_HOST}"
    VITE_PUSHER_PORT="${PUSHER_PORT}"
    VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
    VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
    ```

    **Archivo '.env.testing':**

    ```text
    APP_NAME=Voyalteatro
    APP_ENV=local
    APP_KEY=
    APP_DEBUG=true
    APP_URL=http://local-voyalteatro.local.novadevs.com

    LOG_CHANNEL=stack
    LOG_DEPRECATIONS_CHANNEL=null
    LOG_LEVEL=debug

    DB_CONNECTION=mysql
    DB_HOST=local-voyalteatro_db-testing
    DB_PORT=3306
    DB_DATABASE=db_voyalteatro-test
    DB_USERNAME=dba_voyalteatro-test
    DB_PASSWORD=DB@_T3T_2023!

    BROADCAST_DRIVER=log
    CACHE_DRIVER=file
    FILESYSTEM_DISK=local
    QUEUE_CONNECTION=sync
    SESSION_DRIVER=file
    SESSION_LIFETIME=120

    MEMCACHED_HOST=127.0.0.1

    REDIS_HOST=127.0.0.1
    REDIS_PASSWORD=null
    REDIS_PORT=6379

    MAIL_MAILER=smtp
    MAIL_HOST=mailhog
    MAIL_PORT=1025
    MAIL_USERNAME=null
    MAIL_PASSWORD=null
    MAIL_ENCRYPTION=null
    MAIL_FROM_ADDRESS="hello@example.com"
    MAIL_FROM_NAME="${APP_NAME}"

    AWS_ACCESS_KEY_ID=
    AWS_SECRET_ACCESS_KEY=
    AWS_DEFAULT_REGION=us-east-1
    AWS_BUCKET=
    AWS_USE_PATH_STYLE_ENDPOINT=false

    PUSHER_APP_ID=
    PUSHER_APP_KEY=
    PUSHER_APP_SECRET=
    PUSHER_HOST=
    PUSHER_PORT=443
    PUSHER_SCHEME=https
    PUSHER_APP_CLUSTER=mt1

    VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
    VITE_PUSHER_HOST="${PUSHER_HOST}"
    VITE_PUSHER_PORT="${PUSHER_PORT}"
    VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
    VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
    ```

    **NOTA:** Los valores de la base de datos así como del puerto de la aplicación se obtienen del archivo `docker/local/.env`.

7. A continuación, revisamos que las variables del archivo `Makefile` coinciden con lo establecido en el archivo `docker/local/.env`. A continuación un ejemplo:

    ```text
    DOMAIN_NAME := 'local-voyalteatro.local.novadevs.com'
    HTTP_PORT := '9090'
    HTTPS_PORT := '9091'
    NGINX_CONTAINER := 'local-voyalteatro_nginx'
    WEB_CONTAINER := 'local-voyalteatro_php-fpm'
    WEB_IMG_LABEL := 'local-voyalteatro'
    DB_CONTAINER := 'local-voyalteatro_db'
    DB_CONTAINER_TESTING := 'local-voyalteatro_db-testing'
    ```

8. Finalmente, desplegamos el entorno:

    ```sh
    make build
    ```
