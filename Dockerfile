FROM rocm/rocm-terminal:5.4
RUN sudo apt-get update && \
    sudo apt-get install -y wget rocm-libs miopen-hip rccl libsndfile1-dev liblmdb-dev libopencv-highgui-dev libopencv-contrib-dev libopenblas-dev && \
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
COPY environment.yml /tmp
RUN conda env create -q -f /tmp/environment.yml
RUN sudo ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate gfx803" >> ~/.bashrc
CMD ["bash", "-l"]