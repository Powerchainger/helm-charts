{{/*How to use: include "common.resources.cpu-preset" $ | fromYaml */}}
{{- define "common.resources.cpu-preset" -}}
{{- $presets := dict
    "none" 0
    "nano" 100
    "tiny" 200
    "small" 400
    "medium" 800
    "large" 1000
    "grand" 1500
    "2xLarge" 2000
    "3xLarge" 3000
-}}
{{- $presets | toYaml }}
{{- end -}}

---

{{/*How to use: include "common.resources.memory-preset" $ | fromYaml */}}
{{- define "common.resources.memory-preset" -}}
{{- $presets := dict
    "none" 0
    "nano" 128
    "tiny" 256
    "small" 512
    "medium" 1024
    "large" 1280
    "grand" 1920
    "2xLarge" 2560
    "3xLarge" 3584
-}}
{{- $presets | toYaml }}
{{- end -}}

---

{{/*How to use: include "common.resources.utils.preset-value-picker" (list "small" (include "common.resources.cpu-preset" $ | fromYaml) ) */}}
{{- define "common.resources.utils.preset-value-picker" -}}
{{- $preset_type := first . -}}
{{- $preset_values := last . -}}
{{- if hasKey $preset_values $preset_type -}}
{{- index $preset_values $preset_type -}}
{{- else -}}
{{- printf "ERROR: Preset key '%s' invalid. Allowed values are %s" $preset_type (join "," (keys $preset_values)) | fail -}}
{{- end -}}
{{- end -}}