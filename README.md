# Helm template for Quarkus application

Default helm template for OneCX Quarkus application.

## Add to Quarkus apps

Add latest `0.x.x` version.

```yaml
dependencies:
  - name: helm-quarkus-app
    alias: app
    version: ^0
    repository: oci://ghcr.io/onecx/charts
```

### Config maps

- inject_maps - inject custom map environment variables

### Secrets

- env_secrets - map of env key and value which will be put in the secrets `{{ .Release.Name }}-{{ .Values.name | default .Chart.Name }}-env`

### Database

Default the internal database is `disabled`
The password for the database is store in the `{{ .Release.Name }}-{{ .Values.name | default .Chart.Name }}-db-config` secrets.

The database is created by the `tkit-db-operator`

#### Default configuration

External database.

- global.host, global.port will be use to setup the JDBC connection.
- Username, password and database will be set to Release.Name

```
app:
  image:
    repository: "onecx/${project.artifactId}"
    tag: ${project.version}
  db:
    enabled: true
```
