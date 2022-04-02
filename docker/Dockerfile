# FROM python:3-alpine
FROM python:3

# RUN apk add --no-cache python3-dev py3-pip py3-virtualenv sqlitebrowser

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN python3 manage.py migrate

EXPOSE 8000
CMD [ "python", "./manage.py", "runserver", "0.0.0.0:8000" ]
