FROM python:3-alpine

WORKDIR /usr/src/app

COPY requirements.txt .
RUN apk add --no-cache postgresql-libs && \
    apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
    python3 -m pip install -r requirements.txt --no-cache-dir && \
    apk --purge del .build-deps
# RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN python3 manage.py migrate

EXPOSE 8000
CMD [ "python", "./manage.py", "runserver", "0.0.0.0:8000" ]
