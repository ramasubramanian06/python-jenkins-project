FROM python:3.14-slim

WORKDIR /app

RUN pip install --no-cache-dir Django==6.1.1

COPY . .

RUN python manage.py migrate

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
