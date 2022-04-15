FROM python:3-alpine

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN python3 manage.py migrate

EXPOSE 8000
CMD [ "python", "./manage.py", "runserver", "0.0.0.0:8000" ]
