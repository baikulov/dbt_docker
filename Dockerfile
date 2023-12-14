FROM ubuntu:latest

# Кэширование слоев для ускорения сборки
RUN apt-get update -y && \
    apt-get install -y git python3 python3-pip curl && \
    rm -rf /var/lib/apt/lists/*

# Установка Visual Studio Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Создание директории для SSH-ключей и установка прав
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Создаём рабочую директорию
WORKDIR /dbt

# Добавление SSH-ключа из переменной внутрь контейнера
# Копирование файла с SSH-ключем внутрь контейнера
COPY private_ssh_key /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# Добавление SSH-ключа в известные хосты
ARG GIT_REPO_NAME
RUN touch /root/.ssh/known_hosts && \
    ssh-keyscan "$GIT_REPO_NAME" >> /root/.ssh/known_hosts

# Установка глобальных настроек пользователя Git из переменных окружения
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
RUN git config --global user.email "$GIT_USER_EMAIL" && \
    git config --global user.name "$GIT_USER_NAME"

# Клонирование репозитория из переменной GIT_REPO_URL
ARG GIT_REPO_URL
RUN git clone $GIT_REPO_URL .

# Установка переменной PASSWORD для VSCode
ARG PASSWORD
ENV PASSWORD $PASSWORD

# Копирование и установка зависимостей dbt
COPY requirements.txt /dbt/requirements.txt
RUN pip3 install -r requirements.txt

# Запуск code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "."]
