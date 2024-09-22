# Use an official Python image as the base
FROM python:3.9-slim

# Add packages
RUN apt-get update && apt-get install -y adduser git nano default-jre

# Create a new user
RUN useradd -m -s /bin/bash user1

# Set the default user to use when running commands
USER user1

# Set the working directory to the user home directory
WORKDIR /home/user1

# Clone your GitHub repository
# RUN git clone https://github.com/OliveiraEdu/OpenScience
RUN git clone https://github.com/OliveiraEdu/OpenScience.git

# Change into the repository directory
WORKDIR /home/user1/OpenScience


# Set the default command to start JupyterLab
ENV PATH=$PATH:/home/user1/.local/lib/python3.9/site-packages
ENV PATH=$PATH:/home/user1/.local/bin

# Install packages from requirements.txt in the repository
RUN pip install -r requirements.txt
# RUN pip install jupyterlab

CMD ["jupyter", "lab", "--ip=0.0.0.0"]

# Copy the public key out of the container (during RUN command)
RUN echo "Generating SSH key..." && \
    ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub > id_rsa_pub

# Run the git setup script
RUN chmod +x git_setup.sh
RUN ./git_setup.sh
