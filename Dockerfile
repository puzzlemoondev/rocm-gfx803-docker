FROM rocm/rocm-terminal
ENV LD_LIBRARY_PATH=/opt/rocm/lib
ADD https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm541/rocblas_2.46.0.50401-84.20.04_amd64.deb /tmp
RUN sudo dpkg -i /tmp/rocblas_2.46.0.50401-84.20.04_amd64.deb
COPY --from=continuumio/miniconda3:latest /opt/conda /opt/conda
ENV PATH=/opt/conda/bin:$PATH
COPY environment.yml .
RUN conda env create -f environment.yml
RUN sudo ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate gfx803" >> ~/.bashrc
CMD ["/bin/bash"]