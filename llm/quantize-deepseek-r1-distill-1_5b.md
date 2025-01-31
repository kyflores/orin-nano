# Make a workdir
```
mkdir -p /data
chown $USER /data
```

# Build llama.cpp
```
cd /data
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
CUDACXX=/usr/local/cuda/bin/nvcc cmake -B build -DGGML_CUDA=ON
cd build
make -j6
```

# Get the model
```
cd /data
git lfs install
git clone https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B
```

# TODO setup imatrix for calibration (optional)
First we need some text to use for the imatrix computation.
Here's an [example from bartowski1182](https://gist.github.com/bartowski1182/eb213dccb3571f863da82e99418f81e8)
```
cd /data
/data/llamacpp/build/bin/llama-imatrix -m DeepSeek-R1-Distill-Qwen-1.5B-F16.gguf -f calibration.txt -ngl 256
```

# Quantize
```
cd /data

# First make a venv and activate it. Then...
virtualenv ptvenv
source ptvenv/bin/activate

# Install llama requirements manually bc torch dependency breaks on jetson torch
export PIP_INDEX_URL=http://jetson.webredirect.org/jp6/cu126
export PIP_TRUSTED_HOST=jetson.webredirect.org
pip install "torch torchvision numpy==1.26.4 sentencepiece transformers gguf protobuf<5.0.0"

cd llama.cpp
python convert_hf_to_gguf.py /data/DeepSeek-R1-Distill-Qwen-1.5B/

/data/llama.cpp/build/bin/llama-quantize /data/DeepSeek-R1-Distill-Qwen-1.5B/DeepSeek-R1-Distill-Qwen-1.5B-F16.gguf /data/DeepSeek-R1-Distill-Qwen-1.5B-Q4_K_M.gguf Q4_K_M
```

# Serve
```
# Use 65535 ctx size to fit memory. Model native size is 131072, but the memory needs grow by nctx^2.
/data/llama.cpp/build/bin/llama-server -m /data/DeepSeek-R1-Distill-Qwen-1.5B-Q4_K_M.gguf -ngl 256 --ctx-size 65536 --host <YOUR_JETSON_IP>
```

# Stats
With maxn, jetson_clocks running:
~38 tok/sec for q4_k_m, 1.4G mem
~14 tok/sec for fp16, 3.4G mem
