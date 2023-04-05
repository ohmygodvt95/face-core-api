FROM python:3.10

WORKDIR /app

RUN pip install cmake
COPY ./requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt
RUN pip install gunicorn
COPY ./entrypoint.sh /var/entrypoint.sh
RUN chmod +x /var/entrypoint.sh

ENTRYPOINT [ "/var/entrypoint.sh" ]
