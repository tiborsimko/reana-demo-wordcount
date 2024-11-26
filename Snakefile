# vim:syntax=python

papers = ["arXiv:2411.14404", "arXiv:2411.14368", "arXiv:2411.14214",
          "arXiv:2411.14033", "arXiv:2411.14012", "arXiv:2411.13932",
          "arXiv:2411.13867", "arXiv:2411.13749", "arXiv:2411.13653"]

rule all:
    input:
        "wordcount.txt"

rule download:
    output:
        "papers/{paper}.pdf"
    container:
        "docker://docker.io/tiborsimko/wordcount:1.0"
    resources:
        kubernetes_memory_limit="256Mi"
    shell:
        "mkdir -p papers && cd papers && curl -ko {wildcards.paper}.pdf https://arxiv.org/pdf/{wildcards.paper}"

rule convert:
    input:
        "papers/{paper}.pdf"
    output:
        "texts/{paper}.txt"
    container:
        "docker://docker.io/tiborsimko/wordcount:1.0"
    resources:
        kubernetes_memory_limit="256Mi"
    shell:
        "mkdir -p texts && pdftotext papers/{wildcards.paper}.pdf texts/{wildcards.paper}.txt"

rule count:
    input:
        "texts/{paper}.txt"
    output:
        "counts/{paper}.txt"
    container:
        "docker://docker.io/tiborsimko/wordcount:1.0"
    resources:
        kubernetes_memory_limit="256Mi"
    shell:
        "mkdir -p counts && wc -w {input} | cut -d' ' -f1 > {output}"

rule sum:
    input:
        expand("counts/{paper}.txt", paper=papers)
    output:
        "wordcount.txt"
    container:
        "docker://docker.io/tiborsimko/wordcount:1.0"
    resources:
        kubernetes_memory_limit="256Mi"
    shell:
        "cat {input} | paste -s -d+ | bc > {output}"
