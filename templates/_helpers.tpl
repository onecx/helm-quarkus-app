{{- define "app.fullname" -}}
    {{- if or .Values.product (not (hasKey .Values "product")) -}}
        {{ .Release.Name }}-{{ .Values.name | default .Chart.Name }}
    {{- else -}}
        {{ .Release.Name }}
    {{- end -}}
{{- end -}}

{{- define "app.product.name" -}}
    {{ .Release.Name }}
{{- end -}}


{{- define "app.version" -}}
    {{ .Values.image.tag }} 
{{- end -}}

{{- define "app.id" -}}
    {{ if .Values.routing.backend }}{{ .Values.appId }}{{ else  }}{{ template "app.fullname" $ }}{{ end }}
{{- end -}}

{{- define "app.routing.type" -}}
{{ if .Values.global.routing.type }}{{ .Values.global.routing.type }}{{ else }}{{ .Values.routing.type }}{{ end }}
{{- end -}}

{{- define "app.image.tag" -}}
    {{- if .Values.image.suffix -}}
        {{ .Values.image.tag }}{{ .Values.image.separator }}{{ .Values.image.suffix }}
    {{- else -}}
        {{ .Values.image.tag }}
    {{- end -}}
{{- end -}}

{{- define "app.db.check.image.tag" -}}
    {{- if .Values.db.check.image.suffix -}}
        {{ .Values.db.check.image.tag }}{{ .Values.db.check.image.separator }}{{ .Values.db.check.image.suffix }}
    {{- else -}}
        {{ .Values.db.check.image.tag }}
    {{- end -}}
{{- end -}}

{{- define "app.routing.service" -}}
    {{- if .Values.routing.service.name -}}
        {{- .Values.routing.service.name -}}
    {{- else if .Values.service.name -}}
        {{- .Values.service.name -}}
    {{- else -}}
        {{- template "app.fullname" $ }}
    {{- end -}}
{{- end -}}

{{- define "app.db.host" -}}
    {{- if .Values.global.db.host -}}
        {{- .Values.global.db.host -}}
    {{- else if .Values.db.host -}}
        {{- .Values.db.host -}}
    {{- else -}}
        {{- template "app.fullname" $ }}-postgresql
    {{- end -}}
{{- end -}}

{{- define "app.db.port" -}}
    {{- if .Values.global.db.port -}}
        {{- .Values.global.db.port -}}
    {{- else -}}
        {{- .Values.db.port -}}
    {{- end -}}
{{- end -}}

{{- define "app.db.database" -}}
    {{- if .Values.db.database -}}
      {{- .Values.db.database -}}
    {{- else -}}
        {{ include "app.fullname" $ | replace "-" "_" }}
    {{- end -}}
{{- end -}}

{{- define "app.db.password" -}}
    {{- if .Values.db.password -}}
      {{- .Values.db.password -}}
    {{- else -}}
      {{ include "app.fullname" $ | replace "-" "_" }}
    {{- end -}}
{{- end -}}

{{- define "app.db.username" -}}
    {{- if .Values.db.username -}}
      {{- .Values.db.username -}}
    {{- else -}}
        {{ include "app.fullname" $ | replace "-" "_" }}
    {{- end -}}
{{- end -}}

{{- define "app.db.url" -}}
    {{- if .Values.db.url -}}
        {{- .Values.db.url -}}
    {{- else -}}    
        "jdbc:postgresql://{{ include "app.db.host" $ }}:{{ include "app.db.port" $ }}/{{ include "app.db.database" $ }}"
    {{- end -}}    
{{- end -}}

{{- define "app.backend.host" -}}
    {{ if .Values.routing.host.override }}  
        {{ .Values.routing.host.override }}
    {{ else if .Values.routing.host.name }}
        {{ .Values.routing.host.name }}-{{ .Release.Namespace }}
    {{ else }}
        {{ template "app.fullname" $ }}-{{ .Release.Namespace }}
    {{ end }}
{{- end -}}

{{- define "app.ingress.host" -}}
    {{ if and .Values.routing.bff .Values.routing.hostName }}
        {{ .Values.routing.hostName }}
    {{ else if and .Values.routing.bff .Values.global.hostName }}
        {{ .Values.global.hostName }}
    {{ else }}
        {{ include "app.backend.host" . | trim }}.{{ .Values.global.default_url | default .Values.routing.default_url }}
    {{ end }}
{{- end -}}

{{- define "app.oidc.client.url" -}}
    {{- if .Values.oidc.client.url -}}  
        {{- .Values.oidc.client.url -}}
    {{- else if .Values.global.oidc.client.url -}}
        {{- .Values.global.oidc.client.url -}}
    {{- else -}}
        {{ "${" }}{{-  .Values.template.oidc_server_url -}}{{ "}" }}
    {{- end -}}
{{- end -}}

{{- define "app.oidc.client.secret.name" -}}
    {{ template "app.fullname" $ }}-kc-client-config
{{- end -}}

{{- define "app.oidc.client.password" -}}
    {{- if .Values.operator.keycloak.client.password -}}
      {{- .Values.operator.keycloak.client.password -}}
    {{- else -}}
      {{ include "app.fullname" $ | replace "-" "_" }}
    {{- end -}}
{{- end -}}

{{- define "app.permission.product.name" -}}
    {{- if .Values.operator.permission.spec.productName -}}
        {{- .Values.operator.permission.spec.productName -}}
    {{- else -}}
        {{ include "app.product.name" $ }}
    {{- end -}}
{{- end -}}

{{- define "app.microservice.product.name" -}}
    {{- if .Values.operator.microservice.spec.productName -}}
        {{- .Values.operator.microservice.spec.productName -}}
    {{- else -}}
        {{ include "app.product.name" $ }}
    {{- end -}}
{{- end -}}

{{- define "app.labels.common" -}}
version: {{ .Values.version | default .Values.image.tag | quote }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/name: {{ template "app.fullname" $ }}
{{- end -}}

