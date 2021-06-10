{% from "alertmanager/map.jinja" import alertmanager with context %}

alertmanager:
  pkg.installed:
    - refresh: True
    - pkgs:
      {{ alertmanager.pkgs | yaml(False) | indent(6) }}

alertmanager_defaults_config:
  file.managed:
    - name: /etc/default/alertmanager
    - source: salt://alertmanager/templates/alertmanager.default
    - template: jinja
    - require:
      - pkg: alertmanager

{% if alertmanager.manage_config %}
alertmanager_config:
  file.managed:
    - name: {{ alertmanager.config_file }}
    - source: salt://alertmanager/templates/alertmanager.config
    - template: jinja
    - require:
      - pkg: alertmanager
{% endif %}

alertmanager_service:
  service.running:
    - name: alertmanager
    - enable: True
    - require:
      - pkg: alertmanager
    - watch:
{% if alertmanager.manage_config %}
      - file: alertmanager_config
{% endif %}
      - file: alertmanager_defaults_config
