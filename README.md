# galera

MariaDB Galera Cluster is a virtually synchronous multi-primary cluster for MariaDB.
It is available on Linux only, and only supports the InnoDB storage engine 
(although there is experimental support for MyISAM and, from MariaDB 10.6, Aria. 
See the wsrep_replicate_myisam system variable, or, from MariaDB 10.6, the wsrep_mode system variable).

What does this do?

* Setups a mariadb-galera cluster
* Make the cluster available from outside
* Adds prometheus endpoint
* Adds adminer gui for basic admin

## Links

* https://exploit.cz/helm-bitnami-mariadb-galera-hostpath-local-disk/amp/
* https://github.com/liqotech/liqo/blob/master/examples/stateful-applications/manifests/values.yaml
* https://docs.openshift.com/container-platform/4.10/monitoring/enabling-monitoring-for-user-defined-projects.html
* https://quarkus.io/blog/micrometer-prometheus-openshift/


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

## Update config

If changing values you can update them by using the following command

```
helm upgrade -f values.yaml mariadb-galera-new \
  bitnami/mariadb-galera \
  --reuse-values 
```

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

Install the mysql client package

    $ sudo apt install mysql-client

To connect to your database from outside the cluster have a look at `04_service.yaml` and
`05_route.yaml`

    $ mysql -h mysql.apps.ocp1.internal.schlaepfer.com -P 30036 -uroot -pforch8127 my_database

## Export metrics

### Enable external monitoring

* https://docs.openshift.com/container-platform/4.10/monitoring/enabling-monitoring-for-user-defined-projects.html

### Setup metrics

If you set the value `metrics.enabled: true` then there will be a new service
called `mariadb-galera-new-metrics` created.

Apply `06_metric_route.yaml` and the metrics will be available by 

    $ curl https://mariadb-galera-new-metrics-mariadb-galera-new.apps.ocp1.internal.schlaepfer.com/metrics -k

Check for the port

    $ oc describe service/mariadb-galera-new-metrics


## adminer SQL 

Add the repo

    $ helm repo add truecharts https://charts.truecharts.org/
    $ helm repo update

Install the chart

    $ helm install adminer truecharts/adminer --version 3.0.15 --namespace=adminer

Add a route

    $ oc create route edge --service=adminer
