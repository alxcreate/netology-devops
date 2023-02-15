# Use the official Python image as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the requirements
RUN pip install -r requirements.txt

# Copy the app files into the container
COPY ./app.py .

# Run the command to start the app
CMD ["python", "app.py"]
