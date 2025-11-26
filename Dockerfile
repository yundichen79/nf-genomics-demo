FROM condaforge/mambaforge:latest

RUN mamba create -y -n rnaseq-env -c bioconda -c conda-forge \
        fastqc \
        fastp \
        hisat2 \
        samtools \
    && mamba clean -afy

SHELL ["bash", "-lc"]
ENV CONDA_DEFAULT_ENV=rnaseq-env
ENV PATH=/opt/conda/envs/rnaseq-env/bin:$PATH

WORKDIR /workspace

CMD echo "fastqc: $(fastqc --version | head -n 1)"; \
    echo "fastp:  $(fastp --version 2>&1 | head -n 1)"; \
    echo "hisat2: $(hisat2 --version | head -n 1)"; \
    echo "samtools: $(samtools --version | head -n 1)"; \
    bash