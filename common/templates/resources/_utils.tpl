{{- define "common.resources.merge" -}}
{{- $original := first . -}}
{{- $overrides := last . -}}
{{- $merged := (merge $overrides $original) -}}

{{- $requests_cpu := dig "requests" "cpu" "none" $merged -}}
{{- $requests_memory := dig "requests" "memory" "none" $merged -}}
{{- $limits_cpu := dig "limits" "cpu" "none" $merged -}}
{{- $limitss_memory := dig "limits" "memory" "none" $merged -}}

{{- include "common.resources._internal_composer"  (list $requests_cpu $requests_memory $limits_cpu $limitss_memory) -}}
{{- end -}}

---

{{- define "common.resources._internal_composer" -}}
{{- $requests_cpu := (index . 0) -}}
{{- $requests_memory := (index . 1)  -}}
{{- $limits_cpu := (index . 2)  -}}
{{- $limitss_memory := (index . 3)  -}}
{{- if or (and (ne $requests_cpu "0") (ne $requests_cpu "none")) (and (ne $requests_memory "0") (ne $requests_memory "none")) }}
requests:
{{- with $requests_cpu }}
{{- if and (ne . "0") (ne . "none") }}
  cpu: {{ . }}
{{- end }}
{{- end }}
{{- with $requests_memory }}
{{- if and (ne . "0") (ne . "none") }}
  memory: {{ . }}
{{- end }}
{{- end }}
{{- end }}
{{- if or (and (ne $limits_cpu "0") (ne $limits_cpu "none")) (and (ne $limitss_memory "0") (ne $limitss_memory "none")) }}
limits:
{{- with $limits_cpu }}
{{- if and (ne . "0") (ne . "none") }}
  cpu: {{ . }}
{{- end }}
{{- end }}
{{- with $limitss_memory }}
{{- if and (ne . "0") (ne . "none") }}
  memory: {{ . }}
{{- end }}
{{- end }}
{{- end -}}
{{- end -}}