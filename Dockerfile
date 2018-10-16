# 
# Stand-alone tesseract-ocr web service in python.
# 
# Version: 0.0.3 
# Developed by Mark Peng (markpeng.ntu at gmail)
# 

FROM ubuntu:12.04

MAINTAINER guitarmind

RUN apt-get update && apt-get install -y \
  autoconf \
  automake \
  autotools-dev \
  build-essential \
  checkinstall \
  libjpeg-dev \
  libpng-dev \
  libtiff-dev \
  libtool \
  python \
  python-imaging \
  python-tornado \
  wget \
  zlib1g-dev

RUN mkdir ~/temp \
  && cd ~/temp/ \
  && wget https://github.com/DanBloomberg/leptonica/archive/v1.69.tar.gz \
  && tar -zxvf v1.69.tar.gz \
  && cd leptonica-1.69 \
  && chmod u+x configure \
  && ./configure \
  && make \
  && checkinstall \
  && ldconfig

RUN cd ~/temp/ \
  && wget https://github.com/tesseract-ocr/tesseract/archive/3.02.02.tar.gz \
  && tar xvf 3.02.02.tar.gz \
  && cd tesseract-3.02.02 \
  && ./autogen.sh \
  && mkdir ~/local \
  && chmod u+x configure \
  && ./configure --prefix=$HOME/local/ \
  && make \
  && make install \
  && cd ~/local/share \
  && wget https://downloads.sourceforge.net/project/tesseract-ocr-alt/tesseract-ocr-3.02.eng.tar.gz \
  && tar xvf tesseract-ocr-3.02.eng.tar.gz

ENV TESSDATA_PREFIX /root/local/share/tesseract-ocr

RUN mkdir -p /opt/ocr/static

COPY tesseractcapi.py /opt/ocr/tesseractcapi.py
COPY tesseractserver.py /opt/ocr/tesseractserver.py

RUN chmod 755 /opt/ocr/*.py 

EXPOSE 1688

WORKDIR /opt/ocr

CMD ["python", "/opt/ocr/tesseractserver.py", "-p", "1688", "-b", "/root/local/lib", "-d", "/root/local/share/tesseract-ocr" ]

