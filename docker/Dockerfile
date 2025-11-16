# Use the same base image as your Jupyter notebook container
FROM new_jupyter_lab

# Set a working directory inside the container
WORKDIR /app

# Copy the requirements file (if you have one)
# COPY requirements.txt .

# Install Flask and other dependencies
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir flask flask-cors gunicorn

# Copy your Flask API code
# COPY your_flask_api_directory .  # Replace with the directory containing your flask app.py
COPY . .

# Expose the port your Flask app will listen on (default 5000)
EXPOSE 5000 8888

# Set the command to run the Flask app
# CMD ["python", "app.py"]  # Replace app.py with your main Flask file

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "hello:app"]