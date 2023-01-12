FROM rocm/rocm-terminal:5.4 as rocm-gfx803
RUN sudo apt-get update && \
    sudo apt-get install -y wget unzip rocm-libs miopen-hip rccl libsndfile1-dev liblmdb-dev libopencv-highgui-dev libopencv-contrib-dev libopenblas-dev && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm541/rocblas_2.46.0.50401-84.20.04_amd64.deb -O rocblas.deb && \
    sudo dpkg -i rocblas.deb && \
    rm rocblas.deb
RUN sudo ln -s /opt/rocm/lib/libroctx64.so.4.1.0 /opt/rocm/lib/libroctx64.so.1 && \
    sudo ln -s /opt/rocm/lib/libroctracer64.so.4.1.0 /opt/rocm/lib/libroctracer64.so.1
ENV LD_LIBRARY_PATH=/opt/rocm/lib
COPY --from=continuumio/miniconda3:latest /opt/conda /opt/conda
ENV PATH=/opt/conda/bin:$PATH
COPY environment.yml .
RUN conda env create -q
RUN sudo ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate gfx803" >> ~/.bashrc

FROM gfx803 as rocm-gfx803-diff-svc
RUN git clone https://github.com/prophesier/diff-svc.git
WORKDIR /home/rocm-user/diff-svc
RUN cp ../environment.yml . && \
    echo '    - -r requirements_short.txt' >> environment.yml && \
    conda env update -q
RUN mkdir checkpoints && \
    cd checkpoints && \
    wget https://github.com/justinjohn0306/diff-svc/releases/download/models/0102_xiaoma_pe.zip && \
    unzip 0102_xiaoma_pe.zip && \
    rm 0102_xiaoma_pe.zip && \
    wget https://github.com/justinjohn0306/diff-svc/releases/download/models/hubert.zip && \
    unzip hubert.zip && \
    rm hubert.zip && \
    wget https://github.com/openvpi/vocoders/releases/download/nsf-hifigan-v1/nsf_hifigan_20221211.zip && \
    unzip nsf_hifigan_20221211.zip && \
    rm nsf_hifigan_20221211.zip
RUN mkdir pretrain && \
    cd pretrain && \
    wget https://huggingface.co/Erythrocyte/Diff-SVC_Pre-trained_Models/resolve/main/base_44.1KHz_384_20_110k.zip && \
    unzip base_44.1KHz_384_20_110k.zip -d base_44.1KHz_384_20_110k && \
    rm base_44.1KHz_384_20_110k.zip && \
    wget https://huggingface.co/Erythrocyte/Diff-SVC_Pre-trained_Models/resolve/main/base_44.1KHz_384_20_94k.zip && \
    unzip base_44.1KHz_384_20_94k.zip -d base_44.1KHz_384_20_94k && \
    rm base_44.1KHz_384_20_94k.zip && \
    wget https://huggingface.co/Erythrocyte/Diff-SVC_Pre-trained_Models/resolve/main/base_44.1KHz_384_20_50k.zip && \
    unzip base_44.1KHz_384_20_50k.zip -d base_44.1KHz_384_20_50k && \
    rm base_44.1KHz_384_20_50k.zip
CMD ["bash", "-l"]