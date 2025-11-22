# 🚀 pipeline_data_engineering

Ambiente completo para estudo e execução de pipelines de engenharia de
dados usando AWS Cloud9.

------------------------------------------------------------------------

## 📌 **1. Criar Ambiente**

### **Região obrigatória**

-   **Norte da Virgínia (us-east-1)** --- *não alterar!*

### **Execute no CloudShell da AWS:**

``` bash
curl -sS https://raw.githubusercontent.com/Git-Mota/pipeline_data_engineering/refs/heads/main/environment/create_cloud9.sh | bash
```

------------------------------------------------------------------------

## 📌 **2. Configurar Ambiente**

### **Abra o Cloud9 no console da AWS.**

### Dentro do Cloud9, execute:

``` bash
curl -sS https://raw.githubusercontent.com/Git-Mota/pipeline_data_engineering/refs/heads/main/environment/config_clou9.sh | bash
```

------------------------------------------------------------------------

## 📌 **3. Atualizar pacotes**

Ainda no terminal do Cloud9:

``` bash
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y openjdk-17-jdk
```

------------------------------------------------------------------------

## 📌 **4. Criar ambiente virtual (recomendado)**

``` bash
python3 -m venv .venv
source .venv/bin/activate
pip install pyspark
```
