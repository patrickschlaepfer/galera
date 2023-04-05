# galera

MariaDB Galera Cluster is a virtually synchronous multi-primary cluster for MariaDB.
It is available on Linux only, and only supports the InnoDB storage engine 
(although there is experimental support for MyISAM and, from MariaDB 10.6, Aria. 
See the wsrep_replicate_myisam system variable, or, from MariaDB 10.6, the wsrep_mode system variable).

## Links

* https://exploit.cz/helm-bitnami-mariadb-galera-hostpath-local-disk/amp/
* https://github.com/liqotech/liqo/blob/master/examples/stateful-applications/manifests/values.yaml


## Add Helm repo

if you haven't add the bitnami helm repo, add it

    $ helm repo add bitnami https://charts.bitnami.com/bitnami

## Using just basic config

    $ helm install mariadb-galera-new \
        --namespace=mariadb-galera-new \
        --values values.yaml bitnami/mariadb-galera

## Using fully config

    $ helm install mariadb-galera-new \
        --namespace=mariadb-galera-new \
        -f fullConfig.yaml bitnami/mariadb-galera

## Connect from the cluster

To connect to your database run the following command:

    kubectl run mariadb-galera-new-client --rm --tty -i --restart='Never' --namespace mariadb-galera-new --image docker.io/bitnami/mariadb-galera:10.6.12-debian-11-r14 --command \
      -- mysql -h mariadb-galera-new -P 3306 -uroot -p$(kubectl get secret --namespace mariadb-galera-new mariadb-galera-new -o jsonpath="{.data.mariadb-root-password}" | base64 -d) my_database

```
kubectl run db-mariadb-galera-client --rm --tty -i \
    --restart='Never' \
    --namespace default \
    --image docker.io/bitnami/mariadb-galera:10.6.7-debian-10-r56 \
    --command \
    -- mysql -h mariadb-galera-new.mariadb-galera-new.svc.cluster.local -uroot -pforch8127 my_database
```


## Connect from outside

To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace mariadb-galera-new svc/mariadb-galera-new 3306:3306 &
    mysql -h 127.0.0.1 -P 3306 -uroot \
      -p$(kubectl get secret --namespace mariadb-galera-new mariadb-galera-new -o jsonpath="{.data.mariadb-root-password}" | base64 -d) \
      my_database

```
kind: Service
apiVersion: v1
metadata:
  name: galera
spec:
  type: NodePort
  ports:
    - port: 3306
      targetPort: 3306
      nodePort: 30001
  selector:
    app.kubernetes.io/instance: mariadb-galera-new
    app.kubernetes.io/name: mariadb-galera
```