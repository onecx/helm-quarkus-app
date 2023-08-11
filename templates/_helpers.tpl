{{- define "quarkus.fullname" -}}
    {{ .Release.Name }}-{{ .Values.name | default .Chart.Name }}
{{- end -}}

{{- define "quarkus.traefik.path" -}}
    {{ if .Values.routing.path }} && PathPrefix(`{{ .Values.routing.path }}`){{ end }}
{{- end -}}

{{- define "quarkus.routing.type" -}}
{{ if .Values.global.routing.type }}{{ .Values.global.routing.type }}{{ else }}{{ .Values.routing.type }}{{ end }}
{{- end -}}

{{- define "quarkus.routing.service" -}}
    {{- if .Values.routing.service.name -}}
        {{- .Values.routing.service.name -}}
    {{- else if .Values.service.name -}}
        {{- .Values.service.name -}}
    {{- else -}}
        {{- template "quarkus.fullname" $ }}
    {{- end -}}
{{- end -}}

{{- define "quarkus.db.host" -}}
    {{- if .Values.global.db.host -}}
        {{- .Values.global.db.host -}}
    {{- else if .Values.db.host -}}
        {{- .Values.db.host -}}
    {{- else -}}
        {{- template "quarkus.fullname" $ }}-postgresql
    {{- end -}}
{{- end -}}

{{- define "quarkus.db.port" -}}
    {{- if .Values.global.db.port -}}
        {{- .Values.global.db.port -}}
    {{- else -}}
        {{- .Values.db.port -}}
    {{- end -}}
{{- end -}}

{{- define "quarkus.db.database" -}}
    {{- if .Values.db.database -}}
      {{- .Values.db.database -}}
    {{- else -}}
      {{- if not .Values.db.internal -}}
        {{ .Release.Namespace | replace "1000kit" "tkit" | replace "-" "_" }}_{{ template "quarkus.fullname" $ | replace "-" "_" }}
      {{- else -}}
        {{ template "quarkus.fullname" $ | replace "-" "_" }}
      {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "quarkus.db.password" -}}
    {{- if .Values.db.password -}}
      {{- .Values.db.password -}}
    {{- else -}}
      {{ template "quarkus.fullname" $ | replace "-" "_" }}
    {{- end -}}
{{- end -}}

{{- define "quarkus.db.username" -}}
    {{- if .Values.db.username -}}
      {{- .Values.db.username -}}
    {{- else -}}
      {{- if not .Values.db.internal -}}
        {{ .Release.Namespace | replace "1000kit" "tkit" | replace "-" "_" }}_{{ template "quarkus.fullname" $ | replace "-" "_" }}
      {{- else -}}
        {{ template "quarkus.fullname" $ | replace "-" "_" }}
      {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "quarkus.db.admin.password" -}}
    {{- if .Values.global.db.admin.password -}}
        {{- .Values.global.db.admin.password -}}
    {{- else -}}
        {{- .Values.db.admin.password -}}
    {{- end -}}
{{- end -}}

{{- define "quarkus.db.admin.username" -}}
    {{- if .Values.global.db.admin.username -}}
        {{- .Values.global.db.admin.username -}}
    {{- else -}}
        {{- .Values.db.admin.username -}}
    {{- end -}}
{{- end -}}

{{- define "quarkus.db.admin.database" -}}
    {{- if .Values.global.db.admin.database -}}
        {{- .Values.global.db.admin.database -}}
    {{- else -}}
        {{- .Values.db.admin.database -}}
    {{- end -}}
{{- end -}}

{{- define "quarkus.db.url" -}}
    {{- if .Values.db.url -}}
        {{- .Values.db.url -}}
    {{- else -}}    
        "jdbc:postgresql://{{ include "quarkus.db.host" $ }}:{{ include "quarkus.db.port" $ }}/{{ include "quarkus.db.database" $ }}"
    {{- end -}}    
{{- end -}}

{{- define "quarkus.labels.common" -}}
version: {{ .Values.version | default .Values.image.tag | quote }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/name: {{ .Release.Name | quote }}
{{- end -}}

