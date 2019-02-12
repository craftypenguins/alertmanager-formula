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

alertmanager_config:
  file.managed:
    - name: {{ alertmanager.config_file }}
    - source: salt://alertmanager/templates/alertmanager.config
    - template: jinja
    - require:
      - pkg: alertmanager

alertmanager_service:
  service.running:
    - name: alertmanager
    - enable: True
    - require:
      - pkg: alertmanager
    - watch:
      - file: alertmanager_config
      - file: alertmanager_defaults_config
