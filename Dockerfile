FROM python:3.10

WORKDIR /app

COPY . .

RUN pip install cmake
RUN pip install -r requirements.txt

CMD ["python", "app.py"]
