{{/*
Expand the name of the chart.
*/}}
{{- define "baremetal-network-tester.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "baremetal-network-tester.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "baremetal-network-tester.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "baremetal-network-tester.labels" -}}
helm.sh/chart: {{ include "baremetal-network-tester.chart" . }}
{{ include "baremetal-network-tester.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "baremetal-network-tester.selectorLabels" -}}
app.kubernetes.io/name: {{ include "baremetal-network-tester.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "baremetal-network-tester.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "baremetal-network-tester.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "baremetal-network-tester.clusterRoleName" -}}
{{- default (include "baremetal-network-tester.fullname" .) .Values.clusterRole.name }}
{{- end }}

{{- define "baremetal-network-tester.validate" -}}
{{- $cluster := required "cluster is required: pass using --set cluster=<cluster-name>" $.Values.cluster -}}
{{- end }}
