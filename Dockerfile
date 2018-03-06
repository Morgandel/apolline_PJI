# Use an official Python runtime as a parent image
FROM jupyterhub/jupyterhub:latest

# Set the working directory to /app
WORKDIR /srv/
WORKDIR /srv/jupyterhub/
RUN pip install jupyterhub-simplespawner && pip install jupyter

# Install any needed packages specified in requirements.txt
# RUN pip install --trusted-host pypi.python.org -r requirements.txt
RUN pip install sudospawner


# Make port 80 available to the world outside this container

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
