FROM python:3.11.13-slim

# Set environment variables
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook --no-browser --ip=0.0.0.0 --port=8888 --NotebookApp.token='' --NotebookApp.password=''"

# Install system dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ca-certificates \
    && apt-get clean

# Install OpenJDK 17 manually from Adoptium
RUN curl -L -o openjdk17.tar.gz https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9/OpenJDK17U-debugimage_x64_linux_hotspot_17.0.9_9.tar.gz \
    && mkdir -p /opt/java/openjdk \
    && tar -xzf openjdk17.tar.gz -C /opt/java/openjdk --strip-components=1 \
    && rm openjdk17.tar.gz

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install Python packages
RUN pip install --no-cache-dir \
    jupyter \
    notebook==6.4.12 \
    jupyter_contrib_nbextensions \
    pyspark==3.5.0 \
    pandas \
    matplotlib \
    seaborn \
    duckdb \
    jupyterlab==3.6.6 \
    jupyterlab-lsp \
    python-lsp-server \
    jupyterlab-git \
    nltk \
    wordcloud \
    plotly \
    xgboost \
    lightgbm \
    jupyter-tabnine

# Enable nbextensions
RUN jupyter contrib nbextension install --user
RUN jupyter nbextension enable hinterland/hinterland
RUN jupyter nbextension enable codefolding/main
RUN jupyter nbextension enable toc2/main
RUN jupyter serverextension enable --py jupyter_tabnine
RUN jupyter server extension enable jupyterlab_git

# Create working directories
WORKDIR /home/jovyan/work
VOLUME ["/home/jovyan/work"]
WORKDIR /home/jovyan/playground
VOLUME ["/home/jovyan/playground"]

# Expose Jupyter port
EXPOSE 8888

# Start Jupyter Notebook

CMD ["bash", "-c", "jupyter lab --no-browser --ip=0.0.0.0 --port=8888 --allow-root"]

