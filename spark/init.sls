{% from "spark/map.jinja" import spark with context %}
{# TODO: abstract this for different package managers #}
openjdk-7-jdk:
  pkg.installed


spark:
  archive.extracted:
    - name : {{ spark.install_dir }}
    - source: {{ spark.source }}
    - source_hash: {{ spark.source_hash}}
    - archive_format: tar
    - tar_options: z --strip-components=1
    - if_missing: {{ spark.install_dir }}bin/pyspark
    - user: root
    - group: root
    - require:
      - pkg: openjdk-7-jdk

/etc/profile.d/30-spark-profile.sh:
  file.managed:
    - source: salt://spark/30-spark-profile.sh.template
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja

{# If we are adding the google cloud storage connector #}
{# TODO: un-hardcode this #}
{% if spark.gs is defined %}
{{ spark.install_dir }}/lib/gcs-connector-latest-hadoop2.jar:
  file.managed:
    - source: https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-latest-hadoop2.jar
    - source_hash: 'md5=839a053f56e2844861ed8c4a34c16a79'


{{ spark.install_dir }}/conf/core-site.xml:
  file.managed:
    - source: salt://spark/core-site.xml.template
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
{% endif %}