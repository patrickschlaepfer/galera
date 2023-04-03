# galera

## Add Helm repo

    $ helm repo add bitnami https://charts.bitnami.com/bitnami

## Using just basic config

    $ helm install mariadb-galera-new --namespace=mariadb-galera-new --values values.yaml bitnami/mariadb-galera

## Using fully config

    $ helm install mariadb-galera-new --namespace=mariadb-galera-new -f fullConfig.yaml bitnami/mariadb-galera

## Connect from the cluster

To connect to your database run the following command:

    kubectl run mariadb-galera-new-client --rm --tty -i --restart='Never' --namespace mariadb-galera-new --image docker.io/bitnami/mariadb-galera:10.6.12-debian-11-r14 --command \
      -- mysql -h mariadb-galera-new -P 3306 -uroot -p$(kubectl get secret --namespace mariadb-galera-new mariadb-galera-new -o jsonpath="{.data.mariadb-root-password}" | base64 -d) my_database

## Connect from outside

To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace mariadb-galera-new svc/mariadb-galera-new 3306:3306 &
    mysql -h 127.0.0.1 -P 3306 -uroot -p$(kubectl get secret --namespace mariadb-galera-new mariadb-galera-new -o jsonpath="{.data.mariadb-root-password}" | base64 -d) my_database