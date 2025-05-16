{{- define "common.resources" -}}
{{- with include "common.resources.values" . -}}
resources:
{{- . | nindent 2 -}}
{{- end -}}
{{- end -}}

---

{{- define "common.resources.values" -}}
{{- $presetValue := include "common.resources._internal" . | fromYaml -}}
{{- if kindIs "map" . -}}
{{- if or (hasKey . "requests") (hasKey . "limits") -}}
{{/*common.resources.merge returns empty line so we fix it fromYaml | toYaml*/}}
{{- include "common.resources.merge" (list $presetValue .) | fromYaml | toYaml -}}
{{- else -}}
{{- $presetValue | toYaml -}}
{{- end -}}
{{- else -}}
{{- $presetValue | toYaml -}}
{{- end -}}
{{- end -}}

---

{{- define "common.resources._internal" -}}
{{- $requests_cpu := "" -}}
{{- $requests_cpu_preset := "" -}}
{{- $requests_memory := "" -}}
{{- $requests_memory_preset := "" -}}
{{- $limits_cpu := "" -}}
{{- $limits_cpu_preset := "" -}}
{{- $limitss_memory := "" -}}
{{- $limits_memory_preset := "" -}}

{{- if kindIs "string" . -}}
    {{- $requests_cpu_preset = . -}}
    {{- $requests_memory_preset = . -}}
    {{- $limits_cpu_preset = . -}}
    {{- $limits_memory_preset = . -}}
{{- end -}}

{{- if kindIs "slice" . -}}
    {{- $requests_cpu_preset = first . -}}
    {{- $requests_memory_preset = first . -}}
    {{- $limits_cpu_preset = last . -}}
    {{- $limits_memory_preset = last . -}}
{{- end -}}
{{- if kindIs "map" . -}}
    {{- if hasKey . "presets" -}}
        {{- $requests_cpu_preset = .presets.requests -}}
        {{- $requests_memory_preset = .presets.requests -}}
        {{- $limits_cpu_preset = default .presets.requests .presets.limits -}}
        {{- $limits_memory_preset = default .presets.requests .presets.limits  -}}
    {{- end -}}
{{- end -}}

{{- if not (empty $requests_cpu_preset) -}}
    {{- $requests_cpu = include "common.resources.utils.preset-value-picker"
        (list $requests_cpu_preset (include "common.resources.cpu-preset" $ | fromYaml) ) -}}
{{- end -}}
{{- if not (empty $requests_memory_preset) -}}
    {{- $requests_memory = include "common.resources.utils.preset-value-picker"
        (list $requests_memory_preset (include "common.resources.memory-preset" $ | fromYaml) ) -}}
{{- end -}}
{{- if not (empty $limits_cpu_preset) -}}
    {{- $limits_cpu = include "common.resources.utils.preset-value-picker"
        (list $limits_cpu_preset (include "common.resources.cpu-preset" $ | fromYaml) ) -}}
{{- end -}}
{{- if not (empty $limits_memory_preset) -}}
    {{- $limitss_memory = include "common.resources.utils.preset-value-picker"
        (list $limits_memory_preset (include "common.resources.memory-preset" $ | fromYaml) ) -}}
{{- end -}}

{{- if or (not (empty $requests_cpu)) (not (empty $requests_memory)) -}}
requests:
{{- with $requests_cpu }}
{{- if ne . "0" }}
  cpu: {{ . }}m
{{- end }}
{{- end }}
{{- with $requests_memory }}
{{- if ne . "0" }}
  memory: {{ . }}Mi
{{- end }}
{{- end }}
{{- end }}
{{- if or (not (empty $limits_cpu)) (not (empty $limitss_memory)) }}
limits:
{{- with $limits_cpu }}
{{- if ne . "0" }}
  cpu: {{ . }}m
{{- end }}
{{- end }}
{{- with $limitss_memory }}
{{- if ne . "0" }}
  memory: {{ . }}Mi
{{- end }}
{{- end }}
{{- end -}}

{{- end -}}
