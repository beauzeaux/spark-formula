{% from "spark/map.jinja" import spark with context %}

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

/etc/profile.d/30-spark-profile.sh:
  file.managed:
    - source: salt://spark/30-spark-profile.sh.template
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
