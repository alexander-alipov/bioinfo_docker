# Bioinfo Docker Image v1.0.0 - 18-05-2025

# Базовый образ
FROM ubuntu:22.04

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    pkg-config \
    git \
    autoconf \
    automake \
    libtool \
    libxml2-dev \
    libdeflate-dev \
    && rm -rf /var/lib/apt/lists/*

# Создание директории для софта
ENV SOFT=/soft
RUN mkdir -p $SOFT

# Установка htslib (версия 1.17)
RUN cd $SOFT && \
    wget https://github.com/samtools/htslib/releases/download/1.17/htslib-1.17.tar.bz2  && \
    tar -xjf htslib-1.17.tar.bz2 && \
    cd htslib-1.17 && \
    ./configure --prefix=$SOFT/htslib-1.17 && \
    make -j$(nproc) && \
    make install && \
    rm -rf $SOFT/htslib-1.17.tar.bz2

# Добавление htslib в PATH и пути к библиотекам
ENV PATH=$SOFT/htslib-1.17/bin:$PATH
ENV CPATH=$SOFT/htslib-1.17/include:$CPATH
ENV LIBRARY_PATH=$SOFT/htslib-1.17/lib:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=$SOFT/htslib-1.17/lib:$LD_LIBRARY_PATH

# Установка samtools (версия 1.17)
RUN cd $SOFT && \
    wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2  && \
    tar -xjf samtools-1.17.tar.bz2 && \
    cd samtools-1.17 && \
    ./configure --prefix=$SOFT/samtools-1.17 --with-htslib-prefix=$SOFT/htslib-1.17 && \
    make -j$(nproc) && \
    make install && \
    rm -rf $SOFT/samtools-1.17.tar.bz2

# Добавление samtools в PATH
ENV PATH=$SOFT/samtools-1.17/bin:$PATH
ENV SAMTOOLS=$SOFT/samtools-1.17/bin/samtools

# Установка bcftools (версия 1.17)
RUN cd $SOFT && \
    wget https://github.com/samtools/bcftools/releases/download/1.17/bcftools-1.17.tar.bz2  && \
    tar -xjf bcftools-1.17.tar.bz2 && \
    cd bcftools-1.17 && \
    ./configure --prefix=$SOFT/bcftools-1.17 --with-htslib-prefix=$SOFT/htslib-1.17 && \
    make -j$(nproc) && \
    make install && \
    rm -rf $SOFT/bcftools-1.17.tar.bz2

# Добавление bcftools в PATH
ENV PATH=$SOFT/bcftools-1.17/bin:$PATH
ENV BCFTOOLS=$SOFT/bcftools-1.17/bin/bcftools

# Установка vcftools (версия 0.1.16)
RUN cd $SOFT && \
    wget https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz  && \
    tar -xzf vcftools-0.1.16.tar.gz && \
    cd vcftools-0.1.16 && \
    ./autogen.sh && \
    ./configure --prefix=$SOFT/vcftools-0.1.16 && \
    make -j$(nproc) && \
    make install && \
    rm -rf $SOFT/vcftools-0.1.16.tar.gz

# Добавление vcftools в PATH
ENV PATH=$SOFT/vcftools-0.1.16/bin:$PATH
ENV VCFTOOLS=$SOFT/vcftools-0.1.16/bin/vcftools

# Очистка кэша
RUN apt-get autoremove -y && apt-get clean

# Установка Python и зависимостей
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Установка Python-библиотек
RUN pip3 install pandas pysam && \
    pip3 cache purge && \
    rm -rf /root/.cache/pip

# Копирование скрипта внутрь контейнера
COPY FP_SNPs_script.py /usr/local/bin/FP_SNPs_script.py
