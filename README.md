# helm-quarkus-app

Helm Quarkus application

### Config maps

* inject_maps - inject custom map environment variables

### Secrets

* env_secrets - map of env key and value which will be put in the secrets `{{ .Release.Name }}-env`


### Database

Default the internal database is `disabled`
The password for the database is store in the `{{ .Release.Name }}-db-config` secrets.

The database is created by the `tkit-db-operator`

#### Default configuration

External database.
* global.host, global.port will be use to setup the JDBC connection.
* Username, password and database will be set to Release.Name

```
app:
  image:
    repository: "onecx/${project.artifactId}"
    tag: ${project.version}
  db:
    enabled: true
```

