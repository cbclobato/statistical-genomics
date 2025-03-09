FROM ubuntu:jammy

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    samtools picard-tools delly bcftools tabix igv less \
    && rm -rf /var/lib/apt/lists/*
