# Базовый образ
FROM ubuntu:22.04

# Установка общих зависимостей
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    curl \
    autoconf \
    libncurses5-dev \
    pkg-config \         
    libtool \            
    && rm -rf /var/lib/apt/lists/*
    
# Создание директории для софта
ENV SOFT=/soft
RUN mkdir -p $SOFT

# Установка samtools (версия 1.17)
# Официальный репозиторий: https://github.com/samtools/samtools
RUN cd $SOFT && \
    wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 && \
    tar -xjf samtools-1.17.tar.bz2 && \
    cd samtools-1.17 && \
    ./configure --prefix=$SOFT/samtools-1.17 && \
    make -j$(nproc) && \
    make install && \
    rm -rf $SOFT/samtools-1.17.tar.bz2
    
# Добавление в PATH
ENV PATH=$SOFT/samtools-1.17/bin:$PATH
ENV SAMTOOLS=$SOFT/samtools-1.17/bin/samtools

# Установка bcftools (версия 1.17)
# Официальный репозиторий: https://github.com/samtools/bcftools
RUN cd $SOFT && \
    wget https://github.com/samtools/bcftools/releases/download/1.17/bcftools-1.17.tar.bz2 && \
    tar -xjf bcftools-1.17.tar.bz2 && \
    cd bcftools-1.17 && \
    ./configure --prefix=$SOFT/bcftools-1.17 && \
    make -j$(nproc) && \
    make install && \
    rm -rf $SOFT/bcftools-1.17.tar.bz2

ENV PATH=$SOFT/bcftools-1.17/bin:$PATH
ENV BCFTOOLS=$SOFT/bcftools-1.17/bin/bcftools

# Установка vcftools (версия 0.1.16)
# Официальный репозиторий: https://github.com/vcftools/vcftools
RUN cd $SOFT && \
    wget https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz && \
    tar -xzf vcftools-0.1.16.tar.gz && \
    cd vcftools-0.1.16 && \
    ./autogen.sh && \
    ./configure --prefix=$SOFT/vcftools-0.1.16 && \
    make -j$(nproc) && \
    make install && \
    rm -rf $SOFT/vcftools-0.1.16.tar.gz

ENV PATH=$SOFT/vcftools-0.1.16/bin:$PATH
ENV VCFTOOLS=$SOFT/vcftools-0.1.16/bin/vcftools

# Очистка кэша
RUN apt-get autoremove -y && apt-get clean
