FROM ghcr.io/smkwlab/textlint-image:latest

ARG TEXLIVE_VERSION=2022

ENV PATH="/usr/local/texlive/bin:$PATH"

RUN apk --update-cache add \
        curl \
        make \
        wget \
        python3 \
        fontconfig-dev \
        freetype-dev \
        ghostscript \
        perl \
        git \
        poppler-utils \
        msttcorefonts-installer

RUN apk --update-cache add \
        alpine-sdk \
        perl-dev \
        perl-utils \
        py3-pip \
        python3-dev && \
    echo 'y' | cpan YAML/Tiny.pm Log::Dispatch::File File::HomeDir Unicode::GCString && \
    pip3 install --no-cache-dir pygments && \
    mkdir /tmp/install-tl-unx && \
    wget -O - ftp://tug.org/historic/systems/texlive/${TEXLIVE_VERSION}/install-tl-unx.tar.gz \
        | tar -xzv -C /tmp/install-tl-unx --strip-components=1 && \
    /bin/echo -e 'selected_scheme scheme-basic\ntlpdbopt_install_docfiles 0\ntlpdbopt_install_srcfiles 0' \
        > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
        --profile /tmp/install-tl-unx/texlive.profile && \
    rm -r /tmp/install-tl-unx && \
    ln -sf /usr/local/texlive/${TEXLIVE_VERSION}/bin/$(uname -m)-linuxmusl /usr/local/texlive/bin && \
    apk del --purge \
        python3-dev \
        py3-pip \
        perl-utils \
        perl-dev \
        alpine-sdk

RUN tlmgr option repository ctan && \
    tlmgr update --self && \
    tlmgr install \
        collection-bibtexextra \
        collection-fontsrecommended \
        collection-langenglish \
        collection-langjapanese \
        collection-latexextra \
        collection-latexrecommended \
        collection-luatex \
        collection-mathscience \
        collection-plaingeneric \
        collection-xetex \
        latexmk \
        latexdiff \
        siunitx \
        latexindent

WORKDIR /workdir
